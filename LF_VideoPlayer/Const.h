//
//  Const.h
//  Network_Tool
//
//  Created by 王林芳 on 2018/4/13.
//  Copyright © 2018年 王林芳. All rights reserved.
//

#ifndef Const_h
#define Const_h

#define PTScreenWidth [UIScreen mainScreen].bounds.size.width
#define PTScreenHeight [UIScreen mainScreen].bounds.size.height
#define PTIS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen]currentMode].size):NO)
#define PTNavigationBarHeight (PTIS_iPhoneX ? 88 : 64)
#endif /* Const_h */
