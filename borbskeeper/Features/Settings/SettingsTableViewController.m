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

@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property (weak, nonatomic) IBOutlet UIPickerView *minutePickerView;
@property (strong, nonatomic) NSArray *pickerData;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.minutePickerView.dataSource = self;
    self.minutePickerView.delegate = self;
    [self setupNavBar];
    self.pickerData = @[@"Remind me 5 mins before", @"Remind me 10 mins before", @"Remind me 15 mins before", @"Remind me 20 mins before", @"Remind me 30 mins before"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setupNavBar {
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName:[UIFont fontWithName:@"OpenSans-SemiBold" size:18]}];
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
    return 2;
}
- (IBAction)switchButtonTapped:(id)sender {
    self.minutePickerView.hidden = !self.minutePickerView.hidden;;
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
@end







