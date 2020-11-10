//
//  FirstViewController.m
//  图片的处理探究
//
//  Created by 许明洋 on 2020/11/9.
//

#import "FirstViewController.h"
#import <SDWebImage/SDWebImage.h>

@interface FirstViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"实现图片的网络请求";
    
    self.imageView.center = self.view.center;
    [self.view addSubview:self.imageView];
    
    NSURL *url = [NSURL URLWithString:@"https://up.enterdesk.com/edpic_source/43/e1/c0/43e1c0e421c17efa4734be7080052134.jpg"];
    [self.imageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            NSLog(@"图片下载成功,图片的大小为:%f,%f",image.size.width,image.size.height);
        }
        if (error) {
            NSLog(@"图片下载失败，原因为:%@",error);
        }
        //第一次运行加载时，肉眼可见需要一定的网络请求时间，cacheType为0,表示图像无法从缓存中获取，但是可以从网络上下载,之后再次运行代码，图像的加载速度明显快了很多，cacheType的值为1，表示从磁盘中获取到的图片的缓存
        NSLog(@"图片缓存的类型为:%ld",(long)cacheType);
        NSLog(@"图片的url为%@",imageURL);
        //图片的大小依旧是原本图片的大小，只不过原本图片的大小被裁减了
        NSLog(@"当前imageView的图片的大小为:%f,%f",self.imageView.image.size.width,self.imageView.image.size.height);
    }];
}

- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.masksToBounds = YES;
    return _imageView;
}

@end
