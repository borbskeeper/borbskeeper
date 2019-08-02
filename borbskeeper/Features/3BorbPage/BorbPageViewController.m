//
//  BorbPageViewController.m
//  borbskeeper
//
//  Created by juliapark628 on 7/19/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "BorbPageViewController.h"
#import "GameConstants.h"
#import "BorbParseManager.h"
#import "Borb.h"
#import <SpriteKit/SpriteKit.h>
#import "statsBarManager.h"
#import "AlertManager.h"

@interface BorbPageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userCoinsLabel;
@property (weak, nonatomic) IBOutlet UILabel *borbNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *borbLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *borbXPLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxXPLabel;
@property (weak, nonatomic) IBOutlet UILabel *borbHPLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxHPLabel;

@property (weak, nonatomic) IBOutlet UIButton *feedBorbButton;

@property (weak, nonatomic) IBOutlet SKView *hpBarSKView;
@property (weak, nonatomic) IBOutlet SKView *xpBarSKView;


@property (strong, nonatomic) User *user;

@end

@implementation BorbPageViewController

static NSString *const OK_ACTION_TITLE = @"OK";

- (void)viewWillAppear:(BOOL)animated{
    self.user = [User currentUser];
    [self reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)reloadData {
    [BorbParseManager fetchBorb:self.user.usersBorb.objectId WithCompletion:^(NSMutableArray *borbs) {
        Borb *borb = borbs[0];
        
        self.userCoinsLabel.text = [NSString stringWithFormat:@"Coins: %@", self.user.userCoins];
        self.borbNameLabel.text = borb.borbName;
        self.borbLevelLabel.text = [NSString stringWithFormat:@"Level %@", borb.borbLevel];
        
        self.borbXPLabel.text = [NSString stringWithFormat:@"%@", borb.borbExperience];
        int borbsMaxXP = [GameConstants maxXPForExperienceLevel:borb.borbLevel];
        self.maxXPLabel.text = [NSString stringWithFormat:@"/ %d", borbsMaxXP];
        
        self.borbHPLabel.text = [NSString stringWithFormat:@"%@", borb.borbHealth];
        self.maxHPLabel.text = [NSString stringWithFormat:@"/ %d", MAX_HP];
        
        [statsBarManager drawStatsBarForStat:BORBSTAT_XP ForBorb:borb inSKView:self.xpBarSKView];
        [statsBarManager drawStatsBarForStat:BORBSTAT_HP ForBorb:borb inSKView:self.hpBarSKView];
    }];
}

- (IBAction)didTapFeed:(id)sender {
    if ([self.user.userCoins intValue] < FOOD_COST){
        [AlertManager presentNotEnoughCoinsToFeedAlert:self];
    } else {
        [BorbParseManager fetchBorb:self.user.usersBorb.objectId WithCompletion:^(NSMutableArray *borbs) {
            Borb *borb = borbs[0];
            
            if ([borb.borbHealth intValue] == MAX_HP){
                [AlertManager presentCannotFeedBorbMaxHPAlert:self];
            } else {
                [borb feedBorb];
                [self.user decreaseUserCoinsBy:FOOD_COST];

                [BorbParseManager saveBorb:borb withCompletion:nil];
                [BorbParseManager saveUser:self.user withCompletion:nil];
                [self reloadData];
            }
        }];
    }
}

- (IBAction)didTapXPBoost:(id)sender {
    if ([self.user.userCoins intValue] < XP_BOOST_COST){
        [AlertManager presentNotEnoughCoinsToBoostXPAlert:self];
    } else {
        [BorbParseManager fetchBorb:self.user.usersBorb.objectId WithCompletion:^(NSMutableArray *borbs) {
            Borb *borb = borbs[0];
        
            [borb increaseExperiencePointsBy:AMOUNT_OF_XP_FROM_BOOST];
            [self.user decreaseUserCoinsBy:XP_BOOST_COST];
            
            [BorbParseManager saveBorb:borb withCompletion:nil];
            [BorbParseManager saveUser:self.user withCompletion:nil];
            [self reloadData];
        }];
    }
}

- (IBAction)didTapRenameBorb:(id)sender {
    [AlertManager presentRenameBorbAlert:self withCompletion:^(NSString * _Nonnull newName) {
        if ([AlertManager isInvalidTextField:@[newName]]) {
            [AlertManager presentRenameNotSuccessfulAlert:self];
        } else {
            [BorbParseManager fetchBorb:self.user.usersBorb.objectId WithCompletion:^(NSMutableArray *borbs) {
                Borb *borb = borbs[0];
                borb.borbName = newName;
                [BorbParseManager saveBorb:borb withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        [self reloadData];
                    } else {
                        [AlertManager presentRenameNotSuccessfulAlert:self];
                    }
                }];
            }];
        }
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end