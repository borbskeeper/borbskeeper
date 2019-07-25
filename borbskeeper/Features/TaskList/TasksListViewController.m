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
#import "Borb.h"
#import "GameConstants.h"
#import "User.h"

@interface TasksListViewController () <InfiniteScrollTableViewDelegate, ComposeViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *incompleteTaskList;
@property (strong, nonatomic) NSString *current_username;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSDate *latestDate;
@end

@implementation TasksListViewController

static NSString *const COMPOSE_SEGUE_ID = @"composeTaskSegue";
static NSString *const EDIT_SEGUE_ID = @"editTaskSegue";
static NSString *const TASK_TABLE_VIEW_CELL_ID = @"TaskCell";
static const int START_INDEX = 0;
static const int SECS_TO_HOURS = 3600;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.infiniteScrollTableView.delegate = self.infiniteScrollTableView;
    self.infiniteScrollTableView.dataSource = self;
    self.infiniteScrollTableView.infiniteScrollDelegate = self;
    
    self.current_username = [PFUser currentUser].username;
    [self fetchData];
    [self refreshTaskList];
    [self decayByTime];
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

- (void)didSaveTask{
    [self fetchData];
}

- (void)refreshTaskList{
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.infiniteScrollTableView insertSubview:self.refreshControl atIndex:0];
    [self.infiniteScrollTableView addSubview:self.refreshControl];
    [self.activityIndicator startAnimating];
}

- (void)fetchData {
    [BorbParseManager fetchIncompleteTasksOfUser:self.current_username WithCompletion:^(NSMutableArray *posts) {
        self.incompleteTaskList = posts;
        [self.infiniteScrollTableView reloadData];
        [self.activityIndicator stopAnimating];
        [self.refreshControl endRefreshing];
        [self decayByIncompleteTask];
    }];
}

- (void)decayByIncompleteTask{
    NSDate *today = [NSDate date];
    NSComparisonResult result;
    for (int i = START_INDEX; i < [self.incompleteTaskList count]; i++){
        Task *task = self.incompleteTaskList[i];
        result = [today compare: task.dueDate];
        if (result == NSOrderedDescending){
            [BorbParseManager fetchBorb:[User currentUser].usersBorb.objectId WithCompletion:^(NSMutableArray *borbs) {
                Borb *userBorb = borbs[0];
                [userBorb decreaseHealthPointsBy:BORB_HP_DECAY_PER_INCOMPLETE_TASK];
                [BorbParseManager saveBorb:userBorb withCompletion:nil];
            }];
            NSLog(@"This task is past due");
        } else if (result == NSOrderedAscending){
            NSLog(@"This task is not due yet");

        }
    }
}

-(void)decayByTime{
    NSDate *today = [NSDate date]; //get today's date
    NSTimeInterval secondsBetween = [today timeIntervalSinceDate: [User currentUser].userLogin];
    int numOfHours = secondsBetween / SECS_TO_HOURS;
    [BorbParseManager fetchBorb:[User currentUser].usersBorb.objectId WithCompletion:^(NSMutableArray *borbs) {
        Borb *userBorb = borbs[0];
        [userBorb decreaseHealthPointsBy:(BORB_HP_DECAY_PER_HOUR * numOfHours)];
        [BorbParseManager saveBorb:userBorb withCompletion:nil];
    }];
    }

- (void)loadMoreData{
    Task *latestTask = [self.incompleteTaskList lastObject];
    self.latestDate = latestTask.createdAt;
    
    [BorbParseManager loadMoreIncompleteTasksOfUser:self.current_username withLaterDate:self.latestDate WithCompletion:^(NSMutableArray *posts) {
        if ([posts count] > 0){
            NSLog(@"!!!Loading more posts!!!");
            [self.incompleteTaskList addObjectsFromArray:posts];
            [self.infiniteScrollTableView reloadData];
            self.infiniteScrollTableView.isMoreDataLoading = false;
        } else {
            self.infiniteScrollTableView.isMoreDataLoading = true;
            NSLog(@"!!!No more posts to load!!!");
        }
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:EDIT_SEGUE_ID]){
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeTaskViewController *composeController = (ComposeTaskViewController*)navigationController.topViewController;
        
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.infiniteScrollTableView indexPathForCell:tappedCell];
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
