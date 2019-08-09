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
#import "ImageManipManager.h"
#import "AlertManager.h"

@interface ComposePostForTaskViewController () <ImageManipManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskDueDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskDescriptionLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *shareOptionButton;
@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) ImageManipManager *imageManip;
@property BOOL posting;

@end

static NSString *const DATE_FORMAT = @"'Due' MM/dd/yyyy 'at' hh:mm a";

@implementation ComposePostForTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadTask];
    self.imageManip = [[ImageManipManager alloc] init];
    self.imageManip.imageManipManagerDelegate = self;
    self.posting = NO;
    [self setupSegmentedControl];
}

- (void) setupSegmentedControl{
    [self.shareOptionButton setTitleTextAttributes:@{
                                                     NSFontAttributeName:[UIFont fontWithName:@"OpenSans-SemiBold" size:14]} forState: UIControlStateNormal];
}

- (void) loadTask {
    self.taskNameLabel.text = self.selectedTask.taskName;
    self.taskDescriptionLabel.text = self.selectedTask.taskDescription;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = DATE_FORMAT;
    self.taskDueDateLabel.text = [dateFormatter stringFromDate:self.selectedTask.dueDate];
}

- (IBAction)didTapPhotoButton:(id)sender {
    [AlertManager presentCameraChoiceAlert:self withCompletion:^(bool choseCamera) {
        if (choseCamera) {
            if (![self.imageManip presentImagePickerFromViewController:self withImageSource:IMAGESOURCE_CAMERA]) {
                [AlertManager presentNoCameraAlert:self];
            }
        } else {
            [self.imageManip presentImagePickerFromViewController:self withImageSource:IMAGESOURCE_LIBRARY];
        }
    }];
}

- (void)saveImage:(nonnull UIImage *)selectedImage {
    self.selectedImage = [UIImage imageWithCGImage:selectedImage.CGImage];
    self.selectedImageView.image = self.selectedImage;
}

- (IBAction)didTapCancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapPost:(id)sender {
    if (self.posting) {
        return;
    } else if (!self.selectedImage) {
        NSLog(@"error");
        // put a error alert here
        return;
    }
    self.posting = YES;
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
        } else {
            self.selectedTask.posted = YES;
            [BorbParseManager saveTask:self.selectedTask withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                [self.delegate didPostTask];
            }];
            self.posting = NO;
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
