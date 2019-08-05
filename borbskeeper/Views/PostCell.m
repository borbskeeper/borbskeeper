//
//  PostCell.m
//  borbskeeper
//
//  Created by juliapark628 on 7/29/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "PostCell.h"
#import "DateTools.h"
#import "UIImageView+AFNetworking.h"
#import "BorbParseManager.h"

@implementation PostCell

static NSString *const USER_PROF_PIC_KEY = @"profilePicture";

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupWithPost:(Post *)post {
    self.post = post;
    
    self.usernameLabel.text = post.author.username;
    self.datePostedLabel.text = [post.createdAt timeAgoSinceNow];
    [BorbParseManager fetchTask:self.post.task.objectId WithCompletion:^(NSMutableArray *tasks) {
        Task *task = tasks[0];
        self.taskNameLabel.text = task.taskName;
    }];
    
    PFFileObject *profileImageFile = post.author[USER_PROF_PIC_KEY];
    NSURL *profileImageURL = [NSURL URLWithString:profileImageFile.url];
    [self.profilePhotoImageView setImageWithURL:profileImageURL];
    
    PFFileObject *userImageFile = post.image;
    NSURL *imageURL = [NSURL URLWithString:userImageFile.url];
    [self.photoImageView setImageWithURL:imageURL];
}

- (IBAction)didClickVerify:(id)sender {
    if ([User currentUser] == self.post.author) {
        NSLog(@"error");
        return;
    }
    self.post.task.verified = true; 
}



@end
