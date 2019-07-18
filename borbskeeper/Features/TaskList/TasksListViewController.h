//
//  TasksListViewController.h
//  borbskeeper
//
//  Created by cassanene on 7/16/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskCell.h"
#import "EditTasksViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TasksListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
