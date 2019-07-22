//
//  GameConstants.m
//  borbskeeper
//
//  Created by juliapark628 on 7/22/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "GameConstants.h"

const int MAX_HP = 100;

const int COIN_REWARD_WITHOUT_VERIFY = 1;
const int COIN_REWARD_WITH_VERIFY = 10;
const int COIN_REWARD_OPTOUT = 5;

const int AMOUNT_OF_HP_FOOD_RESTORES = 15;
const int FOOD_COST = 7;
const int BORB_HP_DECAY_PER_HOUR = 1;
const int BORB_HP_DECAY_PER_INCOMPLETE_TASK = 6;

const int XP_GAINED_PER_COMPLETE_TASK = 13;

@implementation GameConstants

+ (int) maxXPForExperienceLevel:(NSNumber *)borbLevel {
    
    if (borbLevel.integerValue == 0) {
        return 50;
    } else if (borbLevel.integerValue == 1) {
        return 75;
    } else if (borbLevel.integerValue == 2) {
        return 115;
    } else if (borbLevel.integerValue == 3) {
        return 175;
    } else if (borbLevel.integerValue == 4) {
        return 265;
    } else if (borbLevel.integerValue == 5) {
        return 400;
    } else if (borbLevel.integerValue == 6) {
        return 600;
    } else {
        return 900;
    }
 }

@end


