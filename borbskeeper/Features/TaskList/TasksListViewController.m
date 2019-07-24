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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.infiniteScrollTableView.delegate = self.infiniteScrollTableView;
    self.infiniteScrollTableView.dataSource = self;
    self.infiniteScrollTableView.infiniteScrollDelegate = self;
    
    self.current_username = [PFUser currentUser].username;
    [self fetchData];
    [self refreshTaskList];
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
        [self checkDate];
    }];
}
-(void)checkDate{
    NSLog(@"%@", self.incompleteTaskList);
    for (int i = 0; i < [self.incompleteTaskList count]; i++){
        [self getCurrentDate];
//        [self compareDate];
    }
}
-(void)getCurrentDate{
    NSLocale* currentLocale = [NSLocale currentLocale];
    NSDate *currentDatei = [[NSDate date] descriptionWithLocale:currentLocale];
    NSLog(@"First Current Date: %@",currentDatei);
    //Get current device time
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //Get Current Device Data
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    NSString *currentDate = [dateFormatter stringFromDate:today];
    NSLog(@"%@",currentDate);
}
//-(void)compareDate{
//    NSComparisonResult result;
//    result = [today compare:self.task.dueDate];
//    NSLog(@"%@",self.task.dueDate);
//    if (result == NSOrderedAscending){
//        NSLog(@"Can't Compare");
//    }
//}

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
