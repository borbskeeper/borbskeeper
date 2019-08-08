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
#import "AlertManager.h"

@interface SignUpViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation SignUpViewController

static NSString *const TASK_LIST_SEGUE_ID = @"taskListSegue";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.signUpButton.layer.cornerRadius = 5;
    self.signUpButton.clipsToBounds = YES;
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    self.emailField.delegate = self;
}

- (IBAction)didTapSignUp:(id)sender {
    if ([AlertManager isInvalidTextField:@[self.usernameField.text, self.passwordField.text, self.emailField.text]] == YES){
        [AlertManager presentSignUpNotSuccesfulAlert:self];
    } else {
        [BorbParseManager createAccount:self.usernameField.text withEmail:self.emailField.text withPassword:self.passwordField.text withCompletion:^(NSError * error) {
            if (error != nil) {
                [AlertManager presentSignUpNotSuccesfulAlert:self];
            } else {
                [BorbParseManager loginUser:self.usernameField.text withPassword:self.passwordField.text withCompletion: ^(NSError * error) {
                    if (error != nil) {
                        [AlertManager presentLoginAfterSignupNotSuccesfulAlert:self];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
