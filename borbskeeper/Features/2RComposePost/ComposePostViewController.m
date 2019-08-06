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
#import "ImageManipManager.h"
#import "AlertManager.h"

@interface ComposePostViewController () <UITableViewDataSource, UITableViewDelegate, InfiniteScrollDelegate, ImageManipManagerDelegate>

@property (strong, nonatomic) UIImage* selectedImage;
@property (strong, nonatomic) Task *selectedTask;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet ComposePostTaskListInfiniteScrollView *composePostTaskListInfiniteScrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *shareOptionButton;
@property (strong, nonatomic) NSMutableArray *completeTaskList;
@property (strong, nonatomic) NSDate *latestDate;
@property (strong, nonatomic) ImageManipManager *imageManip;
@end

static NSString *const COMPLETE_TASK_TABLE_VIEW_CELL_ID = @"CompletedTaskCell";

@implementation ComposePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.composePostTaskListInfiniteScrollView.infiniteScrollDelegate = self;
    [self.composePostTaskListInfiniteScrollView setupTableView];
    self.imageManip = [[ImageManipManager alloc] init];
    self.imageManip.imageManipManagerDelegate = self;
}

- (void)fetchDataWithCompletion:(void (^)(void))completion {
    [BorbParseManager fetchCompleteTasksOfUser:User.currentUser.username ifNotPosted:YES withCompletion:^(NSMutableArray *tasks) {
        self.completeTaskList = tasks;
        completion();
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
    [self.imageManip presentImagePickerFromViewController:self withImageSource:IMAGESOURCE_LIBRARY];
}

- (IBAction)takePhotoButtonClicked:(id)sender {
    if (![self.imageManip presentImagePickerFromViewController:self withImageSource:IMAGESOURCE_CAMERA]) {
        [AlertManager presentNoCameraAlert:self];
    }
}

- (void)saveImage:(nonnull UIImage *)selectedImage {
    self.selectedImage = [UIImage imageWithCGImage:selectedImage.CGImage];
    self.selectedImageView.image = self.selectedImage;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedTask = self.completeTaskList[indexPath.row];
}

- (IBAction)postBarButtonClicked:(id)sender {
    if (!self.selectedImage|| !self.selectedTask) {
        NSLog(@"error");
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
        } else {
            self.selectedTask.posted = YES;
            [BorbParseManager saveTask:self.selectedTask withCompletion:nil];
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
