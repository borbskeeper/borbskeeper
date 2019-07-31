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

- (void)saveImage:(UIImage *)selectedImage;

@end

@interface ImageManipManager : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

typedef enum {
    CAMERA,
    LIBRARY
} imageSource;

- (bool) presentImagePickerFromViewController:(UIViewController *)viewController withImageSource:(imageSource) imageSource;

@property (nonatomic, weak) id<ImageManipManagerDelegate> imageManipManagerDelegate;


@end

NS_ASSUME_NONNULL_END
