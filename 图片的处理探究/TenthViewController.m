//
//  TenthViewController.m
//  图片的处理探究
//
//  Created by 许明洋 on 2020/11/19.
//

#import "TenthViewController.h"
#import "Masonry.h"
#import <Photos/Photos.h>

@interface TenthViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic) BOOL isPreviewing;//表示是否正在查看图片
@property (nonatomic, strong) UIImage *willSaveImage;

@end

@implementation TenthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"点击图片放大全屏";
    
    self.imageView.center = self.view.center;
    [self.view addSubview:self.imageView];
    
    self.isPreviewing = NO;//初始值设置为NO
}

- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    _imageView.image = [UIImage imageNamed:@"天明.jpg"];
//    _imageView.contentMode = UIViewContentModeScaleToFill;//系统默认的模式
    _imageView.contentMode = UIViewContentModeScaleAspectFit;//这样会显示全部，好像是将其按照等比例缩放的
//    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.masksToBounds = YES;
    
    
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClicked)];
    [_imageView addGestureRecognizer:tap];
    return _imageView;
}

- (UIView *)backgroundView {
    if (_backgroundView) {
        return _backgroundView;
    }
//    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    _backgroundView.backgroundColor = [UIColor blackColor];
    return _backgroundView;
}

- (void)imageViewClicked {
    NSLog(@"图片被点击，即将放大");
    self.isPreviewing = YES;
    self.navigationController.navigationBarHidden = self.isPreviewing;
    //添加一个黑色背景
    [self.view addSubview:self.backgroundView];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.imageView.image];
    self.willSaveImage = self.imageView.image;
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePreView)];
    [imageView addGestureRecognizer:tap];
    [self.backgroundView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backgroundView);
        make.centerY.equalTo(self.backgroundView);
        make.left.equalTo(self.backgroundView).offset(50);
        make.top.equalTo(self.backgroundView).offset(100);
    }];
    
    UIButton *savePhotonButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [savePhotonButton setTitle:@"保存照片" forState:UIControlStateNormal];
    [savePhotonButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [savePhotonButton addTarget:self action:@selector(savePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:savePhotonButton];
    [savePhotonButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backgroundView.mas_right).offset(-20);
        make.bottom.equalTo(self.backgroundView.mas_bottom).offset(-20);
        make.width.greaterThanOrEqualTo(@0);
        make.height.greaterThanOrEqualTo(@0);
    }];
    [self shakeToShow:self.backgroundView];
}

//将照片存储到相册中
- (void)savePhoto {
    NSLog(@"将照片存储到相册中");
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromImage:self.willSaveImage];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            NSLog(@"图片保存到系统相册success = %d,error = %@",success,error);
        }];
}

//放大过程中出现的缓慢动画
- (void)shakeToShow:(UIView *)bgView {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [bgView.layer addAnimation:animation forKey:nil];
}

- (void)closePreView {
    NSLog(@"关闭预览");
    self.isPreviewing = NO;
    self.navigationController.navigationBarHidden = self.isPreviewing;
    [self.backgroundView removeFromSuperview];
    //必须得加这句话，不然的话每次点击预览都会在backGroundView上添加一个imageView图像，没有移除，导致会一直添加,正常情况下只消耗24.6M，这样一直点下去内存会一直增加的，还有另外一种处理方法，不使用懒加载来实现backGroundView，在每次点击图像后，创建backGroundView，这样的话也不会导致现在的问题
    self.backgroundView = nil;
}

- (BOOL)prefersStatusBarHidden {
    return self.isPreviewing;
}

@end
