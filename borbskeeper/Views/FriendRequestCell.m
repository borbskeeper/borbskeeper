//
//  FriendRequestCell.m
//  borbskeeper
//
//  Created by rodrigoandrade on 8/1/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "FriendRequestCell.h"
#import "DateTools.h"
#import "UIImageView+AFNetworking.h"
#import "BorbParseManager.h"
#import "FriendsList.h"

@implementation FriendRequestCell
static NSString *const USER_PROF_PIC_KEY = @"profilePicture";

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithFriendRequest:(FriendRequest *)friendRequest {
    self.friendRequest = friendRequest;
    User *sender = friendRequest.sender;
    self.userName.text = sender.username;
    
    PFFileObject *profileImageFile = sender[USER_PROF_PIC_KEY];
    NSURL *profileImageURL = [NSURL URLWithString:profileImageFile.url];
    [self.profilePicture setImageWithURL:profileImageURL];
    
    NSString *formattedDate = friendRequest.createdAt.shortTimeAgoSinceNow;
    self.timeAgo.text = formattedDate;
    self.didInteractWithRequest = NO;
}

- (IBAction)didTapConfirm:(id)sender {
    if (!self.didInteractWithRequest){
        // NSLog(@"Friend Request: %@", self.friendRequest);
        self.didInteractWithRequest = YES;
        User *sender = self.friendRequest.sender;
        User *recipient = self.friendRequest.recipient;
        
        [BorbParseManager deleteFriendRequest:self.friendRequest WithCompletion:^(BOOL succeeded) {
            if (!succeeded){
                self.didInteractWithRequest = NO;
            } else {
                [BorbParseManager fetchFriendListFromID:recipient.friendsListID withCompletion:^(FriendsList *recipientFriendList) {
                    if (recipientFriendList != nil){
                        recipientFriendList.friends = [recipientFriendList.friends arrayByAddingObject:sender.objectId];
                        [BorbParseManager saveFriendsList:recipientFriendList withCompletion:nil];
                    }
                }];
                
                [BorbParseManager fetchFriendListFromID:sender.friendsListID withCompletion:^(FriendsList *senderFriendList) {
                    if (senderFriendList != nil){
                        senderFriendList.friends = [senderFriendList.friends arrayByAddingObject:recipient.objectId];
                        [BorbParseManager saveFriendsList:senderFriendList withCompletion:nil];
                    }
                }];
            }
            [self.delegate didInteractWithFriendRequest];
        }];
    }
}

- (IBAction)didTapDeleteRequest:(id)sender {
    if (!self.didInteractWithRequest){
        self.didInteractWithRequest = YES;
        
        [BorbParseManager deleteFriendRequest:self.friendRequest WithCompletion:^(BOOL succeeded) {
            if (!succeeded){
                self.didInteractWithRequest = NO;
            } else {
                [self.delegate didInteractWithFriendRequest];
            }
        }];
    }
}

@end
