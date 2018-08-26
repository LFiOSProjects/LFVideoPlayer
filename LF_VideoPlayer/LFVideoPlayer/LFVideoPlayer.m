//
//  LFVideoPlayer.m
//  PTApp
//
//  Created by 王林芳 on 2018/4/17.
//  Copyright © 2018年 王林芳. All rights reserved.
//

#import "LFVideoPlayer.h"
#import <MobileVLCKit/MobileVLCKit.h>
#import "LFVideoToolsView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface LFVideoPlayer()<VLCMediaPlayerDelegate,LFVideoToolsViewDelegate>
{
    CGRect _orignFrame;
    UIView *_fatherView;
}
@property (nonatomic, strong) VLCMediaPlayer *player;
@property (nonatomic, nonnull, strong) LFVideoToolsView *toolsView;
@property (nonatomic, strong) UIView *statusBar;
@end
@implementation LFVideoPlayer

- (instancetype)init{
    if(self = [super init]){
        [self setupNotification];
    }
    return self;
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self setupPlayer];
    [self setupView];
    [self setupControlView];
}
#pragma mark--接口方法
- (void)showInView:(UIView *)view{
    NSCAssert(_mediaURL !=nil, @"LFVLCPlayer Exception:mediaURL could not be nil");
    [view addSubview:self];
//    [view mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.top.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
//    }];
    self.alpha = 0.0;
    [UIView animateWithDuration:LF_VideoControlAnimationTimeInterval animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        if(self.isPlayImmdiately){
            [self play];
        }else{
            self.toolsView.btn_playAndPause.selected = YES;
        }
    }];
}
- (void)dismiss{
    [self.player stop];
    [self.toolsView.timeLabel setText:[NSString stringWithFormat:@"%@/%@",kMediaLength.stringValue,kMediaLength.stringValue]];
    return;
    self.player.delegate = nil;
    self.player.drawable = nil;
    self.player = nil;
    
    // 注销通知
    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [self removeFromSuperview];
}
#pragma mark--私有方法
- (void)setupNotification{
    [[UIDevice currentDevice]beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(orientationHandler)
                                                name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(applicationWillEnterForeground)
                                                name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(applicationWillResignActive)
                                                name:UIApplicationWillResignActiveNotification
                                              object:nil];
}
- (void)setupPlayer{
    [self.player setDrawable:self];
    self.player.media = [VLCMedia mediaWithPath:[[NSBundle mainBundle]pathForResource:@"AFT" ofType:@"mp4"] ];//[[VLCMedia alloc]initWithURL:self.mediaURL];//
}
- (void)setupView{
    [self setBackgroundColor:[UIColor blackColor]];
}
- (void)setupControlView{
    [self addSubview:self.toolsView];
    
    // 添加控制界面的监听方法
    [self.toolsView.playBtn addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolsView.pasueBtn addTarget:self action:@selector(pauseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolsView.returnBtn addTarget:self action:@selector(returnButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolsView.fullScreenBtn addTarget:self action:@selector(fullScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolsView.smallScreenBtn addTarget:self action:@selector(shrinkScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolsView.progressSlider addTarget:self action:@selector(progressClick1) forControlEvents:UIControlEventValueChanged];
    [self.toolsView.progressSlider addTarget:self action:@selector(progressClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolsView.btn_playAndPause addTarget:self action:@selector(playAndPauseClick) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark--Notification Handler
/*
 屏幕旋转处理
 */
- (void)orientationHandler{
    if(UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)){
        self.isFullScreenModel = YES;
    }else{
        self.isFullScreenModel = NO;
    }
    [self.toolsView autoFadeOutControlBar];
}
/*
 即将进入后台的处理
 */
- (void)applicationWillEnterForeground{
    [self play];
}
/*
 即将返回前台的处理
 */
- (void)applicationWillResignActive{
    [self pause];
}

#pragma mark--Button Event
- (void)playButtonClick{
    [self play];
}
- (void)pauseButtonClick{
    [self pause];
}
- (void)returnButtonClick{
    if(self.isFullScreenModel == YES){
        [self shrinkScreenButtonClick];
        return;
    }
    self.returnLastpage();
//    [self dismiss];
}
- (void)fullScreenButtonClick{
    
    [self forceChangeOrientation:UIInterfaceOrientationLandscapeRight];
}
- (void)shrinkScreenButtonClick{
    [self forceChangeOrientation:UIInterfaceOrientationPortrait];
}
- (void)progressClick1{
    // 只改变进度条显示
    int targetValue = (int)(self.toolsView.progressSlider.value * (float)kMediaLength.intValue);
    VLCTime *targetTime = [[VLCTime alloc]initWithInt:targetValue];
    [self.toolsView.timeLabel setText:[NSString stringWithFormat:@"%@/%@",targetTime.stringValue,kMediaLength.stringValue]];
    [self.toolsView autoFadeOutControlBar];
}
- (void)progressClick{
    // 更新视频进度
    int targetValue = (int)(self.toolsView.progressSlider.value * (float)kMediaLength.intValue);
    VLCTime *targetTime = [[VLCTime alloc]initWithInt:targetValue];
    [self.player setTime:targetTime];
    [self.toolsView.timeLabel setText:[NSString stringWithFormat:@"%@/%@",_player.time.stringValue,kMediaLength.stringValue]];
    [self.toolsView autoFadeOutControlBar];
}
- (void)playAndPauseClick{
    self.toolsView.btn_playAndPause.selected = !self.toolsView.btn_playAndPause.selected;
    if(self.toolsView.btn_playAndPause.selected){
        [self pause];
    }else{
        [self play];
    }
}
#pragma mark--强制横屏
- (void)forceChangeOrientation:(UIInterfaceOrientation)orientation{
    int val = orientation;
    if([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]){
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
#pragma mark Player Logic
- (void)play{
    [self.player play];
    self.toolsView.playBtn.hidden = YES;
    self.toolsView.pasueBtn.hidden = NO;
    self.toolsView.btn_playAndPause.selected = NO;
    [self.toolsView autoFadeOutControlBar];
}
- (void)pause{
    [self.player pause];
    self.toolsView.playBtn.hidden = NO;
    self.toolsView.pasueBtn.hidden = YES;
    self.toolsView.btn_playAndPause.selected = YES;
    [self.toolsView setOperateControlHidden:NO];
    [self.toolsView autoFadeOutControlBar];
}
- (void)stop{
    [self.player stop];
    self.toolsView.progressSlider.value = 1;
    self.toolsView.playBtn.hidden = NO;
    self.toolsView.pasueBtn.hidden = YES;
    [self.toolsView setOperateControlHidden:NO];
    self.toolsView.btn_playAndPause.selected = YES;
}
#pragma mark-- VLCMediaPlayerDelegate
- (void)mediaPlayerStateChanged:(NSNotification *)aNotification{
    // Every Time change the state,The LVC will draw video layer on this layer.
    [self bringSubviewToFront:self.toolsView];
    if(self.player.media.state == VLCMediaStateBuffering){
        self.toolsView.bgLayer.hidden = NO;
    }else if(self.player.state == VLCMediaPlayerStatePlaying){
        self.toolsView.bgLayer.hidden = YES;
        self.toolsView.btn_playAndPause.selected = NO;
    }else if(self.player.state == VLCMediaPlayerStateStopped){
        [self stop];
    }else{
        self.toolsView.bgLayer.hidden = NO;
    }
}
- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification{
    [self bringSubviewToFront:self.toolsView];
    if(self.toolsView.progressSlider.state != UIControlStateNormal){
        return;
    }
    float precentValue = ([self.player.time.value floatValue]) / ([kMediaLength.value floatValue]);
    [self.toolsView.progressSlider setValue:precentValue animated:YES];
    [self.toolsView.timeLabel setText:[NSString stringWithFormat:@"%@/%@",_player.time.stringValue,kMediaLength.stringValue]];
}
#pragma mark--懒加载
- (VLCMediaPlayer *)player{
    if(!_player){
        _player = [[VLCMediaPlayer alloc]initWithOptions:nil];
        _player.delegate = self;
    }
    return _player;
}
- (LFVideoToolsView *)toolsView{
    if(!_toolsView){
        _toolsView = [[LFVideoToolsView alloc]initWithFrame:self.bounds];
        _toolsView.delegate = self;
    }
    return _toolsView;
}
- (UIView *)statusBar{
    if(!_statusBar){
        _statusBar = [[[UIApplication sharedApplication]valueForKey:@"statusBarWindow"]valueForKey:@"statusBar"];
    }
    return _statusBar;
}
- (void)setIsHideReturnBtn:(BOOL)isHideReturnBtn{
    _isHideReturnBtn = isHideReturnBtn;
    self.toolsView.returnBtn.hidden = isHideReturnBtn;
    
    if(isHideReturnBtn){
        self.toolsView.lab_videoTitle.frame = CGRectMake(15, 0, self.bounds.size.width - 30, 40);
    }else{
        self.toolsView.lab_videoTitle.frame = CGRectMake(35, 0, self.bounds.size.width - 50, 40);
    }
}
#pragma mark--横竖屏处理
- (void)setIsFullScreenModel:(BOOL)isFullScreenModel{
    if(_isFullScreenModel == isFullScreenModel){
        return;
    }
    self.toolsView.isFullScreenMode = isFullScreenModel;
    _isFullScreenModel = isFullScreenModel;
    if(isFullScreenModel){
        self.toolsView.returnBtn.hidden = NO;
        self.statusBar.hidden = YES;
        _orignFrame = self.frame;
        _fatherView = self.superview;
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self];
        
        CGRect frame = keyWindow.bounds;

        [UIView animateWithDuration:LF_VideoControlAnimationTimeInterval animations:^{
            // 此判断是为了适配项目在Deployment InfoI中是否勾选了横屏
            if(UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)){
                if([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft){
                    self.transform = CGAffineTransformMakeRotation(M_PI_2);
                }
                if([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight){
                    self.transform = CGAffineTransformMakeRotation(-M_PI_2);
                }
                self.frame = frame;

            }else{
                self.frame = kSCREEN_BOUNDS;
            }
            self.toolsView.frame = self.bounds;
            self.toolsView.fullScreenBtn.hidden = YES;
            self.toolsView.smallScreenBtn.hidden = NO;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        if(self.isHideReturnBtn){
            self.toolsView.returnBtn.hidden = YES;
        }
            self.statusBar.hidden = NO;
            [UIView animateWithDuration:LF_VideoControlAnimationTimeInterval animations:^{
            self.transform = CGAffineTransformIdentity;
            self.frame = _orignFrame;
            self.toolsView.frame = self.bounds;
            [self.toolsView layoutIfNeeded];
            self.toolsView.fullScreenBtn.hidden = NO;
            self.toolsView.smallScreenBtn.hidden =YES;
            
            [_fatherView addSubview:self];
        } completion:nil];
    }
}
- (void)removeFromSuperview{
    [super removeFromSuperview];
    self.player.delegate = nil;
    self.player.drawable = nil;
    self.player = nil;
}
#pragma mark--LFVideoToolsViewDelegate
- (VLCTime *)getVideoTime{
    return kMediaLength;
}
- (VLCTime *)getVideoCurrentTime{
    return self.player.time;
}
- (void)updateVideoTime:(VLCTime *)time{
    if(![self.player isPlaying]){
        [self.player play];
        [NSThread sleepForTimeInterval:0.001];
    }
    [self.player setTime:time];
}
#pragma mark--touch
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
   
}
- (BOOL)prefersStatusBarHidden {
    return YES; // 返回NO表示要显示，返回YES将hiden
}
@end
