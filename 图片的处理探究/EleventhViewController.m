//
//  EleventhViewController.m
//  图片的处理探究
//
//  Created by 许明洋 on 2020/11/20.
//

#import "EleventhViewController.h"
#import "Masonry.h"

@interface EleventhViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *customFilterButton;
@property (nonatomic, strong) UIButton *replaceBgColorButton;
@property (nonatomic, strong) CIImage *originalCIImage;

@end

@implementation EleventhViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"coreImage实现滤镜";
    
    self.imageView.center = self.view.center;
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.customFilterButton];
    [self.customFilterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.imageView.mas_bottom).offset(20);
        make.width.greaterThanOrEqualTo(@0);
        make.height.greaterThanOrEqualTo(@0);
    }];
    
}

- (void)startCustonFilter {
    CIContext *context = [CIContext context];
    NSURL *imageURL = [[NSBundle mainBundle] URLForResource:@"月儿" withExtension:@"jpg"];
    CIImage *originalCIImage = [CIImage imageWithContentsOfURL:imageURL];
//    self.imageView.image = [UIImage imageWithCIImage:originalCIImage];
    NSLog(@"点击开启自定义滤镜");
    CIImage *sepiaImage = [self sepiaFilterImage:originalCIImage withIntensity:0.9];
    self.imageView.image = [UIImage imageWithCIImage:sepiaImage];

    CIImage *bloomImage = [self bloomFilterImage:sepiaImage withIntensity:1 radius:10];
    self.imageView.image = [UIImage imageWithCIImage:bloomImage];
    
    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    CGFloat aspectRatio = imageHeight / imageWidth;
    
    CIImage *scaledImage = [self scaleFilterImage:bloomImage withAspectRatio:aspectRatio scale:0.05];
    self.imageView.image = [UIImage imageWithCIImage:scaledImage];
}

- (CIImage *)sepiaFilterImage:(CIImage *)inputImage withIntensity:(CGFloat)intensity {
    CIFilter *sepiaFilterImage = [CIFilter filterWithName:@"CISepiaTone"];
    [sepiaFilterImage setValue:inputImage forKey:kCIInputImageKey];
    [sepiaFilterImage setValue:@(intensity) forKey:kCIInputIntensityKey];
    return sepiaFilterImage.outputImage;
}

- (CIImage *)bloomFilterImage:(CIImage *)inputImage withIntensity:(CGFloat)intensity radius:(CGFloat)radius {
    CIFilter *bloomFilter = [CIFilter filterWithName:@"CIBloom"];
    [bloomFilter setValue:inputImage forKey:kCIInputImageKey];
    [bloomFilter setValue:@(intensity) forKey:kCIInputIntensityKey];
    [bloomFilter setValue:@(radius) forKey:kCIInputRadiusKey];
    return bloomFilter.outputImage;
}

- (CIImage *)scaleFilterImage:(CIImage *)inputImage withAspectRatio:(CGFloat)aspectRatio scale:(CGFloat)scale {
    CIFilter *scaleFilter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
    [scaleFilter setValue:inputImage forKey:kCIInputImageKey];
    [scaleFilter setValue:@(scale) forKey:kCIInputScaleKey];
    [scaleFilter setValue:@(aspectRatio) forKey:kCIInputAspectRatioKey];
    return scaleFilter.outputImage;
}

- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    _imageView.image = [UIImage imageNamed:@"月儿.jpg"];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    return _imageView;
}

- (UIButton *)customFilterButton {
    if (_customFilterButton) {
        return _customFilterButton;
    }
    _customFilterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [_customFilterButton setTitle:@"开启滤镜" forState:UIControlStateNormal];
    [_customFilterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_customFilterButton addTarget:self action:@selector(startCustonFilter) forControlEvents:UIControlEventTouchUpInside];
    return _customFilterButton;
}

- (UIButton *)replaceBgColorButton {
    if (_replaceBgColorButton) {
        return _replaceBgColorButton;
    }
    _replaceBgColorButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [_replaceBgColorButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_replaceBgColorButton setTitle:@"开启替换背景颜色" forState:UIControlStateNormal];
    return _replaceBgColorButton;
}

@end
