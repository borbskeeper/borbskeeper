//
//  ComposeTaskViewController.m
//  borbskeeper
//
//  Created by rodrigoandrade on 7/18/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "ComposeTaskViewController.h"
#import "UITextView+Placeholder.h"
#import "Task.h"

@interface ComposeTaskViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *taskTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *taskDescTextView;
@property (weak, nonatomic) IBOutlet UIDatePicker *taskDeadlineDatePicker;

@end

@implementation ComposeTaskViewController

static NSString *const TASK_DESCRIPTION_PLACEHOLDER = @"What are the details of your task?";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTextView];
}

- (void)setupTextView {
    self.taskDescTextView.delegate = self;
    self.taskDescTextView.placeholder = TASK_DESCRIPTION_PLACEHOLDER;
    self.taskDescTextView.placeholderColor = [UIColor lightGrayColor];
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapSaveTask:(id)sender {
    Task *newTask = [Task createTask:self.taskTitleTextField.text withDescription:self.taskDescTextView.text withDueDate:self.taskDeadlineDatePicker.date];
    [BorbParseManager saveTask:newTask withCompletion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
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
