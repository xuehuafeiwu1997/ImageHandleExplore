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
//    _animatedImage = [SDAnimatedImage imageNamed:@"少司命.gif"];//加载本地图片gif的写法
    //加载网络图片的写法
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1605000729372&di=c45883a78737a80195eb87095a9edf06&imgtype=0&src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2F6ddcca1745377c1355e23c56a91a8543509de15524d605-lBLXNz_fw658"] options:0 error:nil];
    _animatedImage = [[SDAnimatedImage alloc] initWithData:data];
    return _animatedImage;
}

@end
