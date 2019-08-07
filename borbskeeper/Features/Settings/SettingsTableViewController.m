//
//  SettingsTableViewController.m
//  borbskeeper
//
//  Created by cassanene on 7/26/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "BorbParseManager.h"

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
    self.pickerData = @[@"5 minutes before", @"15 minutes before", @"30 minutes before", @"1 hour before"];
    [self.minutePickerView setShowsSelectionIndicator:YES];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
}

- (void)setupNavBar {
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName:[UIFont fontWithName:@"OpenSans-SemiBold" size:18]}];
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
    return 3;
}
@end







