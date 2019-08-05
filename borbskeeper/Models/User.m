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
@dynamic userLogin;
@dynamic remindTime;


- (void)increaseUserCoinsBy:(int)numCoins{
    int currentCoins = [self.userCoins intValue];
    self.userCoins = @(currentCoins + numCoins);
}

/*
 NOTE: in certain scenarios (e.g. when user marks an complete task incomplete), the user's coins must be allowed to be negative.
 It is the caller's responsibility to check whether this action is invalid or not.
*/
- (void)decreaseUserCoinsBy:(int)numCoins{
    int currentCoins = [self.userCoins intValue];
    self.userCoins = @(currentCoins - numCoins);
}
@end
