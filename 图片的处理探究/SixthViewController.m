//
//  SixthViewController.m
//  图片的处理探究
//
//  Created by 许明洋 on 2020/11/11.
//

#import "SixthViewController.h"
#import "Masonry.h"

@interface SixthViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *savePhotoButton;

@end

@implementation SixthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"图片的压缩处理，包括图片的质量和图片的大小压缩";
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imageView.center = self.view.center;
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.savePhotoButton];
    [self.savePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.imageView.mas_bottom).offset(20);
        make.width.greaterThanOrEqualTo(@0);
        make.height.greaterThanOrEqualTo(@0);
    }];
}

//压缩图片到指定尺寸，将照片保存到手机上，查看后发现，压缩后的照片尺寸以及大小都变小了
- (UIImage *)compressImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    return newImage;
}

//将图片压缩成我们需要的数据包大小
- (UIImage *)compressImage:(UIImage *)image toMaxDataSizeBytes:(CGFloat)maxLength {
    //首先，判断原图是否在要求范围内，如果满足要求则不进行压缩
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) {
        return image;
    }
    //原图大小超过范围，先进行“压”处理，如果压处理达不到目标，再进行缩处理，这里压缩比采用二分法进行处理，6次二分法之后的最小压缩比是0.015625,已经够小了
    //将图片压缩成我们需要的数据包大小
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    //判断压处理是否符合要求
    if (data.length < maxLength) {
        return resultImage;
    }
    //如果没能达到要求，通常我们会该基础上进行缩处理
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        //获取处理后的尺寸
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake(ceilf(resultImage.size.width * ratio), ceilf(resultImage.size.height * ratio));
        //通过图形上下文处理对象
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //获取处理后图片的大小
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    return resultImage;
}

- (void)savePhotoButtonClicked {
    NSLog(@"点击按钮保存图片");
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        NSLog(@"成功保存图片到相册");
    } else {
        NSLog(@"保存图片出错,错误为%@",error);
    }
}

- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    UIImage *image = [UIImage imageNamed:@"月儿.jpg"];
    _imageView.image = [self compressImage:image toMaxDataSizeBytes:300000];
//    _imageView.image = [self compressImage:image scaledToSize:CGSizeMake(150, 100)];//将图片压缩到指定的大小
//    _imageView.image = image;
    return _imageView;
}

- (UIButton *)savePhotoButton {
    if (_savePhotoButton) {
        return _savePhotoButton;
    }
    _savePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [_savePhotoButton setTitle:@"保存照片" forState:UIControlStateNormal];
    [_savePhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_savePhotoButton addTarget:self action:@selector(savePhotoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    return _savePhotoButton;
}

@end
