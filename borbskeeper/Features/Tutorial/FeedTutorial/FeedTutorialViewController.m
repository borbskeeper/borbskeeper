//
//  FeedTutorialViewController.m
//  borbskeeper
//
//  Created by rodrigoandrade on 8/8/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "FeedTutorialViewController.h"

@interface FeedTutorialViewController ()
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation FeedTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nextButton.layer.cornerRadius = 5;
    self.nextButton.clipsToBounds = YES;
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
