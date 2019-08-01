//
//  ComposePostForTaskViewController.h
//  borbskeeper
//
//  Created by juliapark628 on 7/29/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"


NS_ASSUME_NONNULL_BEGIN

@protocol ComposePostViewControllerDelegate
- (void)didPostTask;

@end

@interface ComposePostForTaskViewController : UIViewController
@property (nonatomic, weak) id<ComposePostViewControllerDelegate> delegate;
@property (nonatomic, strong) Task *selectedTask;

@end

NS_ASSUME_NONNULL_END
