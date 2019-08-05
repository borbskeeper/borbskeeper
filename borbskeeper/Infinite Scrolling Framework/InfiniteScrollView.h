//
//  InfiniteScrollView.h
//  borbskeeper
//
//  Created by rodrigoandrade on 7/24/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol InfiniteScrollDelegate

- (void)fetchDataWithCompletion:(void(^)(void))completion;
- (void)loadMoreData;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

@optional

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; 

@end

@interface InfiniteScrollView : UIView <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) id<InfiniteScrollDelegate> infiniteScrollDelegate;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void)setupTableView;
- (void)fetchData;
@end

NS_ASSUME_NONNULL_END
