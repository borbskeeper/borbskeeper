//
//  User.h
//  borbskeeper
//
//  Created by juliapark628 on 7/16/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Borb.h"
#import "PushNotificationsManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface User : PFUser<PFSubclassing>

@property (nonatomic, strong) NSString *screenname;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSMutableArray *friendsList;
@property (nonatomic, strong) NSString *friendsListID;
@property (nonatomic, strong) PFFileObject *profilePicture;
@property (nonatomic, strong) NSNumber *userCoins;
@property (nonatomic, strong) Borb *usersBorb;
@property (nonatomic, strong) NSDate *userLogin;
@property remindBefore remindBeforeChoice;

@end

NS_ASSUME_NONNULL_END
