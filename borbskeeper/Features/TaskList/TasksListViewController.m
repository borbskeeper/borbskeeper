//
//  TasksListViewController.m
//  borbskeeper
//
//  Created by cassanene on 7/16/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "TasksListViewController.h"
#import "Task.h"
#import "BorbParseManager.h"
#import "ComposeTaskViewController.h"
#import "IncompleteTaskListInfiniteScrollView.h"

@interface TasksListViewController () <InfiniteScrollDelegate, ComposeViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *incompleteTaskList;
@property (strong, nonatomic) NSString *current_username;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSDate *latestDate;
@property (weak, nonatomic) IBOutlet IncompleteTaskListInfiniteScrollView *incompleteTaskListInfiniteScrollView;


@end

@implementation TasksListViewController

static NSString *const COMPOSE_SEGUE_ID = @"composeTaskSegue";
static NSString *const EDIT_SEGUE_ID = @"editTaskSegue";
static NSString *const TASK_TABLE_VIEW_CELL_ID = @"TaskCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.incompleteTaskListInfiniteScrollView.infiniteScrollDelegate = self;
    
    self.current_username = [PFUser currentUser].username;
    [self.incompleteTaskListInfiniteScrollView setupTableView];
     
}

- (IBAction)didTapNewTask:(id)sender {
    [self performSegueWithIdentifier:COMPOSE_SEGUE_ID sender:nil];
}

- (IBAction)didTapSignOut:(id)sender {
    [BorbParseManager signOutUser];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.incompleteTaskList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:TASK_TABLE_VIEW_CELL_ID];
    Task *currTask = self.incompleteTaskList[indexPath.row];
    [cell setupWithTask:currTask];
    return cell;
}

- (void)didSaveTask {
    [self.incompleteTaskListInfiniteScrollView fetchData];
}

- (void)fetchDataWithCompletion:(void (^)(void))completion {
    [BorbParseManager fetchIncompleteTasksOfUser:self.current_username WithCompletion:^(NSMutableArray *posts) {
        self.incompleteTaskList = posts;
        completion();
    }];
}

- (void)loadMoreData {
    Task *latestTask = [self.incompleteTaskList lastObject];
    self.latestDate = latestTask.createdAt;
    
    [BorbParseManager loadMoreIncompleteTasksOfUser:self.current_username withLaterDate:self.latestDate WithCompletion:^(NSMutableArray *posts) {
        if ([posts count] > 0){
            [self.incompleteTaskList addObjectsFromArray:posts];
            [self.incompleteTaskListInfiniteScrollView.tableView reloadData];
            self.incompleteTaskListInfiniteScrollView.isMoreDataLoading = false;
        } else {
            self.incompleteTaskListInfiniteScrollView.isMoreDataLoading = true;
        }
    }];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:EDIT_SEGUE_ID]){
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeTaskViewController *composeController = (ComposeTaskViewController*)navigationController.topViewController;
        
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.incompleteTaskListInfiniteScrollView.tableView indexPathForCell:tappedCell];
        Task* task = self.incompleteTaskList[indexPath.row];
        composeController.task = task;
    } else if([segue.identifier  isEqual: COMPOSE_SEGUE_ID]){
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeTaskViewController *composeController = (ComposeTaskViewController*)navigationController.topViewController;
        composeController.delegate = self;
        composeController.task = nil;
    }
}


@end
