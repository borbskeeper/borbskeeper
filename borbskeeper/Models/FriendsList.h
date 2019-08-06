//
//  FriendsList.h
//  borbskeeper
//
//  Created by rodrigoandrade on 8/2/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendsList : PFObject <PFSubclassing>

@property (nonatomic, strong) NSArray *friends;

+ (FriendsList*)createFriendsList;

@end

NS_ASSUME_NONNULL_END
