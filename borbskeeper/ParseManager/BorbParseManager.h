//
//  BorbParseManager.h
//  borbskeeper
//
//  Created by rodrigoandrade on 7/16/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "User.h"
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface BorbParseManager : NSObject
@property (strong, nonatomic) NSError *completionError;

+ (void)createAccount:(NSString*)username withEmail:(NSString*)email withPassword:(NSString*)password withCompletion:(void (^)(NSError *))completion;

+ (void)loginUser:(NSString*)username withPassword:(NSString*)password withCompletion:(void (^)(NSError *))completion;

+ (void)saveTask:(Task*)task withCompletion: (PFBooleanResultBlock  _Nullable)completion;

+ (void)saveUser:(User*)user withCompletion: (PFBooleanResultBlock  _Nullable)completion;

+ (void)saveBorb:(Borb*)borb withCompletion: (PFBooleanResultBlock  _Nullable)completion;

+ (void)fetchBorb:(NSString *)borbID WithCompletion:(void (^)(NSMutableArray *))completion;

+ (void)fetchIncompleteTasksOfUser:(NSString *)username WithCompletion:(void (^)(NSMutableArray *))completion;

+ (void)loadMoreIncompleteTasksOfUser:(NSString *)username withLaterDate:(NSDate *)date WithCompletion:(void (^)(NSMutableArray *))completion;

+ (void)signOutUser;

@end

NS_ASSUME_NONNULL_END
