//
//  ProfileViewController.m
//  borbskeeper
//
//  Created by rodrigoandrade on 7/25/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "BorbParseManager.h"


@interface ProfileViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) NSMutableArray *completeTaskList;
@property (strong, nonatomic) UIImage *originalImage;
@property (strong, nonatomic) UIImage *editedImage;


@end

@implementation ProfileViewController
static NSString *const USER_PROF_PIC_KEY = @"profilePicture";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupProfile];
}

- (void)setupProfile{
    NSString *userName = User.currentUser.username;
    self.userName.text = userName;
    [self loadUserProfilePicture];
}

-(void)loadUserProfilePicture{
    PFFileObject *PFObjectProfileImage = [User currentUser][USER_PROF_PIC_KEY];
    NSURL *profileImageURL = [NSURL URLWithString:PFObjectProfileImage.url];
    self.profilePicture.image = nil;
    [self.profilePicture setImageWithURL:profileImageURL];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.originalImage = info[UIImagePickerControllerOriginalImage];
    self.editedImage = [self resizeImage:self.originalImage withSize:CGSizeMake(1000, 1000)];
    [self.profilePicture setImage:self.editedImage];
    
    [User currentUser][USER_PROF_PIC_KEY] = [BorbParseManager getPFFileFromImage:self.editedImage];
    
    [BorbParseManager saveUser:[User currentUser] withCompletion:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapChangeProfilePicture:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
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
