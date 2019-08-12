//
//  Borb.m
//  borbskeeper
//
//  Created by juliapark628 on 7/16/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "Borb.h"
#import "PFObject+Subclass.h"
#import "GameConstants.h"

@implementation Borb

@dynamic borbName;
@dynamic borbHealth;
@dynamic borbExperience;
@dynamic borbLevel;
@dynamic borbCoins;

+ (NSString *)parseClassName {
    return @"Borb";
}

- (instancetype)initWithInitialStats {
    self = [super init];
    
    if (self) {
        self.borbName = @"Borb"; 
        self.borbHealth = [NSNumber numberWithInt:MAX_HP];
        self.borbExperience = @0;
        self.borbLevel = @0;
        self.borbCoins = @0;
    }
    return self;
}

- (void)increaseExperiencePointsBy:(int)XP{
    int newXP = [self.borbExperience intValue] + XP;
    
    int currMaxXP = [GameConstants maxXPForExperienceLevel:self.borbLevel];
    
    if (newXP >= currMaxXP) {
        newXP -= currMaxXP;
        self.borbLevel = [NSNumber numberWithInteger:([self.borbLevel intValue] + 1)];
    }
    self.borbExperience = @(newXP);
}

- (void)decreaseExperiencePointsBy:(int)XP{
    int newXP = [self.borbExperience intValue] - XP;
    
    if (newXP < 0) {
        self.borbLevel = [NSNumber numberWithInteger:([self.borbLevel intValue] - 1)];
        if ([self.borbLevel intValue] < 0) {
            self.borbLevel = @0;
            newXP = 0;
        } else {
            int currMaxXP = [GameConstants maxXPForExperienceLevel:self.borbLevel];
            newXP = currMaxXP + newXP;
        }
    }
    self.borbExperience = @(newXP);
}

- (void)increaseHealthPointsBy:(int)HP {
    int newHP = [self.borbHealth intValue] + HP;
    if (newHP > 100){
        newHP = 100;
    }
    self.borbHealth = @(newHP);
}

- (void)decreaseHealthPointsBy:(int)HP {
    int newHP = [self.borbHealth intValue] - HP;
    if (newHP < 0) {
        self.borbLevel = [NSNumber numberWithInteger:([self.borbLevel intValue] - 1)];
        if ([self.borbLevel intValue] < 0) {
            self.borbLevel = @0;
        }
        self.borbExperience = @0;
        self.borbHealth = [NSNumber numberWithInteger:MAX_HP];
    } else {
        self.borbHealth = @(newHP);
    }
}

- (void)feedBorb {
    [self increaseHealthPointsBy:AMOUNT_OF_HP_FOOD_RESTORES];
}

- (void)increaseBorbCoinsBy:(int)numCoins{
    int currentCoins = [self.borbCoins intValue];
    self.borbCoins = @(currentCoins + numCoins);
}

/*
 NOTE: in certain scenarios (e.g. when user marks an complete task incomplete), the user's coins must be allowed to be negative.
 It is the caller's responsibility to check whether this action is invalid or not.
 */
- (void)decreaseBorbCoinsBy:(int)numCoins{
    int currentCoins = [self.borbCoins intValue];
    self.borbCoins = @(currentCoins - numCoins);
}

@end
