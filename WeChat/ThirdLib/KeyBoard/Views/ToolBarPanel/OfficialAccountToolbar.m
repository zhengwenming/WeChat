//
//  OfficialAccountToolbar.m
//  KeyboardForChat

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by ruofei on 16/4/1.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#import "OfficialAccountToolbar.h"
#import "ChatKeyBoardMacroDefine.h"

@implementation OfficialAccountToolbar
{
    UIButton *_switchBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        _switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchBtn setImage:[UIImage imageNamed:@"switchUp"] forState:UIControlStateNormal];
        [_switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
        _switchBtn.frame = CGRectMake(0, 0, 44, kChatToolBarHeight);
        [self addSubview:_switchBtn];
    }
    return self;
}

- (void)switchAction:(UIButton *)btn
{
    if (self.switchAction) {
        self.switchAction();
    }
}

@end
