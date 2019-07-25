//
//  ComposeTaskViewController.m
//  borbskeeper
//
//  Created by rodrigoandrade on 7/18/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "ComposeTaskViewController.h"
#import "TasksListViewController.h"
#import "UITextView+Placeholder.h"
#import "Task.h"
#import "PushNotifications.h"

@interface ComposeTaskViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *taskTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *taskDescTextView;
@property (weak, nonatomic) IBOutlet UIDatePicker *taskDeadlineDatePicker;

@end

@implementation ComposeTaskViewController

static NSString *const TASK_DESCRIPTION_PLACEHOLDER = @"What are the details of your task?";

static NSString *const UNSUCCESSFUL_TASK_SAVE_TITLE = @"Could not save task";
static NSString *const UNSUCCESSFUL_TASK_SAVE_MESSAGE = @"Please try to save task again.";
static NSString *const OK_ACTION_TITLE = @"OK";
static NSString *const EDIT_SEGUE_ID = @"editTaskSegue";


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTextView];
    [self setupDatePicker];
}
- (void)setupDatePicker {
    self.taskDeadlineDatePicker.minimumDate = [NSDate date];
}

- (void)setupTextView {
    if (self.task == nil) {
        self.taskDescTextView.delegate = self;
        self.taskDescTextView.placeholder = TASK_DESCRIPTION_PLACEHOLDER;
        self.taskDescTextView.placeholderColor = [UIColor lightGrayColor];
    } else {
        self.taskTitleTextField.text = self.task.taskName;
        self.taskDescTextView.text = self.task.taskDescription;
        self.taskDeadlineDatePicker.date = self.task.dueDate;
    }
}

- (IBAction)didTapCancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapSaveTask:(id)sender {

    UIAlertController *saveNotSuccessfulAlert = [UIAlertController alertControllerWithTitle:UNSUCCESSFUL_TASK_SAVE_TITLE
                                                                                     message:UNSUCCESSFUL_TASK_SAVE_MESSAGE
                                                                              preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:OK_ACTION_TITLE
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                     }];
    [saveNotSuccessfulAlert addAction:okAction];
    
    if ([Task checkForInvalidTextFields:@[self.taskTitleTextField.text]] == YES){
        [self presentViewController:saveNotSuccessfulAlert animated:YES completion:nil];
    } else {
        if (self.task == nil) {
            
            Task *newTask = [Task createTask:self.taskTitleTextField.text
                             withDescription:self.taskDescTextView.text
                                 withDueDate:self.taskDeadlineDatePicker.date];
            [BorbParseManager saveTask:newTask withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    NSString *objectId = [newTask objectId];
                    [PushNotifications createNotificationForTask:newTask WithID:objectId];
                    [self.delegate didSaveTask];
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [self presentViewController:saveNotSuccessfulAlert animated:YES completion:nil];
                }
            }];
        } else {
            PFQuery *query = [PFQuery queryWithClassName:@"Task"];
            
            NSString *objectId = self.task.objectId;
            [query getObjectInBackgroundWithId:objectId
                                         block:^(PFObject *task, NSError *error) {
                                             task[@"taskName"] = self.taskTitleTextField.text;
                                             task[@"taskDescription"] = self.taskDescTextView.text;
                                             task[@"dueDate"] = self.taskDeadlineDatePicker.date;
                                             [task saveInBackground];
                                         }];
            [PushNotifications deleteNotificationForTaskWithID:objectId];
            [PushNotifications createNotificationForTask:self.task WithID:objectId];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (IBAction)didTapCreateTaskView:(id)sender {
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
