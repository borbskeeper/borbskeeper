//
//  TaskCell.h
//  borbskeeper
//
//  Created by cassanene on 7/16/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkboxButton;

- (void)setDataAtCellWithTask:(Task *)task;

@end

NS_ASSUME_NONNULL_END
