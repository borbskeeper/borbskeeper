//
//  TaskCell.m
//  borbskeeper
//
//  Created by cassanene on 7/16/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "TaskCell.h"

@implementation TaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)didTapCheckbox:(id)sender {
    if (self.task.completed == NO){
        [Task markTaskAsFinished:self.task];
        self.checkboxButton.selected = YES;
    } else {
        [Task markTaskAsUnfinished:self.task];
        self.checkboxButton.selected = NO;
    }
    [BorbParseManager saveTask:self.task withCompletion:nil];
}

- (void)setDataAtCellWithTask:(Task *)task {
    self.task = task;
    self.taskNameLabel.text = task.taskName;
    if (self.task.completed == YES){
        self.checkboxButton.selected = YES;
    } else {
        self.checkboxButton.selected = NO;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"'Due' yyyy-MM-dd 'at' hh:mm a";
    self.dueDate.text = [dateFormatter stringFromDate:self.task.dueDate];
}

@end
