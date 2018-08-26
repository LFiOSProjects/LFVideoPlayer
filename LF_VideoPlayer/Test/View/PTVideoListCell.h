//
//  PTVideoListCell.h
//  PTApp
//
//  Created by 王林芳 on 2018/4/19.
//  Copyright © 2018年 王林芳. All rights reserved.
//

#import "LFBaseCell.h"
#import "PTVideoListModel.h"
@protocol PTVideoListCellDelegate<NSObject>
- (void)showVideoDetailForCell:(LFBaseCell *)cell;
@end
@interface PTVideoListCell : LFBaseCell
@property (nonatomic, assign) id<PTVideoListCellDelegate>delegate;
@property (nonatomic, assign) CGFloat originY;
@property (nonatomic, assign) CGFloat originHeight;
- (void)setModel:(PTVideoListModel *)model;
@end
