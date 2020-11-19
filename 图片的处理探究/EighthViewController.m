//
//  EighthViewController.m
//  图片的处理探究
//
//  Created by 许明洋 on 2020/11/17.
//

#import "EighthViewController.h"
#import "Masonry.h"
#import "GPUImage.h"

@interface EighthViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *inputImage;

@property (nonatomic, strong) UIButton *sepiaFilterButton;//褐色滤镜
@property (nonatomic, strong) UIButton *brightnessFilterButton;//亮度滤镜
@property (nonatomic, strong) UIButton *exposureFilterButton;//曝光滤镜
@property (nonatomic, strong) UIButton *contrastFilterButton;//对比度滤镜
@property (nonatomic, strong) UIButton *saturationFilterButton;//饱和度滤镜
@property (nonatomic, strong) UIButton *gammaFilterButton;//伽马值滤镜

@end

@implementation EighthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"单个照片的各种滤镜效果";
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor orangeColor];
    self.inputImage = [UIImage imageNamed:@"月儿.jpg"];
    
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(12);
        make.left.equalTo(self.view).offset(12);
        make.height.equalTo(@200);
    }];
    
    [self.view addSubview:self.sepiaFilterButton];
    [self.sepiaFilterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.imageView.mas_bottom).offset(12);
        make.width.greaterThanOrEqualTo(@0);
        make.height.greaterThanOrEqualTo(@0);
    }];
    
    [self.view addSubview:self.brightnessFilterButton];
    [self.brightnessFilterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.sepiaFilterButton.mas_bottom).offset(12);
        make.width.greaterThanOrEqualTo(@0);
        make.height.greaterThanOrEqualTo(@0);
    }];
    
    [self.view addSubview:self.exposureFilterButton];
    [self.exposureFilterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.brightnessFilterButton.mas_bottom).offset(12);
        make.width.greaterThanOrEqualTo(@0);
        make.height.greaterThanOrEqualTo(@0);
    }];
    
    [self.view addSubview:self.contrastFilterButton];
    [self.contrastFilterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.exposureFilterButton.mas_bottom).offset(12);
        make.width.greaterThanOrEqualTo(@0);
        make.height.greaterThanOrEqualTo(@0);
    }];
    
    [self.view addSubview:self.saturationFilterButton];
    [self.saturationFilterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.contrastFilterButton.mas_bottom).offset(12);
        make.width.greaterThanOrEqualTo(@0);
        make.height.greaterThanOrEqualTo(@0);
    }];
    
    [self.view addSubview:self.gammaFilterButton];
    [self.gammaFilterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.saturationFilterButton.mas_bottom).offset(12);
        make.width.greaterThanOrEqualTo(@0);
        make.height.greaterThanOrEqualTo(@0);
    }];
}

- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    _imageView.image = self.inputImage;
    return _imageView;
}

- (UIButton *)sepiaFilterButton {
    if (_sepiaFilterButton) {
        return _sepiaFilterButton;
    }
    _sepiaFilterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [_sepiaFilterButton setTitle:@"褐色滤镜" forState:UIControlStateNormal];
    [_sepiaFilterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sepiaFilterButton addTarget:self action:@selector(startSepiaFilter) forControlEvents:UIControlEventTouchUpInside];
    return _sepiaFilterButton;
}

- (UIButton *)brightnessFilterButton {
    if (_brightnessFilterButton) {
        return _brightnessFilterButton;
    }
    _brightnessFilterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [_brightnessFilterButton setTitle:@"亮度滤镜" forState:UIControlStateNormal];
    [_brightnessFilterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_brightnessFilterButton addTarget:self action:@selector(startBrightnessFilter) forControlEvents:UIControlEventTouchUpInside];
    return _brightnessFilterButton;
}

- (UIButton *)exposureFilterButton {
    if (_exposureFilterButton) {
        return _exposureFilterButton;
    }
    _exposureFilterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [_exposureFilterButton setTitle:@"曝光滤镜" forState:UIControlStateNormal];
    [_exposureFilterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_exposureFilterButton addTarget:self action:@selector(startExposureButton) forControlEvents:UIControlEventTouchUpInside];
    return _exposureFilterButton;
}

- (UIButton *)contrastFilterButton {
    if (_contrastFilterButton) {
        return _contrastFilterButton;
    }
    _contrastFilterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [_contrastFilterButton setTitle:@"对比度滤镜" forState:UIControlStateNormal];
    [_contrastFilterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_contrastFilterButton addTarget:self action:@selector(startContrastFilter) forControlEvents:UIControlEventTouchUpInside];
    return _contrastFilterButton;
}

- (UIButton *)saturationFilterButton {
    if (_saturationFilterButton) {
        return _saturationFilterButton;
    }
    _saturationFilterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [_saturationFilterButton setTitle:@"饱和度滤镜" forState:UIControlStateNormal];
    [_saturationFilterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_saturationFilterButton addTarget:self action:@selector(startSaturationFilter) forControlEvents:UIControlEventTouchUpInside];
    return _saturationFilterButton;
}

- (UIButton *)gammaFilterButton {
    if (_gammaFilterButton) {
        return _gammaFilterButton;
    }
    _gammaFilterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [_gammaFilterButton setTitle:@"伽马值滤镜" forState:UIControlStateNormal];
    [_gammaFilterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_gammaFilterButton addTarget:self action:@selector(startGammaFilter) forControlEvents:UIControlEventTouchUpInside];
    return _gammaFilterButton;
}

#pragma mark - 滤镜的相应方法
- (void)startSepiaFilter {
    NSLog(@"开启褐色滤镜");
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:self.inputImage];
    GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init];
    [stillImageSource addTarget:sepiaFilter];
    [sepiaFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    UIImage *currentFrame = [sepiaFilter imageFromCurrentFramebuffer];
    self.imageView.image = currentFrame;
    //这样写，在点击完褐色滤镜按钮后，再点击其他滤镜，会实现相应的滤镜组合，这样写并不方便，在NinthViewController中会有相应的实现
    self.inputImage = currentFrame;
}

- (void)startBrightnessFilter {
    NSLog(@"开启亮度滤镜");
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:self.inputImage];
    GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    brightnessFilter.brightness = 0.5;
    [stillImageSource addTarget:brightnessFilter];
    [brightnessFilter useNextFrameForImageCapture];
    //处理图像
    [stillImageSource processImage];
    //获取处理后的图像
    UIImage *currentFrame = [brightnessFilter imageFromCurrentFramebuffer];
    self.imageView.image = currentFrame;
}

- (void)startExposureButton {
    NSLog(@"开启曝光滤镜");
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:self.inputImage];
    GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
    exposureFilter.exposure = 2.0;
    [stillImageSource addTarget:exposureFilter];
    [exposureFilter useNextFrameForImageCapture];
    //处理图像
    [stillImageSource processImage];
    //获取处理后的图像
    UIImage *currentFrame = [exposureFilter imageFromCurrentFramebuffer];
    self.imageView.image = currentFrame;
}

- (void)startContrastFilter {
    NSLog(@"开启对比度滤镜");
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:self.inputImage];
    GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
    contrastFilter.contrast = 2.0;
    [stillImageSource addTarget:contrastFilter];
    //刚开始这段处理代码写的是stillImageSource,所以会导致下面的imageFromCurrentFramebuffer取不到图片
    [contrastFilter useNextFrameForImageCapture];
    //处理图像
    [stillImageSource processImage];
    //获取处理后的图像
    UIImage *currentFrame = [contrastFilter imageFromCurrentFramebuffer];
    self.imageView.image = currentFrame;
}

- (void)startSaturationFilter {
    NSLog(@"开启饱和度滤镜");
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:self.inputImage];
    GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
    saturationFilter.saturation = 2.0f;
    [stillImageSource addTarget:saturationFilter];
    [saturationFilter useNextFrameForImageCapture];
    //处理图像
    [stillImageSource processImage];
    //获取处理后的图像
    UIImage *currentFrame = [saturationFilter imageFromCurrentFramebuffer];
    self.imageView.image = currentFrame;
}

- (void)startGammaFilter {
    NSLog(@"开启伽马值滤镜");
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:self.inputImage];
    GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
    gammaFilter.gamma = 2.0f;
    [stillImageSource addTarget:gammaFilter];
    [gammaFilter useNextFrameForImageCapture];
    //处理图像
    [stillImageSource processImage];
    //获取处理后的图像
    UIImage *currentFrame = [gammaFilter imageFromCurrentFramebuffer];
    self.imageView.image = currentFrame;
}
@end
