//
//  BorbParseManager.m
//  borbskeeper
//
//  Created by rodrigoandrade on 7/16/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "BorbParseManager.h"

@implementation BorbParseManager

+ (void)createAccount:(NSString*)username withEmail:(NSString*)email withPassword:(NSString*)password withCompletion:(void (^)(NSError *))completion{
    PFUser *newUser = [PFUser user];
    newUser.username = username;
    newUser.email = email;
    newUser.password = password;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        completion(error);
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

@end
