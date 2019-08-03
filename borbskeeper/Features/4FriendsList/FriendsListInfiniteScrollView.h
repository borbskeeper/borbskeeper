//
//  FriendsListInfiniteScrollView.h
//  borbskeeper
//
//  Created by rodrigoandrade on 8/2/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "InfiniteScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendsListInfiniteScrollView : InfiniteScrollView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

NS_ASSUME_NONNULL_END
