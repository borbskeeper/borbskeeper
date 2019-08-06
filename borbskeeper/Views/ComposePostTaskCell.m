//
//  ComposePostTaskCell.m
//  borbskeeper
//
//  Created by rodrigoandrade on 8/5/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "ComposePostTaskCell.h"

@implementation ComposePostTaskCell
static NSString *const DATE_FORMAT = @"'Due' MM/dd/yyyy 'at' hh:mm a";

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithTask:(Task *)task {
    self.task = task;
    self.taskNameLabel.text = task.taskName;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = DATE_FORMAT;
    self.dueDate.text = [dateFormatter stringFromDate:self.task.dueDate];
}

@end
