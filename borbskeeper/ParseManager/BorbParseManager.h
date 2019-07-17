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

NS_ASSUME_NONNULL_BEGIN

@interface BorbParseManager : NSObject
@property (strong, nonatomic) NSError *completionError;

+ (void)createAccount:(NSString*)username withEmail:(NSString*)email withPassword:(NSString*)password withCompletion:(void (^)(NSError *))completion;

+ (void)loginUser:(NSString*)username withPassword:(NSString*)password withCompletion:(void (^)(NSError *))completion;

@end

NS_ASSUME_NONNULL_END
