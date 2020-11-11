//
//  SecondViewController.m
//  图片的处理探究
//
//  Created by 许明洋 on 2020/11/9.
//

#import "SecondViewController.h"
#import <SDWebImage/SDWebImage.h>

@interface SecondViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"图片的压缩处理";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imageView.center = self.view.center;
    [self.view addSubview:self.imageView];
//    NSURL *url = [NSURL URLWithString:@"https://up.enterdesk.com/edpic_source/43/e1/c0/43e1c0e421c17efa4734be7080052134.jpg"];
    NSURL *url = [NSURL URLWithString:@"http://www.onegreen.net/maps/Upload_maps/201412/2014120107280906.jpg"];
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
//    [downloader downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//        NSLog(@"当前接收的图片的大小为:%ld",(long)receivedSize);
//        NSLog(@"当前接收的图片的期望大小为:%ld",(long)expectedSize);
//        NSLog(@"当前的url为：%@",targetURL);
//    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
//        NSLog(@"下载完成");
////        self.imageView.image = image;
//        NSLog(@"图片内存的大小为:%f",image.size.width * image.size.height * image.scale);
//        NSLog(@"image的scale的值为：%f",image.scale);
////        [self beginCompressedImage:image];
//        [self screenshotsImage:image];
//    }];
    [self screenshotsImage:nil];
}

//截取图片
- (void)screenshotsImage:(UIImage *)image {
    //转化为位图
    UIImage *testImage = [UIImage imageNamed:@"月儿.jpg"];
    CGImageRef tmpImg = testImage.CGImage;
    //根据范围进行截图
    tmpImg = CGImageCreateWithImageInRect(tmpImg, CGRectMake(0, 0, 1920, 1080));
    //得到新的图片
    UIImage *newImage = [UIImage imageWithCGImage:tmpImg];
    self.imageView.image = newImage;
    CGImageRelease(tmpImg);
}

- (void)beginCompressedImage:(UIImage *)image {
    NSLog(@"当前图片的宽为%f",image.size.width);
    NSLog(@"当前图片的高为%f",image.size.height);
    NSLog(@"当前图片的内存大小为:%f",image.size.width * image.size.height * image.scale);
    NSLog(@"开始压缩图片");
    CGRect rect = CGRectMake(0, 0, 100, 50);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef temImg = image.CGImage;
    CGContextDrawImage(context, rect, temImg);
    UIGraphicsEndImageContext();
    self.imageView.image = [UIImage imageWithCGImage:temImg];
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
