//
//  FifthViewController.m
//  图片的处理探究
//
//  Created by 许明洋 on 2020/11/10.
//

#import "FifthViewController.h"

@interface FifthViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation FifthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"截取view生成一张图片";
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imageView.center = self.view.center;
    [self.view addSubview:self.imageView];
}

- (UIImage *)shotWithView {
    //使用UIGraphicsImageRender生成图片
    UIGraphicsImageRenderer *render = [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(300, 200)];
    UIImage *image = [render imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        [[UIColor darkGrayColor] setStroke];
        [rendererContext strokeRect:render.format.bounds];
        [[UIColor blueColor] setFill];
        [rendererContext fillRect:CGRectMake(0, 0, 300, 200)];
    }];
    return image;
}

- (UIImage *)shotWithViewNew {
    //开启图形上下文
    CGRect rect = CGRectMake(0, 0, 200, 100);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //需要这样填充颜色
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//将self.view生成一张image图片
- (UIImage *)shotNewView {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(300, 200), YES, 1.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    self.view.backgroundColor = [UIColor whiteColor];
    return [UIImage imageWithData:imageData];
}

- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    _imageView.contentMode = UIViewContentModeCenter;
    _imageView.backgroundColor = [UIColor yellowColor];
    _imageView.image = [self shotWithViewNew];
    return _imageView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"当前imageView的图片为:%@",self.imageView.image);
}

@end
