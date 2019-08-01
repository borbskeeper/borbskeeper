//
//  SocialViewController.m
//  borbskeeper
//
//  Created by juliapark628 on 7/26/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "SocialViewController.h"
#import "BorbParseManager.h"
#import "PostCell.h"

@interface SocialViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* posts;

@end

@implementation SocialViewController
static NSString *const POST_CELL_REUSE_ID = @"PostCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    [self beginRefresh:nil];
}

- (void)beginRefresh:(UIRefreshControl * _Nullable)refreshControl {
    [BorbParseManager fetchGlobalPostsWithCompletion:^(NSMutableArray * _Nonnull posts) {
        self.posts = posts;
        [self.tableView reloadData];
        [refreshControl endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return [self.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:POST_CELL_REUSE_ID];
    
    Post *post = self.posts[indexPath.row];
    [cell setupWithPost:post];
    return cell;
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
