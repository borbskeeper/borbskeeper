//
//  FriendRequestCell.h
//  borbskeeper
//
//  Created by rodrigoandrade on 8/1/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendRequest.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FriendRequestDelegate
- (void)didInteractWithFriendRequest;

@end

@interface FriendRequestCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *timeAgo;
@property (strong, nonatomic) FriendRequest *friendRequest;
@property (assign, nonatomic) BOOL didInteractWithRequest;
@property (nonatomic, weak) id <FriendRequestDelegate> delegate;

- (void)setupWithFriendRequest:(FriendRequest *)friendRequest;

@end

NS_ASSUME_NONNULL_END
