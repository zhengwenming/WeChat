//
//  ToolBarItem.m
//  KeyboardForChat

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by caipeng on 16/4/1.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#import "ChatToolBarItem.h"

@implementation ChatToolBarItem

+ (instancetype)barItemWithKind:(BarItemKind)itemKind normal:(NSString*)normalStr high:(NSString *)highLstr select:(NSString *)selectStr
{
    return [[[self class] alloc] initWithItemKind:itemKind normal:normalStr high:highLstr select:selectStr];
}


- (instancetype)initWithItemKind:(BarItemKind)itemKind normal:(NSString*)normalStr high:(NSString *)highLstr select:(NSString *)selectStr
{
    if (self = [super init]) {
        self.itemKind = itemKind;
        self.normalStr = normalStr;
        self.highLStr = highLstr;
        self.selectStr = selectStr;
    }
    return self;
}

@end
