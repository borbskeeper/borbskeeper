//
//  ComposePostTaskCell.h
//  borbskeeper
//
//  Created by rodrigoandrade on 8/5/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComposePostTaskCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dueDate;
@property (strong, nonatomic) Task *task;

- (void)setupWithTask:(Task *)task;
@end

NS_ASSUME_NONNULL_END
