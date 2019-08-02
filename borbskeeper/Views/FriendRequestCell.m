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
    User *sender = friendRequest.sender;
    self.userName.text = sender.username;
    
    PFFileObject *profileImageFile = sender[USER_PROF_PIC_KEY];
    NSURL *profileImageURL = [NSURL URLWithString:profileImageFile.url];
    [self.profilePicture setImageWithURL:profileImageURL];
    
    NSString *formattedDate = friendRequest.createdAt.shortTimeAgoSinceNow;
    self.timeAgo.text = formattedDate;
}

- (IBAction)didTapConfirm:(id)sender {
}

- (IBAction)didTapDeleteRequest:(id)sender {
}



@end
