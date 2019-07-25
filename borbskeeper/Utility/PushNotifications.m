//
//  PushNotifications.m
//  borbskeeper
//
//  Created by juliapark628 on 7/25/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "PushNotifications.h"
#import <UserNotifications/UserNotifications.h>

static NSString *const DATE_FORMAT = @"'Due' MM/dd/yyyy 'at' hh:mm a";

@implementation PushNotifications

+ (void)createNotificationForTask:(Task *)task WithID:(nonnull NSString *)taskID {
    // creating the content of the push notif
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:task.taskName arguments:nil];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = DATE_FORMAT;
    content.body = [NSString localizedUserNotificationStringForKey:[dateFormatter stringFromDate:task.dueDate]
                                                         arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    
    // creating the trigger of the push notif
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *dueDateComponents = [gregorian components:unitFlags fromDate:task.dueDate];
    UNCalendarNotificationTrigger* trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dueDateComponents repeats:NO];
    
    // creating push notif and adding it
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:taskID
                                                                          content:content trigger:trigger];
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:nil];
}

+ (void)deleteNotificationForTaskWithID:(nonnull NSString *)taskID {
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    NSArray *identifiers = @[taskID];
    [center removePendingNotificationRequestsWithIdentifiers:identifiers];
}

@end
