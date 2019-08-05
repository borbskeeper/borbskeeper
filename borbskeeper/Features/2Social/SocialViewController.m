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
#import "FeedInfiniteScrollView.h"

@interface SocialViewController () <InfiniteScrollDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *shareOptionButton;
@property (weak, nonatomic) IBOutlet FeedInfiniteScrollView *feedInfiniteScrollView;
@property (strong, nonatomic) NSMutableArray* posts;
@property (strong, nonatomic) NSDate *latestDate;

@end

@implementation SocialViewController

static NSString *const POST_CELL_REUSE_ID = @"PostCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.feedInfiniteScrollView.infiniteScrollDelegate = self;
    [self.feedInfiniteScrollView setupTableView];
}

- (void)fetchDataWithCompletion:(void (^)(void))completion {
    if (self.shareOptionButton.selectedSegmentIndex == 0){
        [BorbParseManager fetchFriendsPostsFromFriendsListID:[User currentUser].friendsListID WithCompletion:^(NSMutableArray *posts) {
            self.posts = posts;
            completion();
        }];
    } else {
        [BorbParseManager fetchGlobalPostsWithCompletion:^(NSMutableArray *posts) {
            self.posts = posts;
            completion();
        }];
    }
}

- (void)loadMoreData {
    Post *latestPost = [self.posts lastObject];
    self.latestDate = latestPost.createdAt;
    
    if (self.shareOptionButton.selectedSegmentIndex == 0){
        [BorbParseManager loadMoreFriendsPostsFromFriendsListID:[User currentUser].friendsListID WithLaterDate:self.latestDate withCompletion:^(NSMutableArray *newPosts) {
            if ([newPosts count] > 0){
                [self.posts addObjectsFromArray:newPosts];
                [self.feedInfiniteScrollView.tableView reloadData];
                self.feedInfiniteScrollView.isMoreDataLoading = false;
            } else {
                self.feedInfiniteScrollView.isMoreDataLoading = true;
            }
        }];

    } else {
        [BorbParseManager loadMoreGlobalPostsWithLaterDate:self.latestDate withCompletion:^(NSMutableArray *newPosts) {
            if ([newPosts count] > 0){
                [self.posts addObjectsFromArray:newPosts];
                [self.feedInfiniteScrollView.tableView reloadData];
                self.feedInfiniteScrollView.isMoreDataLoading = false;
            } else {
                self.feedInfiniteScrollView.isMoreDataLoading = true;
            }
        }];
    }
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

- (IBAction)didChageShareOptionValue:(id)sender {
    [self.feedInfiniteScrollView fetchData];
    [self.feedInfiniteScrollView.tableView setContentOffset:CGPointMake(self.feedInfiniteScrollView.tableView.contentInset.left, self.feedInfiniteScrollView.tableView.contentInset.top) animated:NO];
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
