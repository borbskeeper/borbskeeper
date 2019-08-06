//
//  FriendCell.m
//  borbskeeper
//
//  Created by rodrigoandrade on 8/2/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "FriendCell.h"
#import "UIImageView+AFNetworking.h"

@implementation FriendCell
static NSString *const USER_PROF_PIC_KEY = @"profilePicture";

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupWithFriend:(User *)friend withBorb:(Borb *)friendsBorb{
    self.friendProfile = friend;
    self.friendBorb = friendsBorb;
    
    self.userName.text = friend.username;
    self.borbName.text = friendsBorb.borbName;
    self.borbLevel.text = [NSString stringWithFormat:@"Level %@", friendsBorb.borbLevel];
    self.borbExperience.text = [NSString stringWithFormat:@"XP %@", friendsBorb.borbExperience];
    
    PFFileObject *profileImageFile = friend[USER_PROF_PIC_KEY];
    NSURL *profileImageURL = [NSURL URLWithString:profileImageFile.url];
    [self.profilePicture setImageWithURL:profileImageURL];
}
@end
