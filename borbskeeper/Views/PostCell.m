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
#import "GameConstants.h"

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
        
        if ([[User currentUser].username isEqualToString:post.author.username] || task.verified) {
            self.verifyButton.enabled = NO;
        }
    }];
    
    PFFileObject *profileImageFile = post.author[USER_PROF_PIC_KEY];
    NSURL *profileImageURL = [NSURL URLWithString:profileImageFile.url];
    [self.profilePhotoImageView setImageWithURL:profileImageURL];
    self.profilePhotoImageView.layer.cornerRadius = self.profilePhotoImageView.frame.size.width / 2;
    self.profilePhotoImageView.clipsToBounds = YES;
    
    PFFileObject *userImageFile = post.image;
    NSURL *imageURL = [NSURL URLWithString:userImageFile.url];
    [self.photoImageView setImageWithURL:imageURL];
}

- (IBAction)didClickVerify:(id)sender {
    User *poster = (User *)self.post.author;
    if ([[User currentUser].username isEqualToString:poster.username]) {
        NSLog(@"Cannot verify own posts");
        return;
    }
    [BorbParseManager fetchTask:self.post.task.objectId WithCompletion:^(NSMutableArray *tasks) {
        Task *task = tasks[0];
        if (task.verified) {
            NSLog(@"Task is already verified");
            return;
        }
        task.verified = true;
        [BorbParseManager saveTask:task withCompletion:nil];
    }];
    [BorbParseManager fetchBorb:poster.usersBorb.objectId WithCompletion:^(NSMutableArray *borbs) {
        Borb *posterBorb = borbs[0];
        [posterBorb increaseBorbCoinsBy:COIN_REWARD_WITH_VERIFY];
        [BorbParseManager saveBorb:posterBorb withCompletion:nil];
    }];
    self.verifyButton.enabled = NO;
}



@end
