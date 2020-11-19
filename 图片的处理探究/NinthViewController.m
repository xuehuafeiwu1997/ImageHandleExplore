//
//  NinthViewController.m
//  图片的处理探究
//
//  Created by 许明洋 on 2020/11/19.
//
//参考链接：https://github.com/BradLarson/GPUImage/issues/112
#import "NinthViewController.h"
#import "Masonry.h"
#import "GPUImage.h"

@interface NinthViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *filterGroupButton;

@end

@implementation NinthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"滤镜的组合使用";
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(12);
        make.left.equalTo(self.view).offset(12);
        make.height.equalTo(@200);
    }];
    
    [self.view addSubview:self.filterGroupButton];
    [self.filterGroupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.imageView.mas_bottom).offset(12);
        make.width.greaterThanOrEqualTo(@0);
        make.height.greaterThanOrEqualTo(@0);
    }];
}

- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    _imageView.image = [UIImage imageNamed:@"月儿.jpg"];
    return _imageView;
}

- (UIButton *)filterGroupButton {
    if (_filterGroupButton) {
        return _filterGroupButton;
    }
    _filterGroupButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [_filterGroupButton setTitle:@"滤镜组合" forState:UIControlStateNormal];
    [_filterGroupButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_filterGroupButton addTarget:self action:@selector(startFilterGroup) forControlEvents:UIControlEventTouchUpInside];
    return _filterGroupButton;
}

- (void)startFilterGroup {
    NSLog(@"开启滤镜组合");
    
    GPUImageFilterGroup *filterGroup = [[GPUImageFilterGroup alloc] init];
    
    GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
    [contrastFilter setContrast:3.5];//0 - 4
    [(GPUImageFilterGroup *)filterGroup addFilter:contrastFilter];
    
    GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
    [saturationFilter setSaturation:0.0];//0 - 2
    [(GPUImageFilterGroup *)filterGroup addFilter:saturationFilter];
    
    GPUImageSharpenFilter *sharpenFilter = [[GPUImageSharpenFilter alloc] init];
    [sharpenFilter setSharpness:0.0];//-4 - 4
    [(GPUImageFilterGroup *)filterGroup addFilter:sharpenFilter];
    
    GPUImageVignetteFilter *vignetteFilter = [[GPUImageVignetteFilter alloc] init];
    [vignetteFilter setVignetteCenter:CGPointMake(0.5, 0.42)];
    [(GPUImageFilterGroup *)filterGroup addFilter:vignetteFilter];
    
    [contrastFilter addTarget:saturationFilter];
    [saturationFilter addTarget:sharpenFilter];
    [sharpenFilter addTarget:vignetteFilter];
    
    [(GPUImageFilterGroup *)filterGroup setInitialFilters:[NSArray arrayWithObject:contrastFilter]];
    [(GPUImageFilterGroup *)filterGroup setTerminalFilter:vignetteFilter];
    
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:self.imageView.image];
    [stillImageSource addTarget:filterGroup];
    [filterGroup useNextFrameForImageCapture];
    [stillImageSource processImage];
    UIImage *currentFrame = [filterGroup imageFromCurrentFramebuffer];
    self.imageView.image = currentFrame;
}

@end
