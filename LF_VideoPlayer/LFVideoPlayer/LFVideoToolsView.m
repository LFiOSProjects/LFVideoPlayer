//
//  LFVideoToolsView.m
//  PTApp
//
//  Created by 王林芳 on 2018/4/16.
//  Copyright © 2018年 王林芳. All rights reserved.
//

#import "LFVideoToolsView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "LFVideoPlayerConst.h"
#import "LFVideoTimeMarkView.h"
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@interface LFVideoToolsView ()
//拖动手势
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
//全屏状态下，拖动屏幕时视频进度调整相关的提示
@property (nonatomic, strong) LFVideoTimeMarkView *timeMarkView;
@end
@implementation LFVideoToolsView
{
    VLCTime *totalTime;
    VLCTime *currentTime;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setUpView];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.topBar.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds), CGRectGetWidth(self.bounds), LF_VideoControlBarHeight);
    self.returnBtn.frame = CGRectMake(0, CGRectGetMinY(self.topBar.bounds), CGRectGetWidth(self.returnBtn.bounds), CGRectGetHeight(self.returnBtn.bounds));
    if(self.returnBtn.hidden){
        self.lab_videoTitle.frame = CGRectMake(15, 0, self.bounds.size.width - 30, 40);
    }else{
        self.lab_videoTitle.frame = CGRectMake(35, 0, self.bounds.size.width - 50, 40);
    }

    self.bottomBar.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetHeight(self.bounds) - LF_VideoControlBarHeight, CGRectGetWidth(self.bounds), LF_VideoControlBarHeight);
    self.progressSlider.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), LF_VideoControlSliderHeight);
    self.playBtn.frame = CGRectMake(CGRectGetMinX(self.bottomBar.bounds), CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.playBtn.bounds)/2 + CGRectGetHeight(self.progressSlider.frame) * 0.6, CGRectGetWidth(self.playBtn.bounds), CGRectGetHeight(self.playBtn.bounds));
    self.pasueBtn.frame = self.playBtn.frame;
    self.fullScreenBtn.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds) - CGRectGetWidth(self.fullScreenBtn.bounds) - 5, self.playBtn.frame.origin.y, CGRectGetWidth(self.fullScreenBtn.bounds), CGRectGetHeight(self.fullScreenBtn.bounds));
    self.smallScreenBtn.frame = self.fullScreenBtn.frame;
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.playBtn.frame), self.playBtn.frame.origin.y, CGRectGetWidth(self.bottomBar.bounds), CGRectGetHeight(self.timeLabel.bounds));
    
    self.timeMarkView.center = self.center;
    self.btn_playAndPause.center = self.center;
    if(self.isFullScreenMode){
        self.panGesture.enabled = YES;
    }else{
        self.panGesture.enabled = NO;
    }
    

}
#pragma mark-- 私有方法
- (void)setUpView{
    self.backgroundColor = [UIColor clearColor];
    
    [self.layer addSublayer:self.bgLayer];
    [self addSubview:self.topBar];
    [self addSubview:self.bottomBar];
    
    [self.topBar addSubview:self.returnBtn];
    
//    [self.bottomBar addSubview:self.playBtn];
//    [self.bottomBar addSubview:self.pasueBtn];
    [self.bottomBar addSubview:self.fullScreenBtn];
    [self.bottomBar addSubview:self.smallScreenBtn];
    [self.bottomBar addSubview:self.progressSlider];
    [self.bottomBar addSubview:self.timeLabel];
    
    self.pasueBtn.hidden = YES;
    self.smallScreenBtn.hidden = YES;
    
    [self addGestureRecognizer:self.panGesture];
    
    [self addSubview:self.timeMarkView];
    [self addSubview:self.btn_playAndPause];
    [self.topBar addSubview:self.lab_videoTitle];
}
- (void)responseTapImmediatelay{
//    self.bottomBar.alpha == 0 ? [self animateShow] : [self animateHide];
    self.bottomBar.hidden == YES ? [self animateShow] : [self animateHide];
}
#pragma mark--隐藏工具栏，全屏效果
- (void)animateHide{
    
    [self setOperateControlHidden:YES];
}
#pragma mark--显示工具栏
- (void)animateShow{
   
    [self setOperateControlHidden:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setOperateControlHidden:YES];
    });
}
- (void)setOperateControlHidden:(BOOL)isHidden{
    self.topBar.hidden = isHidden;
    self.bottomBar.hidden = isHidden;
    self.btn_playAndPause.hidden = isHidden;
}
- (void)autoFadeOutControlBar{
    // 如果有延迟执行在队列中，则取消延时执行
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
    // 开始延时执行
    [self performSelector:@selector(animateHide) withObject:nil afterDelay:LF_VideoControlBarAutoFadeOutTimeInterval];
}
- (void)cancelAutoFadeOutControlBar{
    // 如果有延迟执行在队列中，则取消延时执行
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
}
#pragma mark-- 屏幕触摸事件
- (void)panGestureAction:(UIPanGestureRecognizer *)pan{
    if(!_isFullScreenMode){
        // 只在全屏模式下触发拖动屏幕进行快进/退
        return;
    }
    //获取偏移量
    CGPoint transP = [pan translationInView:self];
    if(pan.state == UIGestureRecognizerStateBegan){
        [self setOperateControlHidden:YES];
        self.timeMarkView.hidden = NO;
        totalTime = [self.delegate getVideoTime];
        currentTime = [self.delegate getVideoCurrentTime];
    }
    
    int varValue = (int)transP.x / ScreenHeight * totalTime.intValue;//视频进度变化量
    int targerValue = currentTime.value.intValue + varValue;
    if(targerValue < 0)
    {
        targerValue = 1;
    }
    if(targerValue > totalTime.intValue){
        targerValue = totalTime.intValue - 1;
    }
    VLCTime *targetTime = [[VLCTime alloc]initWithInt:targerValue];
    [self.timeMarkView updateContentWithTotalTime:totalTime currentTime:targetTime];
//    NSLog(@"视频当前进度为：%@",targetTime);
    if(pan.state == UIGestureRecognizerStateEnded){
        self.timeMarkView.hidden = YES;
        self.btn_playAndPause.selected = NO;
        [self.delegate updateVideoTime:targetTime];
    }
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if(touch.tapCount > 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self responseTapImmediatelay];
        });
    }
}
//- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self responseTapImmediatelay];
//}
#pragma mark-- 懒加载
- (UIView *)topBar{
    if(!_topBar){
        _topBar = [UIView new];
        _topBar.backgroundColor = kRGBA(0, 0, 0, 0.5);
    }
    return _topBar;
}
- (UIView *)bottomBar{
    if(!_bottomBar){
        _bottomBar = [UIView new];
        _bottomBar.backgroundColor = kRGBA(0, 0, 0, 0.5);//(27, 27, 27);
    }
    return _bottomBar;
}
- (UIButton *)playBtn{
    if(!_playBtn){
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
        _playBtn.bounds = CGRectMake(0, 0, LF_VideoControlBarHeight, LF_VideoControlBarHeight);
    }
    return _playBtn;
}
- (UIButton *)pasueBtn{
    if(!_pasueBtn){
        _pasueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pasueBtn setImage:[UIImage imageNamed:@"Pause"] forState:UIControlStateNormal];
        _pasueBtn.bounds = CGRectMake(0, 0, LF_VideoControlBarHeight, LF_VideoControlBarHeight);
    }
    return _pasueBtn;
}
- (UIButton *)fullScreenBtn{
    if(!_fullScreenBtn){
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"FullScreen"] forState:UIControlStateNormal];
        _fullScreenBtn.bounds = CGRectMake(0, 0, LF_VideoControlBarHeight, LF_VideoControlBarHeight);
    }
    return _fullScreenBtn;
}
- (UIButton *)smallScreenBtn{
    if(!_smallScreenBtn){
        _smallScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_smallScreenBtn setImage:[UIImage imageNamed:@"MinScreen"] forState:UIControlStateNormal];
        _smallScreenBtn.bounds = CGRectMake(0, 0, LF_VideoControlBarHeight, LF_VideoControlBarHeight);
    }
    return _smallScreenBtn;
}
- (UISlider *)progressSlider{
    if(!_progressSlider){
        _progressSlider = [[UISlider alloc]init];
        [_progressSlider setThumbImage:[UIImage imageNamed:@"PlayerNob"] forState:UIControlStateNormal];
        [_progressSlider setMinimumTrackTintColor:kRGB(239, 71, 94)];
        [_progressSlider setMaximumTrackTintColor:kRGB(157, 157, 157)];
        [_progressSlider setBackgroundColor:[UIColor clearColor]];
        _progressSlider.value = 0.f;
        _progressSlider.continuous = YES;
    }
    return _progressSlider;
}
- (UIButton *)returnBtn{
    if(!_returnBtn){
        _returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_returnBtn setImage:[UIImage imageNamed:@"PlayClose"] forState:UIControlStateNormal];
//        [_returnBtn setBackgroundImage:[UIImage imageNamed:@"PlayClose"] forState:UIControlStateNormal];
        _returnBtn.bounds = CGRectMake(0, 0, LF_VideoControlBarHeight, LF_VideoControlBarHeight);
    }
    return _returnBtn;
}
- (UILabel *)timeLabel{
    if(!_timeLabel){
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:LF_VideoControlTimeLabelFontSize];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.bounds = CGRectMake(0, 0, 160, LF_VideoControlBarHeight);
    }
    return _timeLabel;
}
- (CALayer *)bgLayer{
    if(!_bgLayer){
        _bgLayer = [CALayer layer];
//        _bgLayer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"VideoBg"]].CGColor;
        _bgLayer.backgroundColor = [[UIColor clearColor] CGColor];
        _bgLayer.bounds = self.frame;
        _bgLayer.position = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    }
    return _bgLayer;
}
- (UIPanGestureRecognizer *)panGesture{
    if(!_panGesture){
        _panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
    }
    return _panGesture;
}
- (LFVideoTimeMarkView *)timeMarkView{
    if(!_timeMarkView){
        _timeMarkView = [[LFVideoTimeMarkView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
        _timeMarkView.hidden = YES;
    }
    return _timeMarkView;
}
- (UIButton *)btn_playAndPause{
    if(!_btn_playAndPause){
        _btn_playAndPause = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_playAndPause setBackgroundImage:[UIImage imageNamed:@"op_pause"] forState:UIControlStateNormal];//视频播放时，按钮处于未选中状态，配图用pause
        [_btn_playAndPause setBackgroundImage:[UIImage imageNamed:@"op_play"] forState:UIControlStateSelected];//视频暂停时，按钮处于选中状态，配图用play
        _btn_playAndPause.bounds = CGRectMake(0, 0, 60, 60);
    }
    return _btn_playAndPause;
}
- (UILabel *)lab_videoTitle{
    if(!_lab_videoTitle){
        _lab_videoTitle = [[UILabel alloc]init];
        _lab_videoTitle.font = [UIFont boldSystemFontOfSize:14];
        _lab_videoTitle.textColor = [UIColor whiteColor];
        _lab_videoTitle.numberOfLines = 0;
        _lab_videoTitle.text = @"大风起兮云飞扬，威加海内兮归故乡,安得猛士兮守四方";
    }
    return _lab_videoTitle;
}
#pragma mark--UIGestureRecognizerDelegate  允许同时手势识别
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint myPoint = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, myPoint)) {
                
                return subView;
            }
        }
    }
    
    return view;
}
@end
