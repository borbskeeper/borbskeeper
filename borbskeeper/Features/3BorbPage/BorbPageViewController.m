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
#import "FLAnimatedImage.h"

@interface BorbPageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *borbCoinsLabel;
@property (weak, nonatomic) IBOutlet UILabel *borbNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *borbLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *borbXPLabel;
@property (weak, nonatomic) IBOutlet UILabel *borbHPLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eggImageView;

@property (weak, nonatomic) IBOutlet UIButton *feedBorbButton;

@property (weak, nonatomic) IBOutlet SKView *hpBarSKView;
@property (weak, nonatomic) IBOutlet SKView *xpBarSKView;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *borbView;

@property (strong, nonatomic) User *user;

@end

@implementation BorbPageViewController

- (void)viewWillAppear:(BOOL)animated{
    self.user = [User currentUser];
    [self reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    self.backgroundView.layer.cornerRadius = 20;
    self.backgroundView.clipsToBounds = YES;
}

- (void) setupBorb {
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i.imgur.com/NJpq7VU.gif"]]];
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.animatedImage = image;
    imageView.frame = self.borbView.frame;
    imageView.tag = 1;
    [self.view addSubview:imageView];
}

- (void) setupNavBar {
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName:[UIFont fontWithName:@"OpenSans-SemiBold" size:18]}];
}

- (void)reloadData {
    [BorbParseManager fetchBorb:self.user.usersBorb.objectId WithCompletion:^(NSMutableArray *borbs) {
        Borb *borb = borbs[0];
        
        if ([borb.borbLevel isEqual:@0]) {
            for (UIView *subview in [self.view subviews]) {
                if (subview.tag == 1) {
                    [subview removeFromSuperview];
                }
            }
            self.eggImageView.hidden = NO;
        } else {
            if (!self.eggImageView.hidden) {
                self.eggImageView.hidden = YES;
                [self setupBorb];
            }
        }
        
        self.borbCoinsLabel.text = [NSString stringWithFormat:@"%@", borb.borbCoins];
        self.borbNameLabel.text = borb.borbName;
        self.borbLevelLabel.text = [NSString stringWithFormat:@"LEVEL %@", borb.borbLevel];
        int borbsMaxXP = [GameConstants maxXPForExperienceLevel:borb.borbLevel];
        self.borbXPLabel.text = [NSString stringWithFormat:@"%@ / %d", borb.borbExperience, borbsMaxXP];
        
        self.borbHPLabel.text = [NSString stringWithFormat:@"%@ / %d ", borb.borbHealth, MAX_HP];
        
        [statsBarManager drawStatsBarForStat:BORBSTAT_XP ForBorb:borb inSKView:self.xpBarSKView];
        [statsBarManager drawStatsBarForStat:BORBSTAT_HP ForBorb:borb inSKView:self.hpBarSKView];
    }];
}

- (IBAction)didTapFeed:(id)sender {
    [BorbParseManager fetchBorb:self.user.usersBorb.objectId WithCompletion:^(NSMutableArray *borbs) {
        Borb *borb = borbs[0];
        if ([borb.borbCoins intValue] < FOOD_COST){
            [AlertManager presentNotEnoughCoinsToFeedAlert:self];
        } else {
            if ([borb.borbHealth intValue] == MAX_HP){
                [AlertManager presentCannotFeedBorbMaxHPAlert:self];
            } else {
                [borb feedBorb];
                [borb decreaseBorbCoinsBy:FOOD_COST];
            }
        }
        [BorbParseManager saveBorb:borb withCompletion:nil];
        [self reloadData];
    }];
}

- (IBAction)didTapXPBoost:(id)sender {
    [BorbParseManager fetchBorb:self.user.usersBorb.objectId WithCompletion:^(NSMutableArray *borbs) {
        Borb *borb = borbs[0];
        if ([borb.borbCoins intValue] < XP_BOOST_COST) {
             [AlertManager presentNotEnoughCoinsToBoostXPAlert:self];
        } else {
            [borb increaseExperiencePointsBy:AMOUNT_OF_XP_FROM_BOOST];
            [borb decreaseBorbCoinsBy:XP_BOOST_COST];
        }
        [BorbParseManager saveBorb:borb withCompletion:nil];
        [self reloadData];
    }];
}

- (IBAction)didTapRenameBorb:(id)sender {
    [AlertManager presentRenameBorbAlert:self withCompletion:^(NSString * _Nonnull newName) {
        if ([AlertManager isInvalidTextField:@[newName]]) {
            [AlertManager presentInvalidBorbNameAlert:self];
        } else {
            [BorbParseManager fetchBorb:self.user.usersBorb.objectId WithCompletion:^(NSMutableArray *borbs) {
                Borb *borb = borbs[0];
                borb.borbName = newName;
                [BorbParseManager saveBorb:borb withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        [self reloadData];
                    } else {
                        [AlertManager presentGenericErrorAlert:self withFailedAction:@"Saving the borb's name" andMessageToTry:@"try again."];
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
