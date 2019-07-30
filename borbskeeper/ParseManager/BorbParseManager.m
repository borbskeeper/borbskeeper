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
#import "Post.h"

@implementation BorbParseManager


static NSString *const LOGIN_STORYBOARD_ID = @"Login";
static NSString *const LOGIN_VIEW_CONTROLLER_ID = @"login";

static NSString *const QUERY_TASK_NAME = @"Task";
static NSString *const TASK_DATE_CREATED_KEY = @"createdAt";
static NSString *const TASK_AUTHOR_KEY = @"author";
static NSString *const TASK_COMPLETED_KEY = @"completed";

static NSString *const QUERY_BORB_NAME = @"Borb";
static NSString *const BORB_ID_KEY = @"objectId";
static NSString *const TASK_POSTED_KEY = @"posted";

static int const PARSE_QUERY_LIMIT = 20;

+ (void)createAccount:(NSString*)username withEmail:(NSString*)email withPassword:(NSString*)password withCompletion:(void (^)(NSError *))completion{
    User *newUser = (User *)[PFUser user];
    newUser.username = username;
    newUser.email = email;
    newUser.password = password;
    newUser.userCoins = @0;
    newUser.friendsList = [[NSMutableArray alloc] init];
    
    UIImage *defaultImage = [UIImage imageNamed:@"profile_placeholder"];
    NSData *imageData = UIImagePNGRepresentation(defaultImage);
    newUser.profilePicture = [PFFileObject fileObjectWithName:@"profile.png" data:imageData];
    
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

+ (void)fetchIncompleteTasksOfUser:(NSString *)username WithCompletion:(void (^)(NSMutableArray *))completion {
    PFQuery *query = [PFQuery queryWithClassName:QUERY_TASK_NAME];
    query.limit = PARSE_QUERY_LIMIT;
    [query orderByDescending:TASK_DATE_CREATED_KEY];
    [query includeKey:TASK_AUTHOR_KEY];
    [query whereKey:TASK_AUTHOR_KEY equalTo:[PFUser currentUser]];
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
    [query orderByDescending:TASK_DATE_CREATED_KEY];
    [query includeKey:TASK_AUTHOR_KEY];
    [query whereKey:TASK_AUTHOR_KEY equalTo:[PFUser currentUser]];
    [query whereKey:TASK_COMPLETED_KEY equalTo:@NO];
    [query whereKey:TASK_DATE_CREATED_KEY lessThan:date];
    
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
    [query orderByDescending:TASK_DATE_CREATED_KEY];
    [query includeKey:TASK_AUTHOR_KEY];
    [query whereKey:TASK_AUTHOR_KEY equalTo:[PFUser currentUser]];
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
    [query orderByDescending:TASK_DATE_CREATED_KEY];
    [query includeKey:TASK_AUTHOR_KEY];
    [query whereKey:TASK_AUTHOR_KEY equalTo:[PFUser currentUser]];
    [query whereKey:TASK_COMPLETED_KEY equalTo:@YES];
    [query whereKey:TASK_DATE_CREATED_KEY lessThan:date];
    
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
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    query.limit = PARSE_QUERY_LIMIT;
    [query whereKey:@"verified" equalTo:@NO];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            completion([NSMutableArray arrayWithArray:posts]);
        } else {
            NSLog(@"%@", error.localizedDescription);
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
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
