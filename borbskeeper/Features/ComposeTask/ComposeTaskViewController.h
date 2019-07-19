//
//  ComposeTaskViewController.h
//  borbskeeper
//
//  Created by rodrigoandrade on 7/18/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorbParseManager.h"
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN


@protocol ComposeViewControllerDelegate
- (void)didSaveTask;

@end

@interface ComposeTaskViewController : UIViewController

@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
