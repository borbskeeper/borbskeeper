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
#import "Post.h"
#import "FriendRequest.h"
#import "FriendsList.h"
NS_ASSUME_NONNULL_BEGIN

@interface BorbParseManager : NSObject
@property (strong, nonatomic) NSError *completionError;

+ (void)createAccount:(NSString*)username withEmail:(NSString*)email withPassword:(NSString*)password withCompletion:(void (^)(NSError *))completion;

+ (void)loginUser:(NSString*)username withPassword:(NSString*)password withCompletion:(void (^)(NSError *))completion;

+ (void)saveTask:(Task*)task withCompletion: (PFBooleanResultBlock  _Nullable)completion;

+ (void)saveUser:(User*)user withCompletion: (PFBooleanResultBlock  _Nullable)completion;

+ (void)saveBorb:(Borb*)borb withCompletion: (PFBooleanResultBlock  _Nullable)completion;

+ (void)savePost:(Post*)post withCompletion: (PFBooleanResultBlock _Nullable)completion;

+ (void)saveFriendRequest:(FriendRequest*)friendRequest withCompletion: (PFBooleanResultBlock _Nullable)completion;

+ (void)saveFriendsList:(FriendsList*)friendsList withCompletion: (PFBooleanResultBlock  _Nullable)completion;

+ (void)fetchBorb:(NSString *)borbID WithCompletion:(void (^)(NSMutableArray *))completion;

+ (void)fetchIncompleteTasksOfUser:(NSString *)username WithCompletion:(void (^)(NSMutableArray *))completion;

+ (void)loadMoreIncompleteTasksOfUser:(NSString *)username withLaterDate:(NSDate *)date WithCompletion:(void (^)(NSMutableArray *))completion;

+ (void)fetchCompleteTasksOfUser:(NSString *)username ifNotPosted:(BOOL)postedStatus withCompletion:(void (^)(NSMutableArray *))completion;

+ (void)loadMoreCompleteTasksOfUser:(NSString *)username ifNotPosted:(BOOL)postedStatus withLaterDate:(NSDate *)date withCompletion:(void (^)(NSMutableArray *))completion;

+ (void) fetchGlobalPostsWithCompletion: (void (^)(NSMutableArray *))completion;

+ (void) fetchUser:(NSString*)username withCompletion: (void (^)(User *))completion;

+ (void) fetchFriendRequestFrom:(User*)sender withRecipient: (User*)recipient withCompletion: (void (^)(BOOL))friendRequestFound;

+ (void) fetchFriendRequests:(User*)recipient withCompletion:(void (^)(NSMutableArray *))completion;

+ (void)loadMoreFriendRequests:(User*)recipient withLaterDate:(NSDate *)date withCompletion:(void (^)(NSMutableArray *))completion;

+ (void)deleteFriendRequest: (FriendRequest*)friendRequest WithCompletion: (void (^)(BOOL))completion;

+ (void) fetchUserFromID:(User*)user withCompletion: (void (^)(User *))completion;

+ (void) fetchFriendListFromID:(NSString*)friendListID withCompletion: (void (^)(FriendsList *))completion;

+ (void)signOutUser;

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;

@end

NS_ASSUME_NONNULL_END
