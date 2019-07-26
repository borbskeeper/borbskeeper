//
//  ComposePostViewController.m
//  borbskeeper
//
//  Created by juliapark628 on 7/26/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "ComposePostViewController.h"

@interface ComposePostViewController ()

@end

@implementation ComposePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapCancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
