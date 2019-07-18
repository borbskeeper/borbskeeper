//
//  EditTasksViewController.h
//  borbskeeper
//
//  Created by cassanene on 7/16/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditTasksViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *decriptionField;
@property (weak, nonatomic) IBOutlet UITextField *tasknameField;
@property (weak, nonatomic) IBOutlet UITextField *deadlineField;

@end

NS_ASSUME_NONNULL_END
