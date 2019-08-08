//
//  SettingsTableViewController.m
//  borbskeeper
//
//  Created by cassanene on 7/26/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "BorbParseManager.h"
#import "PushNotificationsManager.h"
#import "AlertManager.h"

@interface SettingsTableViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *socialSwitchButton;
@property (weak, nonatomic) IBOutlet UIPickerView *minutePickerView;
@property (strong, nonatomic) NSArray *pickerData;
@property (weak, nonatomic) IBOutlet UIButton *changeRemindersButton;
@property (weak, nonatomic) IBOutlet UIButton *selectRemindersButton;
@property (weak, nonatomic) IBOutlet UILabel *currentReminderChoiceLabel;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.minutePickerView.dataSource = self;
    self.minutePickerView.delegate = self;
    self.minutePickerView.hidden = YES;
    self.selectRemindersButton.hidden = YES;
    [self setupNavBar];
    self.pickerData = [PushNotificationsManager allDescriptionsOfRemindBefore];
    [self.minutePickerView setShowsSelectionIndicator:YES];
    self.currentReminderChoiceLabel.text = [PushNotificationsManager descriptionOfRemindBefore:([User currentUser].remindBeforeChoice)];
    [self.socialSwitchButton setOn:[User currentUser].verificationEnabled];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
}

- (void)setupNavBar {
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName:[UIFont fontWithName:@"OpenSans-SemiBold" size:18]}];
}

- (IBAction)socialSwitchChanged:(id)sender {
    if (!self.socialSwitchButton.on) {
        [AlertManager presentDisableVerificationConfirmationAlert:self withCancelCompletion:^(bool clickedCancel) {
            if (clickedCancel) {
                [self.socialSwitchButton setOn:YES animated:YES];
            }
            else {
                [User currentUser].verificationEnabled = NO;
                [BorbParseManager saveUser:[User currentUser] withCompletion:nil];
            }
        }];
    } else {
        [User currentUser].verificationEnabled = YES;
        [BorbParseManager saveUser:[User currentUser] withCompletion:nil];
    }
}

- (IBAction)tapChangeReminders:(id)sender {
    self.minutePickerView.hidden = NO;
    self.selectRemindersButton.hidden = NO;
}

- (IBAction)didTapLogout:(id)sender {
    [BorbParseManager signOutUser];
}

- (IBAction)didTapBack:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapSelectReminders:(id)sender {
    NSInteger selectedRemindBeforeRow = [self.minutePickerView selectedRowInComponent:0];
    if (selectedRemindBeforeRow == 0) {
        [User currentUser].remindBeforeChoice = REMIND_BEFORE_FIVE_MINUTES;
    } else if (selectedRemindBeforeRow == 1) {
        [User currentUser].remindBeforeChoice = REMIND_BEFORE_FIFTEEN_MINUTES;
    } else if (selectedRemindBeforeRow == 2) {
        [User currentUser].remindBeforeChoice = REMIND_BEFORE_THIRTY_MINUTES;
    } else if (selectedRemindBeforeRow == 3) {
        [User currentUser].remindBeforeChoice = REMIND_BEFORE_SIXTY_MINUTES;
    }
    [BorbParseManager saveUser:[User currentUser] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [PushNotificationsManager updateAllNotificationsWithNewRemindBefore];
            self.currentReminderChoiceLabel.text = [PushNotificationsManager descriptionOfRemindBefore:([User currentUser].remindBeforeChoice)];
        }
    }];
    self.minutePickerView.hidden = YES;
    self.selectRemindersButton.hidden = YES;
}


#pragma mark - picker set up

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerData.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerData[row];
}


#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
@end







