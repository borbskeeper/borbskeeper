//
//  BorbParseManager.m
//  borbskeeper
//
//  Created by rodrigoandrade on 7/16/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "BorbParseManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@implementation BorbParseManager


static NSString *const LOGIN_STORYBOARD_ID = @"Login";
static NSString *const LOGIN_VIEW_CONTROLLER_ID = @"login";

static NSString *const QUERY_TASK_NAME = @"Task";
static NSString *const TASK_DATE_CREATED_KEY = @"createdAt";
static NSString *const TASK_DATE_DUE_KEY = @"dueDate";

static NSString *const AUTHOR_KEY = @"author";
static NSString *const TASK_COMPLETED_KEY = @"completed";

static NSString *const QUERY_POST_NAME = @"Post";
static NSString *const POST_VERIFIED_KEY = @"verified";

static NSString *const QUERY_BORB_NAME = @"Borb";
static NSString *const BORB_ID_KEY = @"objectId";
static NSString *const TASK_POSTED_KEY = @"posted";

static NSString *const PLACEHOLDER_IMAGE_NAME = @"profile_placeholder";
static NSString *const POST_PLACEHOLDER_IMAGE_NAME = @"image.png";
static NSString *const PROFILE_IMAGE_KEY = @"profile.png";

static int const PARSE_QUERY_LIMIT = 20;

+ (void)createAccount:(NSString*)username withEmail:(NSString*)email withPassword:(NSString*)password withCompletion:(void (^)(NSError *))completion{
    User *newUser = (User *)[PFUser user];
    newUser.username = username;
    newUser.email = email;
    newUser.password = password;
    newUser.userCoins = @0;
    newUser.friendsList = [[NSMutableArray alloc] init];
    newUser.userLogin = [NSDate date];
    
    UIImage *defaultImage = [UIImage imageNamed:PLACEHOLDER_IMAGE_NAME];
    NSData *imageData = UIImagePNGRepresentation(defaultImage);
    newUser.profilePicture = [PFFileObject fileObjectWithName:PROFILE_IMAGE_KEY data:imageData];
    
    Borb *newBorb = [[Borb alloc] initWithInitialStats];
    [newBorb saveInBackgroundWithBlock: ^(BOOL succeeded, NSError *error){
        if (succeeded) {
            newUser.usersBorb = newBorb;
            
            [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
                completion(error);
            }];
        } else {
            completion(error);
        }
    }];
}

+ (void)loginUser:(NSString*)username withPassword:(NSString*)password withCompletion:(void (^)(NSError *))completion{
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        completion(error);
    }];
}

+ (void)saveTask:(Task*)task withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    [task saveInBackgroundWithBlock: completion];
}

+ (void)saveUser:(User*)user withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    [user saveInBackgroundWithBlock: completion];
}

+ (void)saveBorb:(Borb*)borb withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    [borb saveInBackgroundWithBlock: completion];
}

+ (void)savePost:(Post*)post withCompletion: (PFBooleanResultBlock _Nullable)completion{
    [post saveInBackgroundWithBlock: completion];
}

+ (void)saveFriendRequest:(FriendRequest*)friendRequest withCompletion: (PFBooleanResultBlock _Nullable)completion{
    [friendRequest saveInBackgroundWithBlock: completion];
}

+ (void)fetchIncompleteTasksOfUser:(NSString *)username WithCompletion:(void (^)(NSMutableArray *))completion {
    PFQuery *query = [PFQuery queryWithClassName:QUERY_TASK_NAME];
    query.limit = PARSE_QUERY_LIMIT;
    [query orderByAscending:TASK_DATE_DUE_KEY];
    [query includeKey:AUTHOR_KEY];
    [query whereKey:AUTHOR_KEY equalTo:[PFUser currentUser]];
    [query whereKey:TASK_COMPLETED_KEY equalTo:@NO];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            completion([NSMutableArray arrayWithArray:posts]);
        } else {
            // TBD: Call completion with error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

+ (void)loadMoreIncompleteTasksOfUser:(NSString *)username withLaterDate:(NSDate *)date WithCompletion:(void (^)(NSMutableArray *))completion {
    PFQuery *query = [PFQuery queryWithClassName:QUERY_TASK_NAME];
    query.limit = PARSE_QUERY_LIMIT;
    [query orderByAscending:TASK_DATE_DUE_KEY];
    [query includeKey:AUTHOR_KEY];
    [query whereKey:AUTHOR_KEY equalTo:[PFUser currentUser]];
    [query whereKey:TASK_COMPLETED_KEY equalTo:@NO];
    [query whereKey:TASK_DATE_DUE_KEY greaterThan:date];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            completion([NSMutableArray arrayWithArray:posts]);
        } else {
            // TBD: Call completion with error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

+ (void)fetchCompleteTasksOfUser:(NSString *)username ifNotPosted:(BOOL)postedStatus withCompletion:(void (^)(NSMutableArray *))completion {
    PFQuery *query = [PFQuery queryWithClassName:QUERY_TASK_NAME];
    query.limit = PARSE_QUERY_LIMIT;
    [query orderByDescending:TASK_DATE_DUE_KEY];
    [query includeKey:AUTHOR_KEY];
    [query whereKey:AUTHOR_KEY equalTo:[PFUser currentUser]];
    [query whereKey:TASK_COMPLETED_KEY equalTo:@YES];
    
    if (postedStatus == YES){
        [query whereKey:TASK_POSTED_KEY equalTo:@NO];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            completion([NSMutableArray arrayWithArray:posts]);
        } else {
            // TBD: Call completion with error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

+ (void)loadMoreCompleteTasksOfUser:(NSString *)username ifNotPosted:(BOOL)postedStatus withLaterDate:(NSDate *)date withCompletion:(void (^)(NSMutableArray *))completion {
    PFQuery *query = [PFQuery queryWithClassName:QUERY_TASK_NAME];
    query.limit = PARSE_QUERY_LIMIT;
    [query orderByDescending:TASK_DATE_DUE_KEY];
    [query includeKey:AUTHOR_KEY];
    [query whereKey:AUTHOR_KEY equalTo:[PFUser currentUser]];
    [query whereKey:TASK_COMPLETED_KEY equalTo:@YES];
    [query whereKey:TASK_DATE_DUE_KEY lessThan:date];
    
    if (postedStatus == YES){
        [query whereKey:TASK_POSTED_KEY equalTo:@YES];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            completion([NSMutableArray arrayWithArray:posts]);
        } else {
            // TBD: Call completion with error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

+ (void)fetchBorb:(NSString *)borbID WithCompletion:(void (^)(NSMutableArray *))completion {
    PFQuery *query = [PFQuery queryWithClassName:QUERY_BORB_NAME];
    [query whereKey:BORB_ID_KEY equalTo:borbID];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *borbs, NSError *error) {
        if (borbs != nil) {
            completion([NSMutableArray arrayWithArray:borbs]);
        } else {
            // TBD: Call completion with error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

+ (void) fetchGlobalPostsWithCompletion: (void (^)(NSMutableArray *))completion {
    PFQuery *query = [PFQuery queryWithClassName:QUERY_POST_NAME];
    [query includeKey:AUTHOR_KEY];
    [query orderByDescending:TASK_DATE_CREATED_KEY];
    query.limit = PARSE_QUERY_LIMIT;
    [query whereKey:POST_VERIFIED_KEY equalTo:@NO];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            completion([NSMutableArray arrayWithArray:posts]);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

+ (void) fetchUser:(NSString*)username withCompletion: (void (^)(User *))completion {
    PFQuery *query = [User query];
    [query whereKey:@"username" equalTo:username];

    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (users.count > 0) {
            completion(users[0]);
        } else {
            User *noUser;
            completion(noUser);
        }
    }];
}

+ (void) fetchFriendRequestFrom:(User*)sender withRecipient: (User*)recipient withCompletion: (void (^)(BOOL))friendRequestFound {
    PFQuery *query = [PFQuery queryWithClassName:@"FriendRequest"];
    [query whereKey:@"sender" equalTo:sender];
    [query whereKey:@"recipient" equalTo:recipient];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *activeRequests, NSError *error) {
        
        if (activeRequests.count > 0) {
            friendRequestFound(YES);
        } else {
            [query whereKey:@"sender" equalTo:recipient];
            [query whereKey:@"recipient" equalTo:sender];
            [query findObjectsInBackgroundWithBlock:^(NSArray *activeRequests, NSError *error) {
                
                if (activeRequests.count > 0) {
                    friendRequestFound(YES);
                } else {
                    friendRequestFound(NO);
                }
            }];
        }
    }];
}

+ (void)signOutUser {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:LOGIN_STORYBOARD_ID bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:LOGIN_VIEW_CONTROLLER_ID];
        appDelegate.window.rootViewController = loginViewController;
    }];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:POST_PLACEHOLDER_IMAGE_NAME data:imageData];
}

@end
