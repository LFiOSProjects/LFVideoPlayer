//
//  PTVideoDetailController.h
//  PTApp
//
//  Created by 王林芳 on 2018/4/20.
//  Copyright © 2018年 王林芳. All rights reserved.
//

#import "LFBaseController.h"
#import "LFVideoPlayer.h"
@interface PTVideoDetailController : LFBaseController
@property (nonatomic, strong) UIView *view_playerFather;
@property (nonatomic, strong) LFVideoPlayer *player;
@end
