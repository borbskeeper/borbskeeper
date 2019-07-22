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
    // self.borbExperience = @(newXP);
    
    int currMaxXP = [GameConstants maxXPForExperienceLevel:self.borbLevel];
    
    if (newXP >= currMaxXP) {
        newXP -= currMaxXP;
        self.borbLevel = [NSNumber numberWithInteger:([self.borbLevel intValue] + 1)];
    }
    self.borbExperience = @(newXP);
}

- (void)decreaseExperiencePointsBy:(int)XP{
    int currentXP = [self.borbExperience intValue];
    self.borbExperience = @(currentXP - XP);
}

- (void)feedBorb{
    int borbHP = [self.borbHealth intValue];
    borbHP += AMOUNT_OF_HP_FOOD_RESTORES;
    
    if (borbHP > 100){
        borbHP = 100;
    }
    self.borbHealth = @(borbHP);
}

@end
