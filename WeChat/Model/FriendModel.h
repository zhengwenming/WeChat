
/*!
 @header FriendModel.h
 
 @abstract  作者Github地址：https://github.com/zhengwenming
            作者CSDN博客地址:http://blog.csdn.net/wenmingzheng
 
 @author   Created by zhengwenming on  16/3/11
 
 @version 1.00 16/3/11 Creation(版本信息)
 
   Copyright © 2016年 zhengwenming. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface FriendModel : NSObject
@property(nonatomic,copy)NSString *photo;

@property(nonatomic,copy)NSString *userName;

@property(nonatomic,copy)NSString *userId;

@property(nonatomic,copy)NSString *phoneNO;
-(instancetype)initWithDic:(NSDictionary *)dic;
@end
