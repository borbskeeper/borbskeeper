//
//  SettingsViewController.m
//  borbskeeper
//
//  Created by cassanene on 8/5/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "SettingsViewController.h"
#import "BorbParseManager.h"

@interface SettingsViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIPickerView *minutePickerView;
@property  (strong, nonatomic) NSArray *pickerData;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;



@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.reminderLabel.text = self.user.remindTime;
    self.minutePickerView.dataSource = self;
    self.minutePickerView.delegate = self;
    self.minutePickerView.hidden = YES;
    self.pickerData = @[@"Remind me 5 mins before", @"Remind me 10 mins before", @"Remind me 15 mins before", @"Remind me 20 mins before", @"Remind me 30 mins before"];
}

- (IBAction)tapSetReminders:(id)sender {
    self.minutePickerView.hidden = NO;
}


- (IBAction)didTapLogout:(id)sender {
    [BorbParseManager signOutUser];
}

- (IBAction)didTapBack:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)tapSelect:(id)sender {
    self.minutePickerView.hidden = YES;

}


//- (void) checkSwitchState{
//    if ([self.switchButton isOn]){
//        self.reminderLabel.hidden = YES;
//    } else {
//        self.minutePickerView.hidden = !self.minutePickerView.hidden;
//    }

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.pickerData objectAtIndex:row];
}
- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerData.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.user.remindTime = self.pickerData[row];
    self.reminderLabel.text = self.pickerData[row];
    

}


@end
