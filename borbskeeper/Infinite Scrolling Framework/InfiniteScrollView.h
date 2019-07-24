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

- (void)loadMoreData;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

@end

@interface InfiniteScrollView : UIView <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) id<InfiniteScrollDelegate> infiniteScrollDelegate;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
