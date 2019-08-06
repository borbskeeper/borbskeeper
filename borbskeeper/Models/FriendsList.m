//
//  FriendsList.m
//  borbskeeper
//
//  Created by rodrigoandrade on 8/2/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "FriendsList.h"

@implementation FriendsList

@dynamic friends;

+ (NSString *)parseClassName {
    return @"FriendsList";
}

+ (FriendsList*)createFriendsList{
    FriendsList *friendsList = [FriendsList new];
    friendsList.friends = @[];
    return friendsList;
}

@end
