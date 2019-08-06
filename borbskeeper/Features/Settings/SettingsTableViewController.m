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

@property (weak, nonatomic) IBOutlet UIPickerView *minutePickerView;
@property (strong, nonatomic) NSArray *pickerData;

@property (weak, nonatomic) IBOutlet UIButton *setRemindersButton;
@property (weak, nonatomic) IBOutlet UISwitch *socialSwitchButton;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.minutePickerView.dataSource = self;
    self.minutePickerView.delegate = self;
    self.minutePickerView.hidden = YES;
    self.pickerData = @[@"Remind me 5 mins before", @"Remind me 10 mins before", @"Remind me 15 mins before", @"Remind me 20 mins before", @"Remind me 30 mins before"];
    [self.minutePickerView setShowsSelectionIndicator:YES];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
}

- (IBAction)didTapLogout:(id)sender {
    [BorbParseManager signOutUser];
}

- (IBAction)didTapBack:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (IBAction)tapSetReminders:(id)sender {
    self.minutePickerView.hidden = NO;
}



- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerData.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerData[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
//    set the user property equal to whatever row the user selects
}
@end







