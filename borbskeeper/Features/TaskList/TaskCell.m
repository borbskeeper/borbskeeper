//
//  TaskCell.m
//  borbskeeper
//
//  Created by cassanene on 7/16/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "TaskCell.h"
#import "User.h"
#import "Borb.h"
#import "GameConstants.h"
#import "PushNotificationsManager.h"

@implementation TaskCell
static NSString *const DATE_FORMAT = @"'Due' MM/dd/yyyy 'at' hh:mm a";

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
        self.checkboxButton.selected = YES;
        [Task markTaskAsFinished:self.task];
        [[User currentUser] increaseUserCoinsBy: COIN_REWARD_OPTOUT];
        [PushNotificationsManager deleteNotificationForTaskWithID:[self.task objectId]];
        [BorbParseManager fetchBorb:[User currentUser].usersBorb.objectId WithCompletion:^(NSMutableArray *borbs) {
            Borb *userBorb = borbs[0];
            [userBorb increaseExperiencePointsBy:XP_GAINED_PER_COMPLETE_TASK];
            [BorbParseManager saveBorb:userBorb withCompletion:nil];
        }];
    } else {
        self.checkboxButton.selected = NO;
        [Task markTaskAsUnfinished:self.task];
        [[User currentUser] decreaseUserCoinsBy: COIN_REWARD_OPTOUT];
        [PushNotificationsManager createNotificationForTask:self.task withID:[self.task objectId]];
        [BorbParseManager fetchBorb:[User currentUser].usersBorb.objectId WithCompletion:^(NSMutableArray *borbs) {
            Borb *userBorb = borbs[0];
            [userBorb decreaseExperiencePointsBy:XP_GAINED_PER_COMPLETE_TASK];
            [BorbParseManager saveBorb:userBorb withCompletion:nil];
        }];
    }
    [BorbParseManager saveTask:self.task withCompletion:nil];
    [BorbParseManager saveUser:[User currentUser] withCompletion:nil];
}

- (void)setupWithTask:(Task *)task {
    self.task = task;
    self.taskNameLabel.text = task.taskName;
    if (self.task.completed == YES){
        self.checkboxButton.selected = YES;
    } else {
        self.checkboxButton.selected = NO;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = DATE_FORMAT;
    self.dueDate.text = [dateFormatter stringFromDate:self.task.dueDate];
}

@end
