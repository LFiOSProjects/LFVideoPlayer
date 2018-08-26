//
//  LFVideoToolsView.h
//  PTApp
//
//  Created by 王林芳 on 2018/4/16.
//  Copyright © 2018年 王林芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileVLCKit/MobileVLCKit.h>
@protocol LFVideoToolsViewDelegate<NSObject>
//获取视频总共的时间
- (VLCTime *)getVideoTime;
//获取视频当前播放的时间
- (VLCTime *)getVideoCurrentTime;
- (void)updateVideoTime:(VLCTime *)time;
@end

@interface LFVideoToolsView : UIView
@property (nonatomic, assign) id<LFVideoToolsViewDelegate>delegate;
//是否是全屏模式
@property (nonatomic, assign) BOOL isFullScreenMode;
//顶部的工具栏，目前包含返回按钮
@property (nonatomic, strong) UIView *topBar;
//底部的工具栏，目前包含播放、暂停、全屏、进度条、时间等
@property (nonatomic, strong) UIView *bottomBar;
//播放按钮
@property (nonatomic, strong) UIButton *playBtn;
//暂停按钮
@property (nonatomic, strong) UIButton *pasueBtn;
//全屏按钮
@property (nonatomic, strong) UIButton *fullScreenBtn;
//退出全屏按钮
@property (nonatomic, strong) UIButton *smallScreenBtn;
// 进度条
@property (nonatomic, strong) UISlider *progressSlider;
// 返回按钮
@property (nonatomic ,strong) UIButton *returnBtn;
// 时间
@property (nonatomic, strong) UILabel *timeLabel;
// 背景层
@property (nonatomic, strong) CALayer *bgLayer;
// 播放/暂停按钮
@property (nonatomic, strong) UIButton *btn_playAndPause;
// 视频标题
@property (nonatomic, strong) UILabel *lab_videoTitle;
@property (nonatomic, assign) BOOL isHideReturnBtn;
//动画消失
- (void)animateHide;
//动画显示
- (void)animateShow;
- (void)setOperateControlHidden:(BOOL)isHidden;
//延时执行
- (void)autoFadeOutControlBar;
//取消延时执行
- (void)cancelAutoFadeOutControlBar;
@end
