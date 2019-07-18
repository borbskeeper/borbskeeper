//
//  EditTasksViewController.h
//  borbskeeper
//
//  Created by juliapark628 on 7/18/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditTasksViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *taskNameField;
@property (weak, nonatomic) IBOutlet UITextView *taskDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

NS_ASSUME_NONNULL_END
