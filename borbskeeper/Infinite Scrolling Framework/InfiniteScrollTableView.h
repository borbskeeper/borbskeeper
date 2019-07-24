//
//  InfiniteScrollTableView.h
//  borbskeeper
//
//  Created by rodrigoandrade on 7/23/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol InfiniteScrollTableViewDelegate <UITableViewDataSource, UITableViewDelegate>

- (void)loadMoreData;

@end

@interface InfiniteScrollTableView : UITableView <UIScrollViewDelegate>
@property (nonatomic, weak) id<InfiniteScrollTableViewDelegate> infiniteScrollDelegate;
@property (assign, nonatomic) BOOL isMoreDataLoading;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
