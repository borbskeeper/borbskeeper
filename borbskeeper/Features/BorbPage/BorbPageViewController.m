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

@interface BorbPageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userCoinsLabel;
@property (weak, nonatomic) IBOutlet UILabel *borbNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *borbLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *borbXPLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxXPLabel;
@property (weak, nonatomic) IBOutlet UILabel *borbHPLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxHPLabel;

@property (weak, nonatomic) IBOutlet UIButton *feedBorbButton;

@property (strong, nonatomic) User *user;

@end

@implementation BorbPageViewController

static NSString *const BORB_MAXHP_ALERT_TITLE = @"This Borb is already full!";
static NSString *const BORB_MAXHP_ALERT_MESSAGE = @"Your Borb is at max HP";

static NSString *const NOT_ENOUGH_COINS_ALERT_TITLE = @"Not enough Coins!";
static NSString *const NOT_ENOUGH_COINS_ALERT_MESSAGE = @"You need at tleast 7 coins to feed your Borb";

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
        
        self.userCoinsLabel.text = [NSString stringWithFormat:@"%@", self.user.userCoins];
        self.borbNameLabel.text = borb.borbName;
        self.borbLevelLabel.text = [NSString stringWithFormat:@"%@", borb.borbLevel];
        
        self.borbXPLabel.text = [NSString stringWithFormat:@"%@", borb.borbExperience];
        int borbsMaxXP = [GameConstants maxXPForExperienceLevel:borb.borbLevel];
        self.maxXPLabel.text = [NSString stringWithFormat:@"/ %d", borbsMaxXP];
        
        self.borbHPLabel.text = [NSString stringWithFormat:@"%@", borb.borbHealth];
        self.maxHPLabel.text = [NSString stringWithFormat:@"/ %d", MAX_HP];
    }];
}

- (IBAction)didTapFeed:(id)sender {
    UIAlertController *cannotFeedBorbAlert = [UIAlertController alertControllerWithTitle:BORB_MAXHP_ALERT_TITLE
                                                                                      message:BORB_MAXHP_ALERT_MESSAGE
                                                                               preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:OK_ACTION_TITLE
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                     }];
    
    [cannotFeedBorbAlert addAction:okAction];
    
    UIAlertController *notEnoughCoinsAlert = [UIAlertController alertControllerWithTitle:NOT_ENOUGH_COINS_ALERT_TITLE
                                                                                 message:NOT_ENOUGH_COINS_ALERT_MESSAGE
                                                                          preferredStyle:(UIAlertControllerStyleAlert)];
    
    [notEnoughCoinsAlert addAction:okAction];
    
    if ([self.user.userCoins intValue] < FOOD_COST){
        [self presentViewController:notEnoughCoinsAlert animated:YES completion:nil];

    } else {
        [BorbParseManager fetchBorb:self.user.usersBorb.objectId WithCompletion:^(NSMutableArray *borbs) {
            
            Borb *borb = borbs[0];
            
            if ([borb.borbHealth intValue] == MAX_HP){
                [self presentViewController:cannotFeedBorbAlert animated:YES completion:nil];
            
            } else {
                [Borb feedBorb:borb];
                [User decreaseUserCoins:self.user byCoins:FOOD_COST];

                [BorbParseManager saveBorb:borb withCompletion:nil];
                [BorbParseManager saveUser:self.user withCompletion:nil];
                [self reloadData];
            }
        }];
    }
}

- (IBAction)didTapXPBoost:(id)sender {
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
