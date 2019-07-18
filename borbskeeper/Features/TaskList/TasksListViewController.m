//
//  TasksListViewController.m
//  borbskeeper
//
//  Created by cassanene on 7/16/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "TasksListViewController.h"

@interface TasksListViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation TasksListViewController

static NSString *const TASK_LIST_SEGUE_ID = @"composeTaskSegue";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}
- (IBAction)tapTaskCell:(UITapGestureRecognizer *)sender {
    [self performSegueWithIdentifier:@"editTaskSegue" sender:nil];
    
}

- (IBAction)didTapNewTask:(id)sender {
    [self performSegueWithIdentifier:TASK_LIST_SEGUE_ID sender:nil];
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    <#code#>
//}
//
//- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    <#code#>
//}

@end
