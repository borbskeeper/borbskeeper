//
//  Task.m
//  borbskeeper
//
//  Created by juliapark628 on 7/16/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "Task.h"
#import "User.h"
#import <UserNotifications/UserNotifications.h>

@implementation Task

@dynamic taskName;
@dynamic dueDate;
@dynamic taskDescription;
@dynamic author;
@dynamic completed;
@dynamic verified;
@dynamic posted;

const int COIN_REWARD_FOR_TASK_OPT_OUT = 5;
static NSString *const DATE_FORMAT = @"'Due' MM/dd/yyyy 'at' hh:mm a";

+ (NSString *)parseClassName {
    return @"Task";
}

+ (Task*)createTask:(NSString*)title withDescription:(NSString*)description withDueDate:(NSDate*)date{
    
    Task *newTask = [Task new];
    newTask.author = [PFUser currentUser];
    newTask.taskName = title;
    newTask.taskDescription = description;
    newTask.dueDate = date;
    newTask.completed = NO; 
    newTask.verified = NO;
    newTask.posted = NO;
    
    [self createNotificationForTask:newTask];
    
    return newTask;
}

+ (void)createNotificationForTask:(Task *)task {
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:task.taskName arguments:nil];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = DATE_FORMAT;
    content.body = [NSString localizedUserNotificationStringForKey:[dateFormatter stringFromDate:task.dueDate]
                                                         arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *dueDateComponents = [gregorian components:unitFlags fromDate:task.dueDate];
    UNCalendarNotificationTrigger* trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dueDateComponents repeats:NO];
    
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"FiveSecond"
                                                                          content:content trigger:trigger];
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:nil];
}

+ (void)editTask:(Task*)task withTitle:(NSString*)title withDescription:(NSString*)description withDueDate:(NSDate*)date{
    task.taskName = title;
    task.taskDescription = description;
    task.dueDate = date;
}

+ (void)markTaskAsFinished:(Task*)task{
    task.completed = YES;
    [User currentUser].userCoins = [NSNumber numberWithFloat:([[User currentUser].userCoins intValue] + COIN_REWARD_FOR_TASK_OPT_OUT)];
}

+ (void)markTaskAsUnfinished:(Task*)task{
    task.completed = NO;
    [User currentUser].userCoins = [NSNumber numberWithFloat:([[User currentUser].userCoins intValue] - COIN_REWARD_FOR_TASK_OPT_OUT)];
}

+ (BOOL)checkForInvalidTextFields:(NSArray*)fieldsToBeChecked{
    for (NSString *textFieldText in fieldsToBeChecked){
        if (textFieldText == nil){
            return  YES;
        } else {
            NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            NSString *trimmed = [textFieldText stringByTrimmingCharactersInSet:whitespace];
            if ([trimmed length] == 0) {
                return YES;
            }
        } 
    }
    return NO;
}
@end
