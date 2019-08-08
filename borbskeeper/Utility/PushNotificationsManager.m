//
//  PushNotificationsManager.m
//  borbskeeper
//
//  Created by juliapark628 on 7/25/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "PushNotificationsManager.h"
#import <UserNotifications/UserNotifications.h>
#import "User.h"
#import "BorbParseManager.h"

static NSString *const DATE_FORMAT = @"'Due' MM/dd/yyyy 'at' hh:mm a";

const remindBefore DEFAULT_REMIND_BEFORE = REMIND_BEFORE_THIRTY_MINUTES;
const int MINUTES_TO_SECONDS_CONVERSION = 60;

@implementation PushNotificationsManager

+ (void)createNotificationForTask:(Task *)task withID:(nonnull NSString *)taskID {
    // creating the content of the push notif
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:task.taskName arguments:nil];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = DATE_FORMAT;
    content.body = [NSString localizedUserNotificationStringForKey:[dateFormatter stringFromDate:task.dueDate]
                                                         arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    
    // creating the trigger of the push notif
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSTimeInterval secondsBefore = -1 * [self secondsOfRemindBefore:([User currentUser].remindBeforeChoice)];
    NSDate *notificationTime = [task.dueDate dateByAddingTimeInterval:secondsBefore];
    NSDateComponents *dueDateComponents = [gregorian components:unitFlags fromDate:notificationTime];
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dueDateComponents repeats:NO];
    
    // creating push notif and adding it
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:taskID
                                                                          content:content trigger:trigger];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:nil];
}

+ (void)deleteNotificationForTaskWithID:(nonnull NSString *)taskID {
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    NSArray *identifiers = @[taskID];
    [center removePendingNotificationRequestsWithIdentifiers:identifiers];
}

+ (void)updateAllNotificationsWithNewRemindBefore {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        if (requests) {
            for (UNNotificationRequest *notification in requests) {
                [BorbParseManager fetchTask:notification.identifier WithCompletion:^(NSMutableArray * _Nonnull tasks) {
                    if (tasks) {
                        Task *task = tasks[0];
                        [self deleteNotificationForTaskWithID:notification.identifier];
                        [self createNotificationForTask:task withID:[task objectId]];
                    }
                }];
            }
        }
    }];
}

+ (NSString *)descriptionOfRemindBefore:(remindBefore)remindBeforeChoice {
    if (remindBeforeChoice == REMIND_BEFORE_FIVE_MINUTES) {
        return @"5 minutes before";
    } else if (remindBeforeChoice == REMIND_BEFORE_FIFTEEN_MINUTES) {
        return @"15 minutes before";
    } else if (remindBeforeChoice == REMIND_BEFORE_THIRTY_MINUTES) {
        return @"30 minutes before";
    } else if (remindBeforeChoice == REMIND_BEFORE_SIXTY_MINUTES) {
        return @"1 hour before";
    }
    return nil;
}

+ (NSArray *)allDescriptionsOfRemindBefore{
    return @[[self descriptionOfRemindBefore:REMIND_BEFORE_FIVE_MINUTES], [self descriptionOfRemindBefore:REMIND_BEFORE_FIFTEEN_MINUTES], [self descriptionOfRemindBefore:REMIND_BEFORE_THIRTY_MINUTES], [self descriptionOfRemindBefore:REMIND_BEFORE_SIXTY_MINUTES]];
}

+ (NSTimeInterval)secondsOfRemindBefore:(remindBefore)remindBeforeChoice {
    if (remindBeforeChoice == REMIND_BEFORE_FIVE_MINUTES) {
        return 5 * MINUTES_TO_SECONDS_CONVERSION;
    } else if (remindBeforeChoice == REMIND_BEFORE_FIFTEEN_MINUTES) {
        return 15 * MINUTES_TO_SECONDS_CONVERSION;
    } else if (remindBeforeChoice == REMIND_BEFORE_THIRTY_MINUTES) {
        return 30 * MINUTES_TO_SECONDS_CONVERSION;
    } else if (remindBeforeChoice == REMIND_BEFORE_SIXTY_MINUTES) {
        return 60 * MINUTES_TO_SECONDS_CONVERSION;
    }
    return 0;
}
@end
