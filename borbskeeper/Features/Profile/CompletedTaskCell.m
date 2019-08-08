//
//  CompletedTaskCell.m
//  borbskeeper
//
//  Created by rodrigoandrade on 7/29/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "CompletedTaskCell.h"
#import "User.h"
#import "Borb.h"
#import "GameConstants.h"
#import "PushNotificationsManager.h"

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

- (IBAction)didTapCheckbox:(id)sender {
    if (self.task.completed == YES){
        self.checkboxButton.selected = NO;
        [Task markTaskAsUnfinished:self.task];
        [PushNotificationsManager createNotificationForTask:self.task withID:[self.task objectId]];
        [BorbParseManager fetchBorb:[User currentUser].usersBorb.objectId WithCompletion:^(NSMutableArray *borbs) {
            Borb *userBorb = borbs[0];
            if ([User currentUser].verificationEnabled) {
                [userBorb decreaseBorbCoinsBy:COIN_REWARD_WITHOUT_VERIFY];
            } else {
                [userBorb decreaseBorbCoinsBy:COIN_REWARD_OPTOUT];
            }
            [userBorb decreaseExperiencePointsBy:XP_GAINED_PER_COMPLETE_TASK];
            [BorbParseManager saveBorb:userBorb withCompletion:nil];
        }];
    }
    [BorbParseManager saveTask:self.task withCompletion:nil];
}


@end
