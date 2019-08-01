//
//  statsBarManager.m
//  borbskeeper
//
//  Created by juliapark628 on 8/1/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "statsBarManager.h"


@implementation statsBarManager

static int STAT_BAR_CORNER_ROUNDING = 7;
static int STAT_BAR_BORDER_GLOW = .5;


+ (void) drawStatsBarForStat:(borbStat)stat ForBorb:(Borb *)borb inSKView:(SKView *)usersSKView {
    SKScene* barScene = [SKScene nodeWithFileNamed:@"statsBar"];
    barScene.scaleMode = SKSceneScaleModeResizeFill;
    
    [usersSKView presentScene:barScene];
    SKShapeNode *bar = [[SKShapeNode alloc] init];

    if (stat == BORBSTAT_XP) {
        int maxXP = [GameConstants maxXPForExperienceLevel:borb.borbLevel];
        // creating XP Bar
        CGFloat xpBarWidth = (barScene.size.width / maxXP) * [borb.borbExperience intValue];
        CGSize barSize = CGSizeMake(xpBarWidth, barScene.size.height);
        bar = [SKShapeNode shapeNodeWithRectOfSize:barSize cornerRadius:STAT_BAR_CORNER_ROUNDING];
        bar.fillColor = [SKColor yellowColor];
        bar.position = CGPointMake((barScene.size.width / maxXP) * -((maxXP - [borb.borbExperience intValue]) / 2), 0);
        [barScene addChild:bar];
    }
    else if (stat == BORBSTAT_HP) {
        // creating HP bar
        CGFloat hpBarWidth = (barScene.size.width / MAX_HP) * [borb.borbHealth intValue];
        CGSize barSize = CGSizeMake(hpBarWidth, barScene.size.height);
        bar = [SKShapeNode shapeNodeWithRectOfSize:barSize cornerRadius:STAT_BAR_CORNER_ROUNDING];
        bar.fillColor = [SKColor redColor];
        bar.position = CGPointMake((barScene.size.width / MAX_HP) * -((MAX_HP - [borb.borbHealth intValue]) / 2), 0);
        [barScene addChild:bar];
    }
    
    // creating border around bar
    SKShapeNode *emptyBar = [[SKShapeNode alloc] init];
    CGSize emptySize = CGSizeMake(barScene.size.width, barScene.size.height);
    emptyBar = [SKShapeNode shapeNodeWithRectOfSize:emptySize cornerRadius:STAT_BAR_CORNER_ROUNDING];
    if (stat == BORBSTAT_XP) {
        emptyBar.strokeColor = [SKColor yellowColor];
    }
    if (stat == BORBSTAT_HP) {
        emptyBar.strokeColor = [SKColor redColor];
    }
    emptyBar.glowWidth = STAT_BAR_BORDER_GLOW;
    [barScene addChild:emptyBar];
}
@end
