//
//  FriendRequestsViewController.m
//  borbskeeper
//
//  Created by rodrigoandrade on 8/1/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "FriendRequestsViewController.h"
#import "FriendRequestListInfiniteScrollView.h"
#import "FriendRequestCell.h"
#import "BorbParseManager.h"

@interface FriendRequestsViewController () <InfiniteScrollDelegate, FriendRequestDelegate>

@property (strong, nonatomic) NSMutableArray *friendRequestList;
@property NSDate *latestDate;
@property (weak, nonatomic) IBOutlet FriendRequestListInfiniteScrollView *friendRequestListInfiniteScrollView;

@end

@implementation FriendRequestsViewController
static NSString *const FRIEND_REQUEST_TABLE_VIEW_CELL_ID = @"FriendRequestCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendRequestListInfiniteScrollView.infiniteScrollDelegate = self;
    [self.friendRequestListInfiniteScrollView setupTableView];
    [self setupNavBar];
}

- (void)setupNavBar {
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName:[UIFont fontWithName:@"OpenSans-SemiBold" size:18]}];
}

- (IBAction)didTapBack:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didInteractWithFriendRequest {
    [self.friendRequestListInfiniteScrollView fetchData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.friendRequestList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:FRIEND_REQUEST_TABLE_VIEW_CELL_ID];
    FriendRequest *friendRequest = self.friendRequestList[indexPath.row];
    [cell setupWithFriendRequest:friendRequest];
    cell.delegate = self;
    return cell;
}

- (void)fetchDataWithCompletion:(void (^)(void))completion {
    [BorbParseManager fetchFriendRequests:[User currentUser] ignoreAccepted:YES withCompletion:^(NSMutableArray *friendRequests) {
        self.friendRequestList = friendRequests;
        completion();
    }];
}

- (void)loadMoreData {
    FriendRequest *latestFriendRequest = [self.friendRequestList lastObject];
    self.latestDate = latestFriendRequest.createdAt;
    
    [BorbParseManager loadMoreFriendRequests:[User currentUser] ignoreAccepted:YES withLaterDate:self.latestDate withCompletion:^(NSMutableArray *friendRequests) {
        if ([friendRequests count] > 0){
            [self.friendRequestList addObjectsFromArray:friendRequests];
            [self.friendRequestListInfiniteScrollView.tableView reloadData];
            self.friendRequestListInfiniteScrollView.isMoreDataLoading = false;
        } else {
            self.friendRequestListInfiniteScrollView.isMoreDataLoading = true;
        }
    }];
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
