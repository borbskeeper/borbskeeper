//
//  BorbPageViewController.m
//  borbskeeper
//
//  Created by juliapark628 on 7/19/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "BorbPageViewController.h"
#import "GameConstants.h"

@interface BorbPageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userCoinsLabel;
@property (weak, nonatomic) IBOutlet UILabel *borbNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *borbLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *borbXPLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxXPLabel;
@property (weak, nonatomic) IBOutlet UILabel *borbHPLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxHPLabel;

@property (strong, nonatomic) User *user;

@end

@implementation BorbPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [User currentUser];
    [self setUpView];
}

- (void)setUpView {
    self.userCoinsLabel.text = [NSString stringWithFormat:@"%@", self.user.userCoins];
    self.borbNameLabel.text = self.user.usersBorb.borbName;
    self.borbLevelLabel.text = [NSString stringWithFormat:@"%@", self.user.usersBorb.borbLevel];
    self.borbXPLabel.text = [NSString stringWithFormat:@"%@", self.user.usersBorb.borbExperience];
    
    int borbsMaxXP = [GameConstants maxXPForExperienceLevel:self.user.usersBorb.borbLevel];
    self.maxXPLabel.text = [NSString stringWithFormat:@"%d", borbsMaxXP];
    
    self.borbHPLabel.text = [NSString stringWithFormat:@"%@", self.user.usersBorb.borbHealth];
    self.maxHPLabel.text = [NSString stringWithFormat:@"%d", MAX_HP];
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
