//
//  LFBaseModel.m
//  Network_Tool
//
//  Created by 王林芳 on 2018/4/11.
//  Copyright © 2018年 王林芳. All rights reserved.
//

#import "LFBaseModel.h"
#import <objc/runtime.h>
@implementation LFBaseModel

-(NSString *)description{
    unsigned int count;
    const char *clasName = object_getClassName(self);
    NSMutableString *string = [NSMutableString stringWithFormat:@"<%s: %p>:[ \n",clasName, self];
    Class clas = NSClassFromString([NSString stringWithCString:clasName encoding:NSUTF8StringEncoding]);
    Ivar *ivars = class_copyIvarList(clas, &count);
    for (int i = 0; i < count; i++) {
        @autoreleasepool {
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            //得到类型
            NSString *type = [NSString stringWithCString:ivar_getTypeEncoding(ivar) encoding:NSUTF8StringEncoding];
            NSString *key = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            id value = [self valueForKey:key];
            //确保BOOL 值输出的是YES 或 NO，这里的B是我打印属性类型得到的……
            if ([type isEqualToString:@"B"]) {
                value = (value == 0 ? @"NO" : @"YES");
            }
            [string appendFormat:@"\t%@: %@\n",[self delLine:key], value];
        }
    }
    [string appendFormat:@"]"];
    return string;
}
//因为ivar_getName得到的是一个带有下划线的名字，去掉下划线看起来更漂亮
-(NSString *)delLine:(NSString *)string{
    if ([string hasPrefix:@"_"]) {
        return [string substringFromIndex:1];
    }
    return string;
}
@end
