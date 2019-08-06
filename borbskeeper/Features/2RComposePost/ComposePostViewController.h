//
//  ComposePostViewController.h
//  borbskeeper
//
//  Created by juliapark628 on 7/26/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ComposePostViewControllerDelegate

- (void) didPost;

@end

@interface ComposePostViewController : UIViewController

@property (nonatomic, weak) id<ComposePostViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
