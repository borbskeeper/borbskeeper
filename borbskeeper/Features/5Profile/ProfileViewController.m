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
#import "TaskCell.h"
#import "ImageManipManager.h"
#import "ComposePostForTaskViewController.h"
#import "CompletedTaskCell.h"
#import <QuartzCore/QuartzCore.h>
#import "AlertManager.h"

@interface ProfileViewController () <InfiniteScrollDelegate, ImageManipManagerDelegate, ComposePostForTaskViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet CompleteTaskListInfiniteScrollView *completeTaskListInfiniteScrollView;
@property (strong, nonatomic) NSMutableArray *completeTaskList;
@property (strong, nonatomic) NSDate *latestDate;
@property (strong, nonatomic) ImageManipManager *imageManip;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *completedTasksLabel;

@end

@implementation ProfileViewController

static NSString *const USER_PROF_PIC_KEY = @"profilePicture";
static NSString *const COMPLETE_TASK_TABLE_VIEW_CELL_ID = @"CompletedTaskCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.completeTaskListInfiniteScrollView.infiniteScrollDelegate = self;
    [self setupProfile];
    [self.completeTaskListInfiniteScrollView setupTableView];
    self.imageManip = [[ImageManipManager alloc] init];
    self.imageManip.imageManipManagerDelegate = self;
}

- (void)setupNavBar {
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName:[UIFont fontWithName:@"OpenSans-SemiBold" size:18]}];
}

- (void)setupProfile {
    NSString *userName = User.currentUser.username;
    self.userName.text = userName;
    self.backgroundView.layer.cornerRadius = 20;
    self.backgroundView.clipsToBounds = YES;
    self.completedTasksLabel.layer.cornerRadius = 10;
    self.completedTasksLabel.clipsToBounds = YES;
    [self loadUserProfilePicture];
    [self setupNavBar];
}

-(void)loadUserProfilePicture {
    PFFileObject *PFObjectProfileImage = [User currentUser][USER_PROF_PIC_KEY];
    NSURL *profileImageURL = [NSURL URLWithString:PFObjectProfileImage.url];
    [self.profilePicture setImageWithURL:profileImageURL];
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2;
    self.profilePicture.clipsToBounds = YES;
}


- (IBAction)didTapProfilePicture:(id)sender {
    [self.imageManip presentImagePickerFromViewController:self withImageSource:IMAGESOURCE_LIBRARY];
}

- (void)saveImage:(UIImage *)selectedImage {
    [self.profilePicture setImage:selectedImage];
    
    [User currentUser][USER_PROF_PIC_KEY] = [BorbParseManager getPFFileFromImage:selectedImage];
    
    [BorbParseManager saveUser:[User currentUser] withCompletion:nil];
}

- (void)fetchDataWithCompletion:(void (^)(void))completion {
    [BorbParseManager fetchCompleteTasksOfUser:User.currentUser.username ifNotPosted:NO withCompletion:^(NSMutableArray *tasks) {
        self.completeTaskList = tasks;
        completion();
    }];
}

- (void)loadMoreData {
    Task *latestTask = [self.completeTaskList lastObject];
    self.latestDate = latestTask.dueDate;

    [BorbParseManager loadMoreCompleteTasksOfUser:User.currentUser.username ifNotPosted:NO withLaterDate:self.latestDate withCompletion:^(NSMutableArray *posts) {
        if ([posts count] > 0) {
            [self.completeTaskList addObjectsFromArray:posts];
            [self.completeTaskListInfiniteScrollView.tableView reloadData];
            self.completeTaskListInfiniteScrollView.isMoreDataLoading = false;
        } else {
            self.completeTaskListInfiniteScrollView.isMoreDataLoading = true;
        }
    }];
}

- (void)didPostTask {
    [self.completeTaskListInfiniteScrollView fetchData];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"composePostForTaskSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.completeTaskListInfiniteScrollView.tableView indexPathForCell:tappedCell];
        Task* task = self.completeTaskList[indexPath.row];
        
        if (![User currentUser].verificationEnabled) {
            [AlertManager presentVerificationDisabledAlert:self];
        } else if (task.posted) {
            [AlertManager presentAlreadyPostedTaskAlert:self]; 
            return;
        } else {
            UINavigationController *navigationController = [segue destinationViewController];
            ComposePostForTaskViewController *composePostController = (ComposePostForTaskViewController*)navigationController.topViewController;
            composePostController.delegate = self;
            composePostController.selectedTask = task;
        }
    }
}


@end
