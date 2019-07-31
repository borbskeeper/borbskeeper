//
//  ImageManipManager.h
//  borbskeeper
//
//  Created by juliapark628 on 7/31/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ImageManipManagerDelegate

// these methods will already be implemented if the delegate is a subclass of UIViewController (which it should be)
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0);
- (void)dismissViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0);

- (void)saveImage:(UIImage *)selectedImage;

@end

@interface ImageManipManager : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (void) attemptToSetImageSourceToCamera;
- (void) setImageSourceToLibrary;

@property (nonatomic, weak) id<ImageManipManagerDelegate> imageManipManagerDelegate;


@end

NS_ASSUME_NONNULL_END
