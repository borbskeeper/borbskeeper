//
//  AlertManager.h
//  borbskeeper
//
//  Created by rodrigoandrade on 7/31/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlertManager : NSObject

+ (BOOL)isInvalidTextField:(NSArray*)fieldsToBeChecked;

// [actionNoun] not successful. Please try [actionVerb] again.
+ (void) presentGenericErrorAlert:(UIViewController *)viewController withFailedAction:(NSString *)actionNoun andMessageToTry:(NSString *)actionVerb;

// Login/signup error alerts
+ (void) presentInvalidSignupAlert:(UIViewController*)viewController;

// game error alerts
+ (void) presentCannotFeedBorbMaxHPAlert:(UIViewController*)viewController;

+ (void) presentNotEnoughCoinsToFeedAlert:(UIViewController*)viewController;

+ (void) presentNotEnoughCoinsToBoostXPAlert:(UIViewController*)viewController;

+ (void) presentInvalidBorbNameAlert:(UIViewController *)viewController;

// task error alerts
+ (void) presentInvalidTaskAlert:(UIViewController*)viewController;

// social error alerts
+ (void) presentRequestToSelfAlert:(UIViewController*)viewController;

+ (void) presentCannotFindUserAlert:(UIViewController*)viewController;

+ (void) presentRequestAlreadyExistsAlert:(UIViewController*)viewController;

+ (void) presentVerificationDisabledAlert:(UIViewController *)viewController;

+ (void) presentAlreadyPostedTaskAlert:(UIViewController *)viewController;

// camera error alerts
+ (void) presentNoCameraAlert:(UIViewController *)viewController;

// confirmation alerts
+ (void) presentDeleteTaskComfirmationAlert:(UIViewController*)viewController forTask:(Task* )task withConfirmCompletion: (void (^) (bool)) completion;

+ (void) presentDisableVerificationConfirmationAlert:(UIViewController *)viewController withCancelCompletion: (void (^) (bool))completion;

// other alerts
+ (void) presentRenameBorbAlert:(UIViewController *)viewController withCompletion:(void (^)(NSString *)) completion;

@end

NS_ASSUME_NONNULL_END
