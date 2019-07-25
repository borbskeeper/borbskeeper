//
//  CompletedTasksListInfiniteScrollView.h
//  borbskeeper
//
//  Created by rodrigoandrade on 7/25/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "InfiniteScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompletedTasksListInfiniteScrollView : InfiniteScrollView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

NS_ASSUME_NONNULL_END
