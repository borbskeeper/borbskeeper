//
//  ComposePostForTaskViewController.m
//  borbskeeper
//
//  Created by juliapark628 on 7/29/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "ComposePostForTaskViewController.h"
#import "Post.h"
#import "BorbParseManager.h"

@interface ComposePostForTaskViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIImage *selectedImage;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskDueDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskDescriptionLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *shareOptionButton;

@end

static NSString *const DATE_FORMAT = @"'Due' MM/dd/yyyy 'at' hh:mm a";

@implementation ComposePostForTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadTask];
    // Do any additional setup after loading the view.
}

- (void) loadTask {
    self.taskNameLabel.text = self.selectedTask.taskName;
    self.taskDescriptionLabel.text = self.selectedTask.taskDescription;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = DATE_FORMAT;
    self.taskDueDateLabel.text = [dateFormatter stringFromDate:self.selectedTask.dueDate];
}

- (IBAction)choosePhotoButtonClicked:(id)sender {
    [self setImageSourceToLibrary];
}

- (IBAction)takePhotoButtonClicked:(id)sender {
    [self attemptToSetImageSourceToCamera];
}


- (void) attemptToSetImageSourceToCamera {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Camera" message:@"There is no camera." preferredStyle:(UIAlertControllerStyleAlert)];
        
        // try again by refreshing
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        // add the refresh action to the alert controller
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:^{
            // do nothing
        }];
    }
}

- (void) setImageSourceToLibrary {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = [self resizeImage:originalImage withSize:CGSizeMake(375, 375)];
    
    self.selectedImage = [UIImage imageWithCGImage:editedImage.CGImage];
    self.selectedImageView.image = self.selectedImage;
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
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


- (IBAction)didTapCancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapPost:(id)sender {
    if (!self.selectedImage) {
        NSLog(@"error");
        // put a error alert here
        return;
    }
    Post *newPost = [Post createPost:self.selectedImage withTask:self.selectedTask];
    if (self.shareOptionButton.selectedSegmentIndex == 0){
        newPost.sharedGlobally = NO;
        newPost.sharedWithFriends = YES;
    } else {
        newPost.sharedGlobally = YES;
        newPost.sharedWithFriends = YES;
    }
    
    [BorbParseManager savePost:newPost withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error composing Pos: %@", error.localizedDescription);
        }
        else {
            self.selectedTask.posted = YES;
            [BorbParseManager saveTask:self.selectedTask withCompletion:nil];
            [self.delegate didPostTask];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
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
