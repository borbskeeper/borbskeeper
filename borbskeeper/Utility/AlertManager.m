//
//  AlertManager.m
//  borbskeeper
//
//  Created by rodrigoandrade on 7/31/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "AlertManager.h"


@implementation AlertManager

// Alert Titles
static NSString *const UNSUCCESSFUL_LOGIN_ALERT_TITLE = @"Login not succesful";
static NSString *const UNSUCCESSFUL_SIGNUP_ALERT_TITLE = @"Signup not successful";

static NSString *const UNSUCCESSFUL_TASK_SAVE_TITLE = @"Could not save task";

static NSString *const RENAME_BORB_ALERT_TITLE = @"Rename your borb!";
static NSString *const BORB_MAXHP_ALERT_TITLE = @"This Borb is already full!";
static NSString *const NOT_ENOUGH_COINS_ALERT_TITLE = @"Not enough Coins!";

// Alert Messages
static NSString *const UNSUCCESSFUL_LOGIN_ALERT_MESSAGE = @"Please try to login in again.";
static NSString *const UNSUCCESSFUL_SIGNUP_ALERT_MESSAGE = @"Please try signing up again.";
static NSString *const UNSUCCESSFUL_LOGIN_UPON_SIGNUP_ALERT_MESSAGE = @"Please return to login screen and try again.";

static NSString *const UNSUCCESSFUL_TASK_SAVE_MESSAGE = @"Please try to save task again.";

static NSString *const RENAME_BORB_ALERT_MESSAGE = @"Enter a new name: ";
static NSString *const BORB_MAXHP_ALERT_MESSAGE = @"Your Borb is at max HP";
static NSString *const NOT_ENOUGH_COINS_XPBOOST_ALERT_MESSAGE = @"You need at least 75 coins to boost your Borb's XP";
static NSString *const NOT_ENOUGH_COINS_FEED_ALERT_MESSAGE = @"You need at least 7 coins to feed your Borb";

// Alert Actions
static NSString *const OK_ACTION_TITLE = @"OK";
static NSString *const CANCEL_ACTION_TITLE = @"Cancel";

+ (void) addOKActionToAlert:(UIAlertController*)alert{
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:OK_ACTION_TITLE
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                     }];
    [alert addAction:okAction];
}

+ (void) presentLoginNotSuccesfulAlert:(UIViewController*)viewController {
    UIAlertController *loginNotSuccessfulAlert = [UIAlertController alertControllerWithTitle:UNSUCCESSFUL_LOGIN_ALERT_TITLE
                                                                                     message:UNSUCCESSFUL_LOGIN_ALERT_MESSAGE
                                                                              preferredStyle:(UIAlertControllerStyleAlert)];
    
    [self addOKActionToAlert:loginNotSuccessfulAlert];
    [viewController presentViewController:loginNotSuccessfulAlert animated:YES completion:nil];
}

+ (void) presentLoginAfterSignupNotSuccesfulAlert:(UIViewController*)viewController {
    UIAlertController *loginNotSuccessfulAlert = [UIAlertController alertControllerWithTitle:UNSUCCESSFUL_LOGIN_ALERT_TITLE
                                                                                      message:UNSUCCESSFUL_LOGIN_UPON_SIGNUP_ALERT_MESSAGE
                                                                               preferredStyle:(UIAlertControllerStyleAlert)];
    
    [self addOKActionToAlert:loginNotSuccessfulAlert];
    [viewController presentViewController:loginNotSuccessfulAlert animated:YES completion:nil];
}

+ (void) presentSignUpNotSuccesfulAlert:(UIViewController*)viewController {
    UIAlertController *signUpNotSuccessfulAlert = [UIAlertController alertControllerWithTitle:UNSUCCESSFUL_SIGNUP_ALERT_TITLE
                                                                                      message:UNSUCCESSFUL_SIGNUP_ALERT_MESSAGE
                                                                               preferredStyle:(UIAlertControllerStyleAlert)];
    
    [self addOKActionToAlert:signUpNotSuccessfulAlert];
    [viewController presentViewController:signUpNotSuccessfulAlert animated:YES completion:nil];
}

+ (void) presentCannotFeedBorbMaxHPAlert:(UIViewController*)viewController {
    UIAlertController *cannotFeedBorbAlert = [UIAlertController alertControllerWithTitle:BORB_MAXHP_ALERT_TITLE
                                                                                 message:BORB_MAXHP_ALERT_MESSAGE
                                                                          preferredStyle:(UIAlertControllerStyleAlert)];
    
    [self addOKActionToAlert:cannotFeedBorbAlert];
    [viewController presentViewController:cannotFeedBorbAlert animated:YES completion:nil];
}

+ (void) presentNotEnoughCoinsToFeedAlert:(UIViewController*)viewController {
    UIAlertController *notEnoughCoinsAlert = [UIAlertController alertControllerWithTitle:NOT_ENOUGH_COINS_ALERT_TITLE
                                                                                 message:NOT_ENOUGH_COINS_FEED_ALERT_MESSAGE
                                                                          preferredStyle:(UIAlertControllerStyleAlert)];
    
    [self addOKActionToAlert:notEnoughCoinsAlert];
    [viewController presentViewController:notEnoughCoinsAlert animated:YES completion:nil];
}

+ (void) presentNotEnoughCoinsToBoostXPAlert:(UIViewController*)viewController {
    UIAlertController *notEnoughCoinsAlert = [UIAlertController alertControllerWithTitle:NOT_ENOUGH_COINS_ALERT_TITLE
                                                                                 message:NOT_ENOUGH_COINS_XPBOOST_ALERT_MESSAGE
                                                                          preferredStyle:(UIAlertControllerStyleAlert)];
    [self addOKActionToAlert:notEnoughCoinsAlert];
    [viewController presentViewController:notEnoughCoinsAlert animated:YES completion:nil];
}

+ (void) presentSaveTaskNotSuccesfulAlert:(UIViewController*)viewController {
    UIAlertController *saveNotSuccessfulAlert = [UIAlertController alertControllerWithTitle:UNSUCCESSFUL_TASK_SAVE_TITLE
                                                                                    message:UNSUCCESSFUL_TASK_SAVE_MESSAGE
                                                                             preferredStyle:(UIAlertControllerStyleAlert)];
    [self addOKActionToAlert:saveNotSuccessfulAlert];
    [viewController presentViewController:saveNotSuccessfulAlert animated:YES completion:nil];
}
@end
