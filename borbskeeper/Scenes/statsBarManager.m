//
//  statsBarManager.m
//  borbskeeper
//
//  Created by juliapark628 on 8/1/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "statsBarManager.h"


@implementation statsBarManager

static int STAT_BAR_CORNER_ROUNDING = 8;
static int STAT_BAR_BORDER_GLOW = 1.5;


+ (void) drawStatsBarForStat:(borbStat)stat ForBorb:(Borb *)borb inSKView:(SKView *)usersSKView {
    SKScene* barScene = [SKScene nodeWithFileNamed:@"statsBar"];
    barScene.scaleMode = SKSceneScaleModeResizeFill;
    
    [usersSKView presentScene:barScene];
    SKShapeNode *bar = [[SKShapeNode alloc] init];

    if (stat == BORBSTAT_XP) {
        double maxXP = (double)[GameConstants maxXPForExperienceLevel:borb.borbLevel];
        // creating XP Bar
        CGFloat xpBarWidth = (barScene.size.width / maxXP) * [borb.borbExperience doubleValue];
        CGSize barSize = CGSizeMake(xpBarWidth, barScene.size.height);
        bar = [SKShapeNode shapeNodeWithRectOfSize:barSize cornerRadius:STAT_BAR_CORNER_ROUNDING];
        bar.fillColor = [SKColor yellowColor];
        bar.position = CGPointMake((barScene.size.width / maxXP) * -((maxXP - [borb.borbExperience doubleValue]) / 2.0), 0);
        [barScene addChild:bar];
    } else if (stat == BORBSTAT_HP) {
        // creating HP bar
        double borbHealth = [borb.borbHealth doubleValue];
        
        CGFloat hpBarWidth = (barScene.size.width / (double)MAX_HP) * borbHealth;
        CGSize barSize = CGSizeMake(hpBarWidth, barScene.size.height);
        bar = [SKShapeNode shapeNodeWithRectOfSize:barSize cornerRadius:STAT_BAR_CORNER_ROUNDING];
        if (borbHealth > LOW_HP_THRESHOLD) {
            bar.fillColor = [SKColor greenColor];
        /*} else if (borbHealth > LOW_HP_THRESHOLD) {
            bar.fillColor = [SKColor yellowColor];*/
        } else {
            bar.fillColor = [SKColor redColor];
        }
        bar.position = CGPointMake((barScene.size.width / (double)MAX_HP) * -(((double)MAX_HP - borbHealth) / 2.0), 0);
        [barScene addChild:bar];
    }
    
    // creating border around bar
    SKShapeNode *emptyBar = [[SKShapeNode alloc] init];
    CGSize emptySize = CGSizeMake(barScene.size.width, barScene.size.height);
    emptyBar = [SKShapeNode shapeNodeWithRectOfSize:emptySize cornerRadius:STAT_BAR_CORNER_ROUNDING];
    if (stat == BORBSTAT_XP) {
        emptyBar.strokeColor = [SKColor orangeColor];
    } else if (stat == BORBSTAT_HP) {
        double borbHealth = [borb.borbHealth doubleValue];
        if (borbHealth > LOW_HP_THRESHOLD) {
            emptyBar.strokeColor = [SKColor greenColor];
        /*} else if (borbHealth > LOW_HP_THRESHOLD) {
            emptyBar.strokeColor = [SKColor yellowColor];*/
        } else {
            emptyBar.strokeColor = [SKColor redColor];
        }
    }
    emptyBar.glowWidth = STAT_BAR_BORDER_GLOW;
    [barScene addChild:emptyBar];
}
@end
