//
//  GameConstants.h
//  borbskeeper
//
//  Created by juliapark628 on 7/22/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <Foundation/Foundation.h>

extern int const MAX_HP;

extern int const COIN_REWARD_WITHOUT_VERIFY;
extern int const COIN_REWARD_WITH_VERIFY;
extern int const COIN_REWARD_OPTOUT;

extern int const AMOUNT_OF_HP_FOOD_RESTORES;
extern int const FOOD_COST;
extern int const AMOUNT_OF_XP_FROM_BOOST;
extern int const XP_BOOST_COST; 

extern int const BORB_HP_DECAY_PER_HOUR;
extern int const BORB_HP_DECAY_PER_INCOMPLETE_TASK;

extern int const XP_GAINED_PER_COMPLETE_TASK;

NS_ASSUME_NONNULL_BEGIN

@interface GameConstants : NSObject

+ (int) maxXPForExperienceLevel:(NSNumber *)borbLevel;

@end

NS_ASSUME_NONNULL_END
