//
//  LFVideoPlayer.h
//  PTApp
//
//  Created by 王林芳 on 2018/4/17.
//  Copyright © 2018年 王林芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFVideoPlayerConst.h"
@interface LFVideoPlayer : UIView
@property (nonatomic, strong) NSURL *mediaURL;
@property (nonatomic, assign) BOOL isFullScreenModel;
@property (nonatomic, assign) BOOL isPlayImmdiately;// 是否立刻播放
@property (nonatomic, assign) BOOL isHideReturnBtn;
@property (nonatomic, copy) void(^returnLastpage)() ;

- (void)showInView:(UIView *)view;
- (void)dismiss;
@end
