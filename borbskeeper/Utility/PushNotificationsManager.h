//
//  PushNotificationsManager.h
//  borbskeeper
//
//  Created by juliapark628 on 7/25/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
#import "Task.h"


NS_ASSUME_NONNULL_BEGIN

@interface PushNotificationsManager : NSObject

typedef enum {
    REMIND_BEFORE_FIVE_MINUTES,
    REMIND_BEFORE_FIFTEEN_MINUTES,
    REMIND_BEFORE_THIRTY_MINUTES,
    REMIND_BEFORE_SIXTY_MINUTES
} remindBefore;

extern const remindBefore DEFAULT_REMIND_BEFORE;
extern const int MINUTES_TO_SECONDS_CONVERSION;

+ (void)createNotificationForTask:(Task *)task withID:(NSString *)taskID;
+ (void)deleteNotificationForTaskWithID:(nonnull NSString *)taskID;
+ (void)updateAllNotificationsWithNewRemindBefore;
+ (NSString *)descriptionOfRemindBefore:(remindBefore)remindBeforeChoice;
+ (NSArray *)allDescriptionsOfRemindBefore;
+ (NSTimeInterval)secondsOfRemindBefore:(remindBefore)remindBeforeChoice;

@end

NS_ASSUME_NONNULL_END
