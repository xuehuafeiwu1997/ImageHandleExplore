//
//  FourthViewController.m
//  图片的处理探究
//
//  Created by 许明洋 on 2020/11/10.
//

#import "FourthViewController.h"
#import <SDWebImage/SDWebImage.h>
#import "FLAnimatedImage.h"

@interface FourthViewController ()

@property (nonatomic, strong) FLAnimatedImageView *animatedImageView;
//@property (nonatomic, strong) FLAnimatedImage *animatedImage;

@end

@implementation FourthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"FLAnimatedImageView加载动态图";
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.animatedImageView.center = self.view.center;
    [self.view addSubview:self.animatedImageView];
}

- (FLAnimatedImageView *)animatedImageView {
    if (_animatedImageView) {
        return _animatedImageView;
    }
    _animatedImageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    //加载网络动态图的写法
//    [_animatedImageView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1605000729372&di=c45883a78737a80195eb87095a9edf06&imgtype=0&src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2F6ddcca1745377c1355e23c56a91a8543509de15524d605-lBLXNz_fw658"]];
    //加载本地图片的写法
    FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"少司命" ofType:@"gif"]]];
    _animatedImageView.animatedImage = animatedImage;
    __weak typeof(self) weakSelf = self;
    _animatedImageView.loopCompletionBlock = ^(NSUInteger loopCountRemaining) {
        NSLog(@"gif图片循环结束");
        [weakSelf.animatedImageView removeFromSuperview];
    };
    return _animatedImageView;
}

@end
