//
//  LFVideoTimeMarkView.h
//  PTApp
//
//  Created by 王林芳 on 2018/4/18.
//  Copyright © 2018年 王林芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileVLCKit/MobileVLCKit.h>
@interface LFVideoTimeMarkView : UIView
- (void)updateContentWithTotalTime:(VLCTime *)totalTime currentTime:(VLCTime *)currentTime;
@end
