//
//  BorbTutorialViewController.m
//  borbskeeper
//
//  Created by rodrigoandrade on 8/8/19.
//  Copyright © 2019 juliapark628. All rights reserved.
//

#import "BorbTutorialViewController.h"
#import "FLAnimatedImage.h"
@interface BorbTutorialViewController ()
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIView *borbView;

@end

@implementation BorbTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nextButton.layer.cornerRadius = 5;
    self.nextButton.clipsToBounds = YES;
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i.imgur.com/NJpq7VU.gif"]]];
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.animatedImage = image;
    imageView.frame = self.borbView.frame;
    [self.view addSubview:imageView];
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
