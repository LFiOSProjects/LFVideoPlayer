//
//  LFVideoPlayerConst.h
//  PTApp
//
//  Created by 王林芳 on 2018/4/16.
//  Copyright © 2018年 王林芳. All rights reserved.
//

#ifndef LFVideoPlayerConst_h
#define LFVideoPlayerConst_h
#define kMediaLength self.player.media.length
#define kRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define kRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kSCREEN_BOUNDS [[UIScreen mainScreen] bounds]
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define LFVideoPlayerWillFullScreen @"LFVideoPlayerWillFullScreen"
#define LFVideoPlayerWillShrinkScreen @"LFVideoPlayerWillShrinkScreen"

static const CGFloat LF_ProgressWidth = 3.0f;
static const CGFloat LF_VideoControlBarHeight = 40.0;
static const CGFloat LF_VideoControlSliderHeight = 10.0;
static const CGFloat LF_VideoControlAnimationTimeInterval = 0.3;
static const CGFloat LF_VideoControlTimeLabelFontSize = 10.0;
static const CGFloat LF_VideoControlBarAutoFadeOutTimeInterval = 4.0;
static const CGFloat LF_VideoControlCorrectValue = 3;
static const CGFloat LF_VideoControlAlertAlpha = 0.75;


#endif /* LFVideoPlayerConst_h */
