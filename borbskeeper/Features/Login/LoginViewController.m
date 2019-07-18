//
//  LoginViewController.m
//  borbskeeper
//
//  Created by rodrigoandrade on 7/16/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "LoginViewController.h"
#import "BorbParseManager.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation LoginViewController

static NSString *const UNSUCCESSFUL_LOGIN_ALERT_TITLE = @"Login not succesful";
static NSString *const UNSUCCESSFUL_LOGIN_ALERT_MESSAGE = @"Please try to login in again.";
static NSString *const OK_ACTION_TITLE = @"OK";

static NSString *const TASK_LIST_SEGUE_ID = @"taskListSegue";
static NSString *const SIGNUP_SEGUE_ID = @"signUpSegue";

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loginUser {
    UIAlertController *loginNotSuccessfulAlert = [UIAlertController alertControllerWithTitle:UNSUCCESSFUL_LOGIN_ALERT_TITLE
                                                                                     message:UNSUCCESSFUL_LOGIN_ALERT_MESSAGE
                                                                              preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:OK_ACTION_TITLE
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                     }];
    [loginNotSuccessfulAlert addAction:okAction];
    
    [BorbParseManager loginUser:self.usernameField.text withPassword:self.passwordField.text withCompletion: ^(NSError * error) {
        if (error != nil) {
            [self presentViewController:loginNotSuccessfulAlert animated:YES completion:nil];
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
