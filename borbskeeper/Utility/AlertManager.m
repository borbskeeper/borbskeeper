//
//  AlertManager.m
//  borbskeeper
//
//  Created by rodrigoandrade on 7/31/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "AlertManager.h"
#import "BorbParseManager.h"



@implementation AlertManager

// Alert Titles
static NSString *const UNSUCCESSFUL_LOGIN_ALERT_TITLE = @"Login not successful";
static NSString *const UNSUCCESSFUL_SIGNUP_ALERT_TITLE = @"Signup not successful";

static NSString *const UNSUCCESSFUL_TASK_SAVE_TITLE = @"Could not save task";

static NSString *const RENAME_BORB_ALERT_TITLE = @"Rename your borb!";
static NSString *const BORB_MAXHP_ALERT_TITLE = @"This Borb is already full!";
static NSString *const NOT_ENOUGH_COINS_ALERT_TITLE = @"Not enough Coins!";
static NSString *const DELETE_CONFIRMATION_TITLE = @"Are you sure you want to delete this task?";
static NSString *const FRIEND_REQUEST_ALERT_TITLE = @"Friend Request not sent!";

// Alert Messages
static NSString *const UNSUCCESSFUL_LOGIN_ALERT_MESSAGE = @"Please try to login in again.";
static NSString *const UNSUCCESSFUL_SIGNUP_ALERT_MESSAGE = @"Please try signing up again.";
static NSString *const UNSUCCESSFUL_LOGIN_UPON_SIGNUP_ALERT_MESSAGE = @"Please return to login screen and try again.";

static NSString *const UNSUCCESSFUL_TASK_SAVE_MESSAGE = @"Please try to save task again.";

static NSString *const RENAME_BORB_ALERT_MESSAGE = @"Enter a new name: ";
static NSString *const BORB_MAXHP_ALERT_MESSAGE = @"Your Borb is at max HP";
static NSString *const NOT_ENOUGH_COINS_XPBOOST_ALERT_MESSAGE = @"You need at least 75 coins to boost your Borb's XP";
static NSString *const NOT_ENOUGH_COINS_FEED_ALERT_MESSAGE = @"You need at least 7 coins to feed your Borb";
static NSString *const BLANK_MESSAGE = @"";



static NSString *const CANNOT_REQUEST_SELF_ALERT_MESSAGE = @"You cannot send a friend request to yourself.";
static NSString *const CANNOT_FIND_USER_MESSAGE = @"Could not find user.";
static NSString *const REQUEST_ALREADY_EXISTS_ALERT_MESSAGE = @"Already friends or request pending.";
static NSString *const REQUEST_NOT_SAVED_ALERT_MESSAGE = @"Possible network error. Please try again.";

// Alert Actions
static NSString *const OK_ACTION_TITLE = @"OK";
static NSString *const CANCEL_ACTION_TITLE = @"Cancel";
static NSString *const DELETE_ACTION_TITLE = @"Delete";

+ (BOOL)isInvalidTextField:(NSArray*)fieldsToBeChecked{
    for (NSString *textFieldText in fieldsToBeChecked){
        if (textFieldText == nil){
            return YES;
        } else {
            NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            NSString *trimmed = [textFieldText stringByTrimmingCharactersInSet:whitespace];
            if ([trimmed length] == 0) {
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark - alert actions
+ (void) addOKActionToAlert:(UIAlertController*)alert{
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:OK_ACTION_TITLE
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                     }];
    [alert addAction:okAction];
}

+ (void) addCancelActionToAlert:(UIAlertController*)alert{
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CANCEL_ACTION_TITLE
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                     }];
    [alert addAction:cancelAction];
}

+ (void) addDeleteActionToAlert:(UIAlertController*)alert{
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:DELETE_ACTION_TITLE
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                         }];
    [alert addAction:deleteAction];
}

#pragma mark - Generic error alert
// [actionNoun] not successful. Please [actionVerb].
+ (void) presentGenericErrorAlert:(UIViewController *)viewController withFailedAction:(NSString *)actionNoun andMessageToTry:(NSString *)actionVerb {
    UIAlertController *notSuccessfulAlert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ not successful", actionNoun]
                                                                                message:[NSString stringWithFormat:@"There was an error. Please %@.", actionVerb]
                                                                              preferredStyle:(UIAlertControllerStyleAlert)];
    
    [self addOKActionToAlert:notSuccessfulAlert];
    [viewController presentViewController:notSuccessfulAlert animated:YES completion:nil];
}

#pragma mark - Login/Signup error alerts
+ (void) presentInvalidSignupAlert:(UIViewController*)viewController {
    UIAlertController *invalidSignupAlert = [UIAlertController alertControllerWithTitle:@"Invalid signup information."
                                                                                      message:@"Your username and password cannot be empty or composed of only spaces, and your email must be valid."
                                                                               preferredStyle:(UIAlertControllerStyleAlert)];
    
    [self addOKActionToAlert:invalidSignupAlert];
    [viewController presentViewController:invalidSignupAlert animated:YES completion:nil];
}


#pragma mark - game error alerts
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

+ (void) presentInvalidBorbNameAlert:(UIViewController *)viewController {
    UIAlertController *renameErrorAlert = [UIAlertController alertControllerWithTitle:@"Invalid borb name"
                                                                              message:@"Borb name cannot be empty or composed of only spaces."
                                                                       preferredStyle:(UIAlertControllerStyleAlert)];
    [self addOKActionToAlert:renameErrorAlert];
    
    [viewController presentViewController:renameErrorAlert animated:YES completion:nil];
}

#pragma mark - task error alerts
+ (void) presentInvalidTaskAlert:(UIViewController*)viewController {
    UIAlertController *invalidTaskAlert = [UIAlertController alertControllerWithTitle:@"Invalid task title"
                                                                                    message:@"You must enter a title without spaces for your task."
                                                                             preferredStyle:(UIAlertControllerStyleAlert)];
    [self addOKActionToAlert:invalidTaskAlert];
    [viewController presentViewController:invalidTaskAlert animated:YES completion:nil];
}

#pragma mark - social error alerts
+ (void) presentRequestToSelfAlert:(UIViewController*)viewController {
    UIAlertController *requestNotSuccessfulAlert = [UIAlertController alertControllerWithTitle:FRIEND_REQUEST_ALERT_TITLE
                                                                                     message:CANNOT_REQUEST_SELF_ALERT_MESSAGE
                                                                              preferredStyle:(UIAlertControllerStyleAlert)];
    
    [self addOKActionToAlert:requestNotSuccessfulAlert];
    [viewController presentViewController:requestNotSuccessfulAlert animated:YES completion:nil];
}

+ (void) presentCannotFindUserAlert:(UIViewController*)viewController {
    UIAlertController *requestNotSuccessfulAlert = [UIAlertController alertControllerWithTitle:FRIEND_REQUEST_ALERT_TITLE
                                                                                       message:CANNOT_FIND_USER_MESSAGE
                                                                                preferredStyle:(UIAlertControllerStyleAlert)];
    
    [self addOKActionToAlert:requestNotSuccessfulAlert];
    [viewController presentViewController:requestNotSuccessfulAlert animated:YES completion:nil];
}

+ (void) presentRequestAlreadyExistsAlert:(UIViewController*)viewController {
    UIAlertController *requestNotSuccessfulAlert = [UIAlertController alertControllerWithTitle:FRIEND_REQUEST_ALERT_TITLE
                                                                                       message:REQUEST_ALREADY_EXISTS_ALERT_MESSAGE
                                                                                preferredStyle:(UIAlertControllerStyleAlert)];
    
    [self addOKActionToAlert:requestNotSuccessfulAlert];
    [viewController presentViewController:requestNotSuccessfulAlert animated:YES completion:nil];
}

+ (void) presentVerificationDisabledAlert:(UIViewController *)viewController {
    UIAlertController *verificationDisabledAlert = [UIAlertController alertControllerWithTitle:@"You cannot post tasks when verification is disabled."
                                                                                        message:@"Go to Profile > Settings to enable verification."                                                                               preferredStyle:(UIAlertControllerStyleAlert)];
    
    [self addOKActionToAlert:verificationDisabledAlert];
    [viewController presentViewController:verificationDisabledAlert animated:YES completion:nil];
}

+ (void) presentAlreadyPostedTaskAlert:(UIViewController *)viewController {
    UIAlertController *alreadyPostedTaskAlert = [UIAlertController alertControllerWithTitle:@"You've already posted this task!"
                                                                                       message:@"You cannot post the same task twice."                                                                               preferredStyle:(UIAlertControllerStyleAlert)];
    
    [self addOKActionToAlert:alreadyPostedTaskAlert];
    [viewController presentViewController:alreadyPostedTaskAlert animated:YES completion:nil];
}

#pragma mark - camera error alerts
+ (void) presentNoCameraAlert:(UIViewController *)viewController {
    UIAlertController *presentNoCameraAlert = [UIAlertController alertControllerWithTitle:@"No Camera"
                                                                                  message:@"There is no camera."
                                                                           preferredStyle:(UIAlertControllerStyleAlert)];
    
    [self addOKActionToAlert:presentNoCameraAlert];
    [viewController presentViewController:presentNoCameraAlert animated:YES completion:nil];
}

#pragma mark - confirmation alerts
+ (void) presentDisableVerificationConfirmationAlert:(UIViewController *)viewController withCancelCompletion: (void (^) (bool))completion {
    UIAlertController *disableVerificationAlert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to disable verification?"
                                                                                      message:@"You will not be able to receive verification for any completed tasks already posted. You may still verify other user's posts."
                                                                               preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelDisableAction = [UIAlertAction actionWithTitle:CANCEL_ACTION_TITLE
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                    completion(TRUE);
                                                                }];
    
    [disableVerificationAlert addAction:cancelDisableAction];
    
    UIAlertAction *OKDisableAction = [UIAlertAction actionWithTitle:@"Yes, disable verification"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                completion(FALSE);
                                                            }];
    [disableVerificationAlert addAction:OKDisableAction];
    
    
    [viewController presentViewController:disableVerificationAlert animated:YES completion:nil];
}

+ (void) presentDeleteTaskComfirmationAlert:(UIViewController*)viewController forTask:(Task* )task withConfirmCompletion: (void (^) (bool)) completion {
    UIAlertController *deleteTaskConfirmation = [UIAlertController alertControllerWithTitle:DELETE_CONFIRMATION_TITLE
                                                                                    message:BLANK_MESSAGE preferredStyle:(UIAlertControllerStyleAlert)];
    [self addCancelActionToAlert:deleteTaskConfirmation];
    
    UIAlertAction *confirmDeleteAction = [UIAlertAction actionWithTitle:DELETE_ACTION_TITLE
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 completion(YES);
                                                             }];
    
    [deleteTaskConfirmation addAction:confirmDeleteAction];
    
    [viewController presentViewController:deleteTaskConfirmation animated:YES completion:nil];
}

#pragma mark - other alerts
+ (void) presentRenameBorbAlert:(UIViewController *)viewController withCompletion:(void (^)(NSString *)) completion {
    UIAlertController *renameBorbAlert = [UIAlertController alertControllerWithTitle:@"Rename your borb!"
                                                                             message:@"Enter a new name: "
                                                                      preferredStyle:(UIAlertControllerStyleAlert)];
    [self addCancelActionToAlert:renameBorbAlert];

    UIAlertAction *okNewNameAction = [UIAlertAction actionWithTitle:OK_ACTION_TITLE
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         NSString* newName = renameBorbAlert.textFields[0].text;
                                                         completion(newName);
                                                     }];
    [renameBorbAlert addAction:okNewNameAction];

    [renameBorbAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"New borb name";
    }];
    
    [viewController presentViewController:renameBorbAlert animated:YES completion:nil];
}

+ (void) presentCameraChoiceAlert:(UIViewController *)viewController withCompletion:(void (^)(bool choseCamera))completion{
    UIAlertController *presentNoCameraAlert = [UIAlertController alertControllerWithTitle:@"Choose an image source: "
                                                                                  message:nil
                                                                           preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take a photo..."
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         completion(YES);
                                                     }];
    [presentNoCameraAlert addAction:cameraAction];
    
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"Choose from library..."
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             completion(NO);
                                                         }];
    [presentNoCameraAlert addAction:libraryAction];
    
    [self addCancelActionToAlert:presentNoCameraAlert];
    [viewController presentViewController:presentNoCameraAlert animated:YES completion:nil];
}

@end
