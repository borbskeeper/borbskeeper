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
static NSString *const NOT_ENOUGH_COINS_FEED_ALERT_MESSAGE = @"You need at least 7 coins to feed your Borb";
static NSString *const NOT_ENOUGH_COINS_XPBOOST_ALERT_MESSAGE = @"You need at least 75 coins to boost your Borb's XP";


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
                                                                                 message:NOT_ENOUGH_COINS_FEED_ALERT_MESSAGE
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
    UIAlertController *notEnoughCoinsAlert = [UIAlertController alertControllerWithTitle:NOT_ENOUGH_COINS_ALERT_TITLE
                                                                                 message:NOT_ENOUGH_COINS_XPBOOST_ALERT_MESSAGE
                                                                          preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:OK_ACTION_TITLE
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                     }];
    [notEnoughCoinsAlert addAction:okAction];
    
    if ([self.user.userCoins intValue] < XP_BOOST_COST){
        [self presentViewController:notEnoughCoinsAlert animated:YES completion:nil];
        
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
    UIAlertController *renameBorbAlert = [UIAlertController alertControllerWithTitle:@"Rename your borb!"
                                                                             message:@"Enter a new name: "
                                                                      preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                     }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:OK_ACTION_TITLE
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         NSString* newName = renameBorbAlert.textFields[0].text;
                                                         
                                                         NSLog(@"%@", newName);
                                                         [BorbParseManager fetchBorb:self.user.usersBorb.objectId WithCompletion:^(NSMutableArray *borbs) {
                                                             Borb *borb = borbs[0];
                                                             borb.borbName = newName;
                                                             [BorbParseManager saveBorb:borb withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                                                                 if (succeeded) {
                                                                     [self reloadData];
                                                                 }
                                                                 else {
                                                                     NSLog(@"%@", error.localizedDescription);
                                                                     
                                                                     UIAlertController *renameErrorAlert = [UIAlertController alertControllerWithTitle:@"Unable to save borb name."
                                                                                                                                              message:@"There was an error. Please try again."
                                                                                                                                       preferredStyle:(UIAlertControllerStyleAlert)];
                                                                     UIAlertAction *okAction = [UIAlertAction actionWithTitle:OK_ACTION_TITLE
                                                                                                                        style:UIAlertActionStyleDefault
                                                                                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                                                                                      }];
                                                                     [renameErrorAlert addAction:okAction];
                                                                     [self presentViewController:renameErrorAlert animated:YES completion:nil];
                                                                 }
                                                             }];
                                                         }];
                                                     }];
    
    [renameBorbAlert addAction:cancelAction];
    [renameBorbAlert addAction:okAction];
    [renameBorbAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"New borb name";
    }];
    
    [self presentViewController:renameBorbAlert animated:YES completion:nil];
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
