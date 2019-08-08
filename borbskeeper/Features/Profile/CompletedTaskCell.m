//
//  CompletedTaskCell.m
//  borbskeeper
//
//  Created by rodrigoandrade on 7/29/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "CompletedTaskCell.h"

@implementation CompletedTaskCell

@dynamic taskNameLabel;
@dynamic checkboxButton;
@dynamic dueDate;
@dynamic noteCardView;

static NSString *const DATE_FORMAT = @"MM/dd/yyyy 'at' hh:mm a";

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupWithTask:(Task *)task {
    self.task = task;
    self.taskNameLabel.text = task.taskName;
    
    if (self.task.completed == YES){
        self.checkboxButton.selected = YES;
    } else {
        self.checkboxButton.selected = NO;
    }
    
    if (self.task.posted == YES){
        self.sharedIcon.selected = YES;
    } else {
        self.sharedIcon.selected = NO;
    }
    
    if (self.task.verified == YES){
        self.verifiedIcon.selected = YES;
    } else {
        self.verifiedIcon.selected = NO;
    }
    
    self.noteCardView.layer.cornerRadius = 10;
    self.noteCardView.clipsToBounds = YES;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = DATE_FORMAT;
    self.dueDate.text = [dateFormatter stringFromDate:self.task.dueDate];
}


@end
