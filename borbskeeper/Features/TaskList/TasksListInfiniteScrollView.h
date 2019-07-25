//
//  TasksListInfiniteScrollView.h
//  borbskeeper
//
//  Created by rodrigoandrade on 7/24/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "InfiniteScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TasksListInfiniteScrollView : InfiniteScrollView
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
