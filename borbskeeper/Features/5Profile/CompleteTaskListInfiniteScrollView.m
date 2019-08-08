//
//  CompleteTaskListInfiniteScrollView.m
//  borbskeeper
//
//  Created by rodrigoandrade on 7/26/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "CompleteTaskListInfiniteScrollView.h"

@implementation CompleteTaskListInfiniteScrollView
@dynamic tableView;
@dynamic activityIndicator;

- (void)refreshTableView {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor whiteColor]];
    [self.refreshControl addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self.tableView addSubview:self.refreshControl];
    [self.activityIndicator startAnimating];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
