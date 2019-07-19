//
//  EditTasksViewController.m
//  borbskeeper
//
//  Created by juliapark628 on 7/18/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "EditTasksViewController.h"
#import "Task.h"

@interface EditTasksViewController ()
@property (weak, nonatomic) IBOutlet UITextField *taskTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *taskDescTextView;
@property (weak, nonatomic) IBOutlet UIDatePicker *taskDeadlineDatePicker;

@end

@implementation EditTasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)didTapSave:(id)sender {
//    have to change the already made properties in the task
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];

    NSString *objectId = self.task.objectId;
//    tried this but there is null in the objectId
    [query getObjectInBackgroundWithId:objectId
                                  block:^(PFObject *task, NSError *error) {
                                      task[@"taskName"] = self.taskTitleTextField.text;
                                      task[@"taskDescription"] = self.taskDescTextView.text;
                                      task[@"dueDate"] = self.taskDeadlineDatePicker.date;
                                      [task saveInBackground];
                                  }];
                  
     
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)didTapCancel:(id)sender {
    NSLog(@"Tapped");
    [self.navigationController popViewControllerAnimated:YES];
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
