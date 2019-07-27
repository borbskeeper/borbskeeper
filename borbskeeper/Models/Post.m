//
//  Post.m
//  borbskeeper
//
//  Created by juliapark628 on 7/26/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "Post.h"

@implementation Post

@dynamic postID;

@dynamic author;
@dynamic task;
@dynamic image;
@dynamic verified;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (Post *)createPost:(UIImage *)image withTask:(Task *)task {
    
    Post *newPost = [Post new];
    newPost.author = [PFUser currentUser];
    newPost.image = [self getPFFileFromImage:image];
    newPost.task = task;
    
    return newPost; 
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
