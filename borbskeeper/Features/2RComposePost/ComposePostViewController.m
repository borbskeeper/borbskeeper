//
//  ComposePostViewController.m
//  borbskeeper
//
//  Created by juliapark628 on 7/26/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "ComposePostViewController.h"
#import "Task.h"
#import "Post.h"
#import "BorbParseManager.h"
#import "TaskCell.h"
#import "ComposePostTaskListInfiniteScrollView.h"

@interface ComposePostViewController () < UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, InfiniteScrollDelegate>

@property (strong, nonatomic) UIImage* selectedImage;
@property (strong, nonatomic) Task *selectedTask;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet ComposePostTaskListInfiniteScrollView *composePostTaskListInfiniteScrollView;

@property (strong, nonatomic) NSMutableArray *completeTaskList;
@property (strong, nonatomic) NSDate *latestDate;
@end

static NSString *const COMPLETE_TASK_TABLE_VIEW_CELL_ID = @"CompletedTaskCell";

@implementation ComposePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.composePostTaskListInfiniteScrollView.infiniteScrollDelegate = self;
    [self.composePostTaskListInfiniteScrollView setupTableView];
    // Do any additional setup after loading the view.
}

- (void)fetchDataWithCompletion:(void (^)(void))completion {
    [BorbParseManager fetchCompleteTasksOfUser:User.currentUser.username ifNotPosted:YES withCompletion:^(NSMutableArray *tasks) {
        self.completeTaskList = tasks;
        completion();
        // [self checkDate];
    }];
}

- (void)loadMoreData {
    Task *latestTask = [self.completeTaskList lastObject];
    self.latestDate = latestTask.createdAt;
    
    [BorbParseManager loadMoreCompleteTasksOfUser:User.currentUser.username ifNotPosted:YES withLaterDate:self.latestDate withCompletion:^(NSMutableArray *posts) {
        if ([posts count] > 0) {
            [self.completeTaskList addObjectsFromArray:posts];
            [self.composePostTaskListInfiniteScrollView.tableView reloadData];
            self.composePostTaskListInfiniteScrollView.isMoreDataLoading = false;
        } else {
            self.composePostTaskListInfiniteScrollView.isMoreDataLoading = true;
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.completeTaskList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:COMPLETE_TASK_TABLE_VIEW_CELL_ID];
    
    Task *currTask = self.completeTaskList[indexPath.row];
    [cell setupWithTask:currTask];
    return cell;
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

- (IBAction)postBarButtonClicked:(id)sender {
    if (!self.selectedImage|| !self.selectedTask) {
        NSLog(@"error");
        // put a error alert here
        return;
    }
    // self.selectedTask = ; 
    Post *newPost = [Post createPost:self.selectedImage withTask:self.selectedTask];
    [BorbParseManager savePost:newPost withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error composing Pos: %@", error.localizedDescription);
        }
        else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (IBAction)didTapCancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
