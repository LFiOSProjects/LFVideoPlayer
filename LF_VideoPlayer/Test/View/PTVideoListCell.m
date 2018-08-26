//
//  PTVideoListCell.m
//  PTApp
//
//  Created by 王林芳 on 2018/4/19.
//  Copyright © 2018年 王林芳. All rights reserved.
//

#import "PTVideoListCell.h"
#import "LFVideoPlayer.h"
@interface PTVideoListCell()
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIButton *btn_showDetail;
@end
@implementation PTVideoListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createUI];
    }
    return self;
}
- (void)layoutSubviews{
    self.btn.center = self.contentView.center;
}
- (void)createUI{
    [self.contentView addSubview:self.image];
    [self.contentView addSubview:self.btn];
    [self.contentView addSubview:self.btn_showDetail];
}
#pragma mark--懒加载
- (UIImageView *)image{
    if(!_image){
        _image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, PTScreenWidth, PTScreenWidth / 116.0 * 90)];
        [_image setBackgroundColor:[UIColor blueColor]];
    }
    return _image;
}
- (UIButton *)btn{
    if(!_btn){
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.bounds = CGRectMake(0, 0, 60, 60);
        _btn.center = self.contentView.center;
        _btn.enabled = NO;
        [_btn setBackgroundImage:[UIImage imageNamed:@"op_play"] forState:UIControlStateNormal];
    }
    return _btn;
}
- (UIButton *)btn_showDetail{
    if(!_btn_showDetail){
        _btn_showDetail = [UIButton buttonWithType:UIButtonTypeSystem];
        _btn_showDetail.frame = CGRectMake((PTScreenWidth - 100)/2, PTScreenWidth / 116.0 * 90 + 10, 100, 30);
        [_btn_showDetail setTitle:@"详情" forState:UIControlStateNormal];
        [_btn_showDetail addTarget:self action:@selector(showDetail) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_showDetail;
}
- (void)setModel:(PTVideoListModel *)model{
//    [self.image sd_setImageWithURL:[NSURL URLWithString:model.pictureUrl]];
    self.image.image = [UIImage imageNamed:@"tmpImg.jpg"];
}
- (void)showDetail{
    if([self.delegate respondsToSelector:@selector(showVideoDetailForCell:)]){
        [self.delegate showVideoDetailForCell:self];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
