//
//  AlertManager.h
//  borbskeeper
//
//  Created by rodrigoandrade on 7/31/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertManager : NSObject

+ (void) presentLoginNotSuccesfulAlert:(UIViewController*)viewController;

+ (void) presentLoginAfterSignupNotSuccesfulAlert:(UIViewController*)viewController;

+ (void) presentSignUpNotSuccesfulAlert:(UIViewController*)viewController;

+ (void) presentCannotFeedBorbMaxHPAlert:(UIViewController*)viewController;

+ (void) presentNotEnoughCoinsToFeedAlert:(UIViewController*)viewController;

+ (void) presentNotEnoughCoinsToBoostXPAlert:(UIViewController*)viewController;

+ (void) presentSaveTaskNotSuccesfulAlert:(UIViewController*)viewController;

+ (void) presentRequestToSelfAlert:(UIViewController*)viewController;

+ (void) presentCannotFindUserAlert:(UIViewController*)viewController;

+ (void) presentRequestAlreadyExistsAlert:(UIViewController*)viewController;

+ (void) presentRequestNotSavedAlert:(UIViewController*)viewController;

@end

NS_ASSUME_NONNULL_END
