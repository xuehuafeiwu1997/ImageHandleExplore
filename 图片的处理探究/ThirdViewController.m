//
//  ThirdViewController.m
//  图片的处理探究
//
//  Created by 许明洋 on 2020/11/10.
//

#import "ThirdViewController.h"
#import <SDWebImage/SDWebImage.h>

@interface ThirdViewController ()

@property (nonatomic, strong) SDAnimatedImageView *animatedImageView;
@property (nonatomic, strong) SDAnimatedImage *animatedImage;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"SDWebImage动态图的处理";
    
    self.animatedImageView.center = self.view.center;
    [self.view addSubview:self.animatedImageView];
}

#pragma mark - lazy load
- (SDAnimatedImageView *)animatedImageView {
    if (_animatedImageView) {
        return _animatedImageView;
    }
    _animatedImageView = [[SDAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    _animatedImageView.image = self.animatedImage;
    return _animatedImageView;
}

- (SDAnimatedImage *)animatedImage {
    if (_animatedImage) {
        return _animatedImage;
    }
    _animatedImage = [SDAnimatedImage imageNamed:@"少司命.gif"];
    return _animatedImage;
}

@end
