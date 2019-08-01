//
//  LoginViewController.m
//  borbskeeper
//
//  Created by rodrigoandrade on 7/16/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "LoginViewController.h"
#import "BorbParseManager.h"
#import "AlertManager.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation LoginViewController

static NSString *const TASK_LIST_SEGUE_ID = @"taskListSegue";
static NSString *const SIGNUP_SEGUE_ID = @"signUpSegue";

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loginUser {
    [BorbParseManager loginUser:self.usernameField.text withPassword:self.passwordField.text withCompletion: ^(NSError * error) {
        if (error != nil) {
            [AlertManager presentLoginNotSuccesfulAlert:self];
        } else {
            [self performSegueWithIdentifier:TASK_LIST_SEGUE_ID sender:nil];
        }
    }];
}

- (IBAction)didTapLogin:(id)sender {
    [self loginUser];
}
- (IBAction)didTapSignUp:(id)sender {
    [self performSegueWithIdentifier:SIGNUP_SEGUE_ID sender:nil];
}
- (IBAction)didTapLoginView:(id)sender {
    [self.view endEditing:YES];
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
