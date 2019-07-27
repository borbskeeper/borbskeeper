//
//  Post.h
//  borbskeeper
//
//  Created by juliapark628 on 7/26/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "User.h"
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *postID;

@property (nonatomic, strong) PFUser* author;
@property (nonatomic, strong) Task* task;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic) BOOL verified;

+ (Post *)createPost:(UIImage *)image withTask:(Task *)task; 

@end

NS_ASSUME_NONNULL_END
