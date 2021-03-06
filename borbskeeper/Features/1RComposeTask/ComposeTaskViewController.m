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

@interface ComposeTaskViewController () <UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *taskTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *taskDescTextView;
@property (weak, nonatomic) IBOutlet UIDatePicker *taskDeadlineDatePicker;
@property (weak, nonatomic) IBOutlet UIButton *deleteTaskButton;
@property (weak, nonatomic) IBOutlet UILabel *charRemainingCount;
@property BOOL posting;

@end

@implementation ComposeTaskViewController

static NSString *const TASK_DESCRIPTION_PLACEHOLDER = @"What are the details of your task?";
static NSString *const EDIT_SEGUE_ID = @"editTaskSegue";
int charLimit = 240;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTextView];
    [self setupDatePicker];
    [self setupCharCounter];
    
    if (self.task == nil){
        self.deleteTaskButton.hidden = YES;
    } else {
        self.navigationItem.title = @"Edit Task";
    }
    [self setupNavBar];
    self.posting = NO; 
}

- (void) setupCharCounter{
    int charsRemaining = charLimit - (int)self.taskDescTextView.text.length;
    self.charRemainingCount.text = [NSString stringWithFormat: @"%d", charsRemaining];
}

- (void) setupDatePicker {
    self.taskDeadlineDatePicker.minimumDate = [NSDate date];
}

- (void) setupNavBar {
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName:[UIFont fontWithName:@"OpenSans-SemiBold" size:18]}];
}

- (void)setupTextView {
    if (self.task == nil) {
        self.taskDescTextView.delegate = self;
        self.taskTitleTextField.delegate = self;
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
    if (self.posting) {
        return;
    }
    
    self.posting = YES;
    if ([AlertManager isInvalidTextField:@[self.taskTitleTextField.text]] == YES){
        [AlertManager presentInvalidTaskAlert:self];
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
                    [AlertManager presentGenericErrorAlert:self withFailedAction:@"Saving task" andMessageToTry:@"try to save task again."];
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
    self.posting = NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString *newText = [self.taskDescTextView.text stringByReplacingCharactersInRange:range withString:text];
    
    int charsRemaining = charLimit - (int)newText.length;
    self.charRemainingCount.text = [NSString stringWithFormat: @"%d", charsRemaining];
    
    return newText.length < charLimit;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)didTapCreateTaskView:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)tapDelete:(id)sender {
    [AlertManager presentDeleteTaskComfirmationAlert:self forTask:self.task withConfirmCompletion:^(bool confirmed) {
        if (confirmed) {
            [BorbParseManager deleteTask:self.task];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];

}

//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}

@end
