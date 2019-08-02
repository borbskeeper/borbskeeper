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
#import "PushNotificationsManager.h"
#import "AlertManager.h"

@interface ComposeTaskViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *taskTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *taskDescTextView;
@property (weak, nonatomic) IBOutlet UIDatePicker *taskDeadlineDatePicker;

@end

@implementation ComposeTaskViewController

static NSString *const TASK_DESCRIPTION_PLACEHOLDER = @"What are the details of your task?";

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
    if ([AlertManager isInvalidTextField:@[self.taskTitleTextField.text]] == YES){
        [AlertManager presentSaveTaskNotSuccesfulAlert:self];
    } else {
        if (self.task == nil) {
            Task *newTask = [Task createTask:self.taskTitleTextField.text
                             withDescription:self.taskDescTextView.text
                                 withDueDate:self.taskDeadlineDatePicker.date];
            [BorbParseManager saveTask:newTask withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    NSString *objectId = [newTask objectId];
                    [PushNotificationsManager createNotificationForTask:newTask withID:objectId];
                    [self.delegate didSaveTask];
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [AlertManager presentSaveTaskNotSuccesfulAlert:self];
                }
            }];
        } else {
            PFQuery *query = [PFQuery queryWithClassName:@"Task"];

            NSString *taskId = [self.task objectId];
            [query getObjectInBackgroundWithId:taskId
                                         block:^(PFObject *object, NSError *error) {
                                             Task* task = (Task *)object;
                                             task.taskName = self.taskTitleTextField.text;
                                             task.taskDescription = self.taskDescTextView.text;
                                             task.dueDate = self.taskDeadlineDatePicker.date;
                                             [BorbParseManager saveTask:task withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                                                 [PushNotificationsManager createNotificationForTask:(Task *)task withID:taskId];
                                                 [self.delegate didSaveTask];
                                                 [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                                             }];
                                         }];
            [PushNotificationsManager deleteNotificationForTaskWithID:taskId];
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