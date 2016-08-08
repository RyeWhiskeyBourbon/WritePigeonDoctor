//
//  XZMicroVideoPlayerView.h
//  Protice
//
//  Created by ZYJY on 16/7/14.
//  Copyright © 2016年 SXZ. All rights reserved.
//
/*
 AVFoundation
 1.Using Assets ［自己理解为：数据的来源］
 这个资源可以来自自己的ipod媒体库或图片也可以时文件
 创建一个Assets
 NSRUL *url = //后跟一个网址 如电影文件等资源
 AVURLAsset *ansset = [[AVURLSset alloc] initwithURL:url  options:nil];
 2.获得一个视频的图像
 使用AVASsetImageGenerator类来实现
 用来生成图像序列
 3.Playback
 我们在播放视频时可以使用AVPlayer和AVQueuePlayer播放,AVPlayer是AVQueuePlayer的父类
 
 a.先创建一个路径
 b.可以使用AVPlayerItem加载路径
 c.使用AVPlayer播放文件
 当然我们还可以控制它的播放速度
 使用rate属性它是一个介于0.0－－1.0之间的数
 
 我们也可以播放多个项目 :
 
 NSArray *items  = // 设置一个播放的组合
 AVQueuePlayer ＊queueplayer ＝ ［［AVQueuePlayer alloc］initwithItems：items］；
 //然后使用AVPlayerItem
 AVPlayerItem ＊anItem ＝ ／／ get  a player item
 //使用canInsertItem：afterItem 测试
 4.Media capture
 我们可以配置预设图片的质量和分辨率
 
 AVCaptureSessionPresetHigh High 最高的录制质量，每台设备不同
 AVCaptureSessionPresetMedium Medium 基于无线分享的，实际值可能会改变
 AVCaptureSessionPresetLow LOW 基于3g分享的
 AVCaptureSessionPreset640x480 640x480 VGA
 AVCaptureSessionPreset1280x720 1280x720 720p HD
 AVCaptureSessionPresetPhoto Photo 完整的照片分辨率，不支持视频输出
 判断一个设备是否适用 ：
 
 AVCaptreSessuion *session = [[AVCaptureSession alloc]init];
 if([session canSetSessionPreset:AVCaptureSessionPrese 1280x720]){
 session.sessionPreset = AVCaptureSessionPreset 1280x720;
 }else{
 // Handle the failure.
 }
 可以在 ［session beginConfigration］, ［session commit configuration］中配置重新添加你想要适用的设备以及删除以前的设备等操作 （详解在6）。
 5.当我们不知道设备的一些特性时我们可以使用以下代码查找相应的设备
 
 NSArray *devices = [AVCaptureDevice devices];
 for(AVCaptureDevice *device in device){
 NSLog("Device name %@",[devic localizedName]);
 //当然还可以判断设备的位置
 if([device hasMediaType:AVMediaTypeVideo]){
 if([device postion] == AVCaptureDevicePostionBack){
 NSLog(@"Device postion :back");
 }else{
 NSLog(@"Device postion :front");
 }
 }
 }
 下面的demo说明如何找到视频输入设备 ：
 
 NSArray ＊devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
 NSMutableArray *torchDevices =  [[NSMutableArray alloc]init];
 for(AVCaptureDevice *device in devices){
 if([device hasTorch]&&[device supportsAVCaptureSessionPreset:AVCaptureSessionPreset 640x480]){
 [torchDevices addObject:device];
 }
 }
 6设备间切换
 
 AVCaptureSession *session = //一个设备session
 [session beginConfiguration];
 
 [session removeInput:frontFacingCameraDeviceInput];
 [session AddInput:backFacikngCameraDeviceInput];
 
 [session commitConfiguration];
 7 配置AVCaptureDeviceInput
 
 AVCaptureSession *captureSession = <#Get a capture session#>;
 AVCaptureDeviceInput *captureDeviceInput = <#Get a capture device input#>;
 // 检查是否适用
 if ([captureSession canAddInput:captureDeviceInput]) {
 // 适用则添加
 [captureSession addInput:captureDeviceInput];
 } else {
 // Handle the failure.
 }
 8 配置AVCaptureOutput
 输出的类型：
 
 a.AVCaptureMovieFileOutput 输出一个电影文件
 b.AVCaptureVideoDataOutput 输出处理视频帧被捕获
 c.AVCaptureAudioDataOutput 输出音频数据被捕获
 d.AVCaptureStillImageOutput 捕获元数据
 AVCaptureSession *captureSession = <#Get a capture session#>;
 AVCaptureMovieFileOutput *movieInput = <#Create and configure a movie output#>;
 if ([captureSession canAddOutput:movieInput]) {
 [captureSession addOutput:movieInput];
 } else {
 // Handle the failure.
 }
 9 保存到一个电影文件
 
 AVCaptureMovieFileOutput *aMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
 CMTime maxDuration = <#Create a CMTime to represent the maximum duration#>;
 
 aMovieFileOutput.maxRecordedDuration = maxDuration;
 
 aMovieFileOutput.minFreeDiskSpaceLimit = <#An appropriate minimum given the quality of the movie format and the duration#>;
 10 录音设备
 使用AVCaptureFileOutputRecordingDelegate代理而且必须实现方法：
 captureOutput:didFinishRecordingToOutputFileAtURL:fromConnections:error: method.
 11 像素和编码格式
 
 iphone 3G iphone 3GS iphone 4
 yuvs,2vuy,BGRA,jpeg 420f,420v,BGRA,jpeg 420f, 420v, BGRA, jpeg
 12 静态图像捕捉
 
 AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
 NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
 [stillImageOutput setOutputSettings:outputSettings];
 13 填充模式
 支持使用videoGravity 设置三种模式：
 
 ● AVLayerVideoGravityResizeAspect:保留长宽比，未填充部分会有黑边
 ● AVLayerVideoGravityResizeAspectFill:保留长宽比，填充所有的区域
 ● AVLayerVideoGravityResize:拉伸填满所有的空间
 设备之间切换:
 
 - (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
 {
 NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
 for ( AVCaptureDevice *device in devices ) {
 if ( device.position == position ) return device;
 return nil;
 }
 
 - (void)swapFrontAndBackCameras {
 // 确保session已经在使用了
 NSArray *inputs = self.session.inputs;
 for ( AVCaptureDeviceInput *input in inputs ) {
 AVCaptureDevice *device = input.device;
 if ( [device hasMediaType:AVMediaTypeVideo] ) {
 AVCaptureDevicePosition position = device.position;
 AVCaptureDevice *newCamera = nil;
 AVCaptureDeviceInput *newInput = nil;
 
 if (position == AVCaptureDevicePositionFront) {newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack]; }
 else {newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront]; }
 newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
 
 // beginConfiguration 确保更改未被立即使用
 [self.session beginConfiguration];
 
 [self.session removeInput:input];
 [self.session addInput:newInput];
 
 // 更改立即实现
 [self.session commitConfiguration];
 break;
 }
 }
 }
 AVFoundation的使用
 初步了解了AVFoundation框架，那么我们一般用来做什么呢？
 一个方向是可以用它来扫描二维码。参考文档：使用系统原生代码处理QRCode，想要看懂参考中的代码，不得不了解些AVFoundation的使用啊。
 1.session
 AVFoundation是基于session(会话)概念的。 一个session用于控制数据从input设备到output设备的流向。
 
 声明一个session:
 
 AVCaptureSession *session = [[AVCaptureSession alloc] init];
 session允许定义音频视频录制的质量。
 
 [session setSessionPreset:AVCaptureSessionPresetLow];
 2.capture device
 定义好session后，就该定义session所使用的设备了。（使用AVMediaTypeVideo 来支持视频和图片）
 
 AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
 3.capture device input
 有了capture device, 然后就获取其input capture device， 并将该input device加到session上。
 
 AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&amp;error];
 if ( [session canAddInput:deviceInput] )
 [session addInput:deviceInput];
 4.preview
 在定义output device之前，我们可以先使用preview layer来显示一下camera buffer中的内容。这也将是相机的“取景器”。
 AVCaptureVideoPreviewLayer可以用来快速呈现相机(摄像头)所收集到的原始数据。
 我们使用第一步中定义的session来创建preview layer, 并将其添加到main view layer上。
 
 AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
 [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
 
 CALayer *rootLayer = [[self view] layer];
 [rootLayer setMasksToBounds:YES];
 [previewLayer setFrame:CGRectMake(-70, 0, rootLayer.bounds.size.height, rootLayer.bounds.size.height)];
 [rootLayer insertSublayer:previewLayer atIndex:0];
 5.start Run
 最后需要start the session.
 
 [session startRunning];
 
 */
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface XZMicroVideoPlayerView : UIView
{
    NSURL * _videoURL;
    UIImage *_coverImage;
    
    UIButton        *   _playerBtn;
    
    AVPlayerItem    *   _playItem;
    AVPlayer        *   _player;
    AVPlayerLayer   *   _playerLayer;
    BOOL                _isPlaying;
    
    CGRect              _selfFrame;
}

@property (nonatomic, strong) NSURL   * videoURL;
@property (nonatomic, strong) UIImage * coverImage;
@property (nonatomic, strong) AVPlayerLayer * playerLayer;

@property (nonatomic,retain) UIView * timeView;

- (void)relayoutSubViews;

- (void)setCoverImage;

@end


