//
//  PushNotifications.h
//  borbskeeper
//
//  Created by juliapark628 on 7/25/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
#import "Task.h"


NS_ASSUME_NONNULL_BEGIN

@interface PushNotifications : NSObject

+ (void)createNotificationForTask:(Task *)task WithID:(NSString *)taskID;
+ (void)deleteNotificationForTaskWithID:(nonnull NSString *)taskID; 

@end

NS_ASSUME_NONNULL_END
