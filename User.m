//
//  User.m
//  borbskeeper
//
//  Created by juliapark628 on 7/16/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "User.h"

@implementation User

@dynamic screenname;
@dynamic userCoins;
@dynamic friendsList;
@dynamic incompleteTaskList;
@dynamic completeTaskList;
@dynamic profilePicture;
@dynamic usersBorb;

+ (nonnull NSString *)parseClassName {
    return @"user";
}

@end
