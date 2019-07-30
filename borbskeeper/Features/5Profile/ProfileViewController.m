//
//  ProfileViewController.m
//  borbskeeper
//
//  Created by rodrigoandrade on 7/25/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "BorbParseManager.h"
#import "Task.h"
#import "CompleteTaskListInfiniteScrollView.h"
#import "ComposePostForTaskViewController.h"
#import "CompletedTaskCell.h"

@interface ProfileViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, InfiniteScrollDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet CompleteTaskListInfiniteScrollView *completeTaskListInfiniteScrollView;
@property (strong, nonatomic) NSMutableArray *completeTaskList;
@property (strong, nonatomic) NSDate *latestDate;
@property (strong, nonatomic) UIImage *originalImage;
@property (strong, nonatomic) UIImage *editedImage;

@end

@implementation ProfileViewController

static NSString *const USER_PROF_PIC_KEY = @"profilePicture";
static NSString *const COMPLETE_TASK_TABLE_VIEW_CELL_ID = @"CompletedTaskCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.completeTaskListInfiniteScrollView.infiniteScrollDelegate = self;
    [self setupProfile];
    [self.completeTaskListInfiniteScrollView setupTableView];
}

- (void)setupProfile {
    NSString *userName = User.currentUser.username;
    self.userName.text = userName;
    [self loadUserProfilePicture];
}

-(void)loadUserProfilePicture {
    PFFileObject *PFObjectProfileImage = [User currentUser][USER_PROF_PIC_KEY];
    NSURL *profileImageURL = [NSURL URLWithString:PFObjectProfileImage.url];
    // self.profilePicture.image = nil;
    [self.profilePicture setImageWithURL:profileImageURL];
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.originalImage = info[UIImagePickerControllerOriginalImage];
    self.editedImage = [self resizeImage:self.originalImage withSize:CGSizeMake(1000, 1000)];
    [self.profilePicture setImage:self.editedImage];
    
    [User currentUser][USER_PROF_PIC_KEY] = [BorbParseManager getPFFileFromImage:self.editedImage];
    
    [BorbParseManager saveUser:[User currentUser] withCompletion:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapChangeProfilePicture:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)fetchDataWithCompletion:(void (^)(void))completion {
    [BorbParseManager fetchCompleteTasksOfUser:User.currentUser.username withCompletion:^(NSMutableArray *tasks) {
        self.completeTaskList = tasks;
        completion();
        // [self checkDate];
    }];
}

- (void)loadMoreData {
    Task *latestTask = [self.completeTaskList lastObject];
    self.latestDate = latestTask.createdAt;
    
    [BorbParseManager loadMoreCompleteTasksOfUser:User.currentUser.username withLaterDate:self.latestDate withCompletion:^(NSMutableArray *posts) {
        if ([posts count] > 0) {
            [self.completeTaskList addObjectsFromArray:posts];
            [self.completeTaskListInfiniteScrollView.tableView reloadData];
            self.completeTaskListInfiniteScrollView.isMoreDataLoading = false;
        } else {
            self.completeTaskListInfiniteScrollView.isMoreDataLoading = true;
        }
    }];
}
/*
- (void)checkDate {
    [self compareDate];
}

- (void)compareDate {
    NSDate *today = [NSDate date];
    NSComparisonResult result;
    Task *task = self.completeTaskList[0];
    result = [today compare:task.dueDate];
} */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.completeTaskList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:COMPLETE_TASK_TABLE_VIEW_CELL_ID];
    
    Task *currTask = self.completeTaskList[indexPath.row];
    [cell setupWithTask:currTask];
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"composePostForTaskSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.completeTaskListInfiniteScrollView.tableView indexPathForCell:tappedCell];
        Task* task = self.completeTaskList[indexPath.row];
        
        if (task.posted) {
            NSLog(@"Already posted this task! Cannot.");
        }
        else {
            UINavigationController *navigationController = [segue destinationViewController];
            ComposePostForTaskViewController *composePostController = (ComposePostForTaskViewController*)navigationController.topViewController;

            composePostController.selectedTask = task;
        }
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
