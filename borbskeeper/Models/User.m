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
@dynamic username;
@dynamic userCoins;
@dynamic friendsList;
@dynamic profilePicture;
@dynamic usersBorb;

+ (void)increaseUserCoins:(User*)user byCoins:(int)numCoins{
    int currentCoins = [user.userCoins intValue];
    user.userCoins = @(currentCoins + numCoins);
}

+ (void)decreaseUserCoins:(User*)user byCoins:(int)numCoins{
    int currentCoins = [user.userCoins intValue];
    user.userCoins = @(currentCoins - numCoins);
}
@end
