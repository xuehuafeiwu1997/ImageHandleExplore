//
//  SeventhViewController.m
//  图片的处理探究
//
//  Created by 许明洋 on 2020/11/11.
//

#import "SeventhViewController.h"
#import "GPUImage.h"
#import "Masonry.h"
#import <Photos/Photos.h>

@interface SeventhViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIButton *videoFilterButton;
@property (nonatomic, strong) UIButton *stopVideoFilterButton;
@property (nonatomic, strong) UIButton *movieWriteButton;

@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageSepiaFilter *customFilter;
@property (nonatomic, strong) NSURL *path;

@end

@implementation SeventhViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"实现滤镜效果";
    self.navigationController.navigationBar.translucent = NO;
    
    self.imageView.center = self.view.center;
    [self.view addSubview:self.imageView];
    
    [self.view addSubview:self.cameraButton];
    [self.cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.imageView.mas_bottom).offset(20);
        make.width.greaterThanOrEqualTo(@0);
        make.height.greaterThanOrEqualTo(@0);
    }];
    
    [self.view addSubview:self.videoFilterButton];
    [self.videoFilterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.cameraButton.mas_bottom).offset(20);
        make.width.greaterThanOrEqualTo(@0);
        make.height.greaterThanOrEqualTo(@0);
    }];
    
    [self.view addSubview:self.movieWriteButton];
    [self.movieWriteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.videoFilterButton.mas_bottom).offset(20);
        make.width.greaterThanOrEqualTo(@0);
        make.height.greaterThanOrEqualTo(@0);
    }];
//    [self simpleFilterImage];
}

//使图片变灰
- (void)simpleFilterImage {
    UIImage *inputImage = [UIImage imageNamed:@"月儿.jpg"];
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
    GPUImageSepiaFilter *stillImageFilter = [[GPUImageSepiaFilter alloc] init];
    [stillImageSource addTarget:stillImageFilter];
    [stillImageFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    UIImage *currentFilteredVideoFrame = [stillImageFilter imageFromCurrentFramebuffer];
    self.imageView.image = currentFilteredVideoFrame;
    //和上面的效果一样，都是使图片变成灰色
//    UIImage *inputImage = [UIImage imageNamed:@"月儿.jpg"];
//    GPUImageSepiaFilter *stillImageFilter2 = [[GPUImageSepiaFilter alloc] init];
//    UIImage *quickFilteredImage = [stillImageFilter2 imageByFilteringImage:inputImage];
//    self.imageView.image = quickFilteredImage;
}

//这个方法会捕捉摄像头对应的地方，然后生成一张图片，但是没有调用摄像头照相的时候，直接就是捕捉图片
- (void)captureAndFilterStillPhoto {
    GPUImageStillCamera *stillCamera = [[GPUImageStillCamera alloc] init];
    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    GPUImageGammaFilter *filter = [[GPUImageGammaFilter alloc] init];
    [stillCamera addTarget:filter];
    GPUImageView *filterView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    filterView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:filterView];
    [filter addTarget:filterView];
    
    [stillCamera startCameraCapture];
    [stillCamera capturePhotoAsImageProcessedUpToFilter:filter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        filterView.largeContentImage = processedImage;
        NSLog(@"执行了这个方法");
        if (error) {
            NSLog(@"出现错误，错误的原因为%@",error);
            return;
        }
        NSData *dataForJPEGFile = UIImageJPEGRepresentation(processedImage, 0.8);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        if (![dataForJPEGFile writeToFile:[documentsDirectory stringByAppendingPathComponent:@"filteredPhoto1.jpg"] atomically:YES]) {
            NSLog(@"写入文件失败");
        }
    }];
}

- (void)captureAndFilterLiveVideo {
    //这个方法有问题，无法调出摄像头观察到相应的效果，目前经过修改，可以得到相应的视频录制，并且可以看到过程，但是视频录制后得到的视频无法播放，总是说视频格式载入错误
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    //防止允许声音通过的经过的情况下，避免录制第一帧黑屏
    [self.videoCamera addAudioInputsAndOutputs];
    
    
//    GPUImageFilter *customFilter = [[GPUImageFilter alloc] initWithFragmentShaderFromFile:@"CustomShader"];
    self.customFilter = [[GPUImageSepiaFilter alloc] init];
    GPUImageView *filteredVideoView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    //显示模式充满了整个边框
    filteredVideoView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self.view addSubview:filteredVideoView];
    [self.videoCamera addTarget:self.customFilter];
    [self.customFilter addTarget:filteredVideoView];
    
    NSString *pp = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Movie.mp4"];
    //如果文件已经存在，AVASSetWriter不会再录制新的帧，所以删除旧的
    unlink([pp UTF8String]);
    NSURL *willSaveUrl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"Movie.mp4"]];
    
    self.path = willSaveUrl;
    GPUImageMovieWriter *movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:willSaveUrl size:CGSizeMake(480, 640)];
    movieWriter.encodingLiveVideo = YES;
    movieWriter.shouldPassthroughAudio = YES;
    movieWriter.hasAudioTrack = YES;

    [self.videoCamera startCameraCapture];
    
    double delayToStartRecording = 6;
    dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, delayToStartRecording * NSEC_PER_SEC);
    dispatch_after(startTime, dispatch_get_main_queue(), ^{
        NSLog(@"start recording");
        self.videoCamera.audioEncodingTarget = movieWriter;
        [movieWriter startRecording];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 60 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSLog(@"一分钟后停止录屏");
        [self.customFilter removeTarget:movieWriter];
        self.videoCamera.audioEncodingTarget = nil;
        [movieWriter finishRecording];
        [self.videoCamera stopCameraCapture];
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:willSaveUrl];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                NSLog(@"success = %d, error = %@",success,error);
            }];
    });
    NSLog(@"执行了实时捕捉视频这个方法");
    
}

- (void)stopVideoFilterRecording {
    NSLog(@"结束录制");
   
}

- (void)filteringAndRecodingMovie {
    NSLog(@"开始执行电影滤镜的方法");
//    NSString *string = [NSString stringWithFormat:@"https://youku.cdn4-okzy.com/20200618/8130_4b8b9a06/1000k/hls/index.m3u8"];
    self.path = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"Movie.m4v"]];
    GPUImageMovie *movieFile = [[GPUImageMovie alloc] initWithURL:self.path];
    GPUImagePixellateFilter *pixellateFilter = [[GPUImagePixellateFilter alloc] init];
    [movieFile addTarget:pixellateFilter];
    
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([pathToMovie UTF8String]);
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    GPUImageMovieWriter *movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480.0, 640.0)];
    [pixellateFilter addTarget:movieWriter];
    
    movieWriter.shouldPassthroughAudio = YES;
    movieFile.audioEncodingTarget = movieWriter;
    [movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];
    
    [movieWriter startRecording];
    [movieFile startProcessing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 30 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSLog(@"30秒之后停止");
        [pixellateFilter removeTarget:movieWriter];
        [movieWriter finishRecording];
    });
    
}

- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    _imageView.image = [UIImage imageNamed:@"月儿.jpg"];
    return _imageView;
}

- (UIButton *)cameraButton {
    if (_cameraButton) {
        return _cameraButton;
    }
    _cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [_cameraButton setTitle:@"开启捕捉图片" forState:UIControlStateNormal];
    [_cameraButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cameraButton addTarget:self action:@selector(captureAndFilterStillPhoto) forControlEvents:UIControlEventTouchUpInside];
    return _cameraButton;
}

- (UIButton *)videoFilterButton {
    if (_videoFilterButton) {
        return _videoFilterButton;
    }
    _videoFilterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [_videoFilterButton setTitle:@"开启捕捉视频流" forState:UIControlStateNormal];
    [_videoFilterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_videoFilterButton addTarget:self action:@selector(captureAndFilterLiveVideo) forControlEvents:UIControlEventTouchUpInside];
    return _videoFilterButton;
}

- (UIButton *)stopVideoFilterButton {
    if (_stopVideoFilterButton) {
        return _stopVideoFilterButton;
    }
    _stopVideoFilterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [_stopVideoFilterButton setTitle:@"停止录制视频" forState:UIControlStateNormal];
    [_stopVideoFilterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_stopVideoFilterButton addTarget:self action:@selector(stopVideoFilterRecording) forControlEvents:UIControlEventTouchUpInside];
    return _stopVideoFilterButton;
}

- (UIButton *)movieWriteButton {
    if (_movieWriteButton) {
        return _movieWriteButton;
    }
    _movieWriteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [_movieWriteButton setTitle:@"开启电影滤镜" forState:UIControlStateNormal];
    [_movieWriteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_movieWriteButton addTarget:self action:@selector(filteringAndRecodingMovie) forControlEvents:UIControlEventTouchUpInside];
    return _movieWriteButton;
}

@end
