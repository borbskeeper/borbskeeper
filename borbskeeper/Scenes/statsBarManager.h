//
//  statsBarManager.h
//  borbskeeper
//
//  Created by juliapark628 on 8/1/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Borb.h"
#import "GameConstants.h"
#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface statsBarManager : NSObject

typedef enum {
    BORBSTAT_HP,
    BORBSTAT_XP
} borbStat;

+ (void) drawStatsBarForStat:(borbStat)stat ForBorb:(Borb *)borb inSKView:(SKView *)usersSKView ; 

@end

NS_ASSUME_NONNULL_END
