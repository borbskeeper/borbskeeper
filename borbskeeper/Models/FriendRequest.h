//
//  FriendRequest.h
//  borbskeeper
//
//  Created by rodrigoandrade on 8/1/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendRequest : PFObject <PFSubclassing>

@property (nonatomic, strong) User *sender;
@property (nonatomic, strong) User *recipient;

+ (void)acceptFriendRequest;
+ (void)rejectFriendRequest;
+ (FriendRequest*)createFriendRequestWithSender:(User*)sender withRecipient:(User*)recipient;

@end

NS_ASSUME_NONNULL_END
