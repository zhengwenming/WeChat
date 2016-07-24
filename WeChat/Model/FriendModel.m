

/*!
 @header FriendModel.m
 
 @abstract  作者Github地址：https://github.com/zhengwenming
            作者CSDN博客地址:http://blog.csdn.net/wenmingzheng
 
 @author   Created by zhengwenming on  16/3/11
 
 @version 1.00 16/3/11 Creation(版本信息)
 
   Copyright © 2016年 zhengwenming. All rights reserved.
 */

#import "FriendModel.h"

@implementation FriendModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.userId      = dic[@"userId"];
        self.userName    = dic[@"userName"];
        self.photo       = dic[@"photo"];
        self.phoneNO     = dic[@"phoneNO"];

    }
    return self;
}
@end
