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
@dynamic borbPicture;

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
        
        UIImage *defaultImage = [UIImage imageNamed:@"borb_original"];
        NSData *imageData = UIImagePNGRepresentation(defaultImage);
        self.borbPicture = [PFFileObject fileObjectWithName:@"borb.png" data:imageData];

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
    int newXP = [self.borbExperience intValue] + XP;
    
    if (newXP < 0) {
        self.borbLevel = [NSNumber numberWithInteger:([self.borbLevel intValue] - 1)];
        int currMaxXP = [GameConstants maxXPForExperienceLevel:self.borbLevel];
        newXP = currMaxXP + newXP;
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
        self.borbExperience = @0;
        self.borbHealth = [NSNumber numberWithInteger:MAX_HP];
    }
    else {
        self.borbHealth = @(newHP);
    }
}


- (void)feedBorb {
    [self increaseHealthPointsBy:AMOUNT_OF_HP_FOOD_RESTORES];
}

@end
