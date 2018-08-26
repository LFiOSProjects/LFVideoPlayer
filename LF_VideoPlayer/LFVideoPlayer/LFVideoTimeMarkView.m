//
//  LFVideoTimeMarkView.m
//  PTApp
//
//  Created by 王林芳 on 2018/4/18.
//  Copyright © 2018年 王林芳. All rights reserved.
//

#import "LFVideoTimeMarkView.h"
@interface LFVideoTimeMarkView()
@property (nonatomic,strong) UILabel *lab_time;
@end
@implementation LFVideoTimeMarkView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setupView];
    }
    return self;
}
- (void)setupView{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.layer.cornerRadius = 10;
    [self addSubview:self.lab_time];
}
- (void)updateContentWithTotalTime:(VLCTime *)totalTime currentTime:(VLCTime *)currentTime{
    self.lab_time.text = [NSString stringWithFormat:@"%@/%@",currentTime.stringValue,totalTime.stringValue];
}
- (UILabel *)lab_time{
    if(!_lab_time){
        _lab_time = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
        _lab_time.center = self.center;
        _lab_time.textColor = [UIColor whiteColor];
        _lab_time.font = [UIFont systemFontOfSize:18];
        _lab_time.textAlignment = NSTextAlignmentCenter;
    }
    return _lab_time;
}
@end
