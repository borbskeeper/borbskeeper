//
//  TasksListViewController.h
//  borbskeeper
//
//  Created by cassanene on 7/16/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TasksListViewController : UIViewController

//@property (weak, nonatomic) IBOutlet InfiniteScrollTableView *infiniteScrollTableView;

@property (strong, nonatomic) Task *task;
@property (strong, nonatomic) Borb *borb;
@property (strong, nonatomic) User *user;


@end

NS_ASSUME_NONNULL_END
