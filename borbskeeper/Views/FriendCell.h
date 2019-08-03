//
//  FriendCell.h
//  borbskeeper
//
//  Created by rodrigoandrade on 8/2/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Borb.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *borbName;
@property (weak, nonatomic) IBOutlet UILabel *borbLevel;
@property (weak, nonatomic) IBOutlet UILabel *borbExperience;
@property (strong, nonatomic) User *friendProfile;
@property (strong, nonatomic) Borb *friendBorb;

- (void)setupWithFriend:(User *)friend withBorb:(Borb *)friendsBorb;

@end

NS_ASSUME_NONNULL_END
