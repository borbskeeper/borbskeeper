//
//  IncompleteTaskListInfiniteScrollView.h
//  borbskeeper
//
//  Created by rodrigoandrade on 7/26/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "InfiniteScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface IncompleteTaskListInfiniteScrollView : InfiniteScrollView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

NS_ASSUME_NONNULL_END
