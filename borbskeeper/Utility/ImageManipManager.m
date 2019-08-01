//
//  ImageManipManager.m
//  borbskeeper
//
//  Created by juliapark628 on 7/31/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "ImageManipManager.h"

@interface ImageManipManager ()

@property (strong, nonatomic) UIViewController *originalViewController;

@end

@implementation ImageManipManager

- (bool) presentImagePickerFromViewController:(UIViewController *)viewController withImageSource:(imageSource) imageSource {
    self.originalViewController = viewController;
    
    if (imageSource == IMAGESOURCE_LIBRARY) {
        return [self setImageSourceToLibrary];
    }
    else if (imageSource == IMAGESOURCE_CAMERA) {
        return [self attemptToSetImageSourceToCamera];
    }
    else {
        return false;
    }
}


- (bool) attemptToSetImageSourceToCamera {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.originalViewController presentViewController:imagePickerVC animated:YES completion:nil];
        return true;
    }
    else {
        return false;
    }
}

- (bool) setImageSourceToLibrary {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.originalViewController presentViewController:imagePickerVC animated:YES completion:nil];
        return true;
    }
    else {
        return false;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = [self resizeImage:originalImage withSize:CGSizeMake(375, 375)];
    
    [self.imageManipManagerDelegate saveImage:editedImage];

    // Dismiss UIImagePickerController to go back to your original view controller
    [self.originalViewController dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
