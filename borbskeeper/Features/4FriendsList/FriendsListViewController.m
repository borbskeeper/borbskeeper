//
//  FriendsListViewController.m
//  borbskeeper
//
//  Created by rodrigoandrade on 8/1/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "FriendsListViewController.h"
#import "FriendsListInfiniteScrollView.h"
#import "FriendCell.h"
#import "BorbParseManager.h"

@interface FriendsListViewController () <InfiniteScrollDelegate>
@property (weak, nonatomic) IBOutlet FriendsListInfiniteScrollView *friendsListInfiniteScrollView;
@property (strong, nonatomic) __block NSMutableArray *friendsList;
@end

@implementation FriendsListViewController
static NSString *const FRIEND_TABLE_VIEW_CELL_ID = @"FriendCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendsListInfiniteScrollView.infiniteScrollDelegate = self;
    [self.friendsListInfiniteScrollView setupTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.friendsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:FRIEND_TABLE_VIEW_CELL_ID];
    User *friend = self.friendsList[indexPath.row];
    [cell setupWithFriend:friend withBorb:friend.usersBorb];
    return cell;
}

- (void)fetchDataWithCompletion:(void (^)(void))completion {
    self.friendsList = [NSMutableArray arrayWithCapacity:0];
    
    [BorbParseManager fetchFriendListFromIDAsArray:[User currentUser].friendsListID withCompletion:^(NSMutableArray * friendsList) {
        self.friendsList = friendsList;
        completion();
    }];
}

- (void)loadMoreData {
    self.friendsListInfiniteScrollView.isMoreDataLoading = true;
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
