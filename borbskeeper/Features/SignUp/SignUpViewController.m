//
//  SignUpViewController.m
//  borbskeeper
//
//  Created by rodrigoandrade on 7/16/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "SignUpViewController.h"
#import "BorbParseManager.h"
#import "Task.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation SignUpViewController

static NSString *const TASK_LIST_SEGUE_ID = @"taskListSegue";

static NSString *const UNSUCCESSFUL_LOGIN_ALERT_TITLE = @"Login not succesful";
static NSString *const UNSUCCESSFUL_LOGIN_ALERT_MESSAGE = @"Please return to login screen and try again.";

static NSString *const UNSUCCESSFUL_SIGNUP_ALERT_TITLE = @"Signup not successful";
static NSString *const UNSUCCESSFUL_SIGNUP_ALERT_MESSAGE = @"Please try signing up again.";
static NSString *const OK_ACTION_TITLE = @"OK";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapSignUp:(id)sender {
    UIAlertController *signUpNotSuccessfulAlert = [UIAlertController alertControllerWithTitle:UNSUCCESSFUL_SIGNUP_ALERT_TITLE
                                                                                      message:UNSUCCESSFUL_SIGNUP_ALERT_MESSAGE
                                                                               preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:OK_ACTION_TITLE
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                     }];
    
    [signUpNotSuccessfulAlert addAction:okAction];
    
    UIAlertController *loginNotSuccessfulAlert = [UIAlertController alertControllerWithTitle:UNSUCCESSFUL_LOGIN_ALERT_TITLE
                                                                                     message:UNSUCCESSFUL_LOGIN_ALERT_MESSAGE
                                                                              preferredStyle:(UIAlertControllerStyleAlert)];
    [loginNotSuccessfulAlert addAction:okAction];
    
    if ([Task checkForInvalidTextFields:@[self.usernameField.text, self.passwordField.text, self.emailField.text]] == YES){
        [self presentViewController:signUpNotSuccessfulAlert animated:YES completion:nil];
    } else {
        [BorbParseManager createAccount:self.usernameField.text withEmail:self.emailField.text withPassword:self.passwordField.text withCompletion:^(NSError * error) {
            if (error != nil) {
                [self presentViewController:signUpNotSuccessfulAlert animated:YES completion:nil];
            } else {
                [BorbParseManager loginUser:self.usernameField.text withPassword:self.passwordField.text withCompletion: ^(NSError * error) {
                    if (error != nil) {
                        [self presentViewController:loginNotSuccessfulAlert animated:YES completion:nil];
                    } else {
                        [self performSegueWithIdentifier:TASK_LIST_SEGUE_ID sender:nil];
                    }
                }];
            };
        }];
    }
}

- (IBAction)didTapLogin:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)didTapSignUpView:(id)sender {
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
