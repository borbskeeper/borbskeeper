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
    
    Borb *newBorb = [[Borb alloc] init];
    [newBorb saveInBackgroundWithBlock: ^(BOOL succeeded, NSError *error){
        newUser.usersBorb = newBorb;
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            completion(error);
        }];
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

+ (void)fetchIncompleteTasksOfUser:(NSString *)username WithCompletion:(void (^)(NSMutableArray *))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
    [query whereKey:@"completed" equalTo:@NO];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            completion([NSMutableArray arrayWithArray:posts]);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

+ (void)signOutUser{
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:LOGIN_STORYBOARD_ID bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:LOGIN_VIEW_CONTROLLER_ID];
        appDelegate.window.rootViewController = loginViewController;
    }];
}


@end
