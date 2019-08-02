//
//  CompletedTaskCell.h
//  borbskeeper
//
//  Created by rodrigoandrade on 7/29/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "TaskCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompletedTaskCell : TaskCell

@property (weak, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkboxButton;
@property (weak, nonatomic) IBOutlet UILabel *dueDate;
@property (weak, nonatomic) IBOutlet UIButton *sharedIcon;
@property (weak, nonatomic) IBOutlet UIButton *verifiedIcon;

@end

NS_ASSUME_NONNULL_END
