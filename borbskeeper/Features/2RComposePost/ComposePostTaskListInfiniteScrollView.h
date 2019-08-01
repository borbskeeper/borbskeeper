//
//  ComposePostTaskListInfiniteScrollView.h
//  borbskeeper
//
//  Created by rodrigoandrade on 7/29/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "InfiniteScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComposePostTaskListInfiniteScrollView : InfiniteScrollView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

NS_ASSUME_NONNULL_END
