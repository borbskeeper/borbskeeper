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
        self.borbExperience = @(0);
        
        UIImage *defaultImage = [UIImage imageNamed:@"borb_original"];
        NSData *imageData = UIImagePNGRepresentation(defaultImage);
        self.borbPicture = [PFFileObject fileObjectWithName:@"borb.png" data:imageData];

    }
    
    return self;
}

+ (void)increaseBorbExperience:(Borb*)borb byExperiencePoints:(int)XP{
    // NSLog(@"%@, %@", borb, borb.borbExperience);
    int currentXP = [borb.borbExperience intValue];
    borb.borbExperience = @(currentXP + XP);
}

+ (void)decreaseBorbExperience:(Borb*)borb byExperiencePoints:(int)XP{
    int currentXP = [borb.borbExperience intValue];
    borb.borbExperience = @(currentXP - XP);
}

+ (void)feedBorb:(Borb*)borb {
    int borbHP = [borb.borbHealth intValue];
    borbHP += AMOUNT_OF_HP_FOOD_RESTORES;
    
    if (borbHP > 100){
        borbHP = 100;
    }
    borb.borbHealth = @(borbHP);
}

@end
