
/*!
 @header CommentModel.h
 
 @abstract  作者Github地址：https://github.com/zhengwenming
            作者CSDN博客地址:http://blog.csdn.net/wenmingzheng
 
 @author   Created by zhengwenming on  16/3/27
 
 @version 1.00 16/3/27 Creation(版本信息)
 
   Copyright © 2016年 zhengwenming. All rights reserved.
 */






#import <Foundation/Foundation.h>

/*{
 "id":654,
 "commentId":575,
 "commentUserId":274,
 "commentUserName":"文明",
 "commentPhoto":"http://q.qlogo.cn/qqapp/1104706859/189AA89FAADD207E76D066059F924AE0/100",
 "commentText":"真的假的？",
 "commentByUserId":274,
 "commentByUserName":"文明",
 "commentByPhoto":"http://q.qlogo.cn/qqapp/1104706859/189AA89FAADD207E76D066059F924AE0/100",
 "createDate":1463126018000,
 "createDateStr":"2016-05-13 15:53",
 "checkStatus":"YES"
 }*/



@interface CommentModel : NSObject

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, assign) BOOL isExpand;

@property(nonatomic,copy)NSString *commentId;

@property(nonatomic,copy)NSString *commentUserId;

@property(nonatomic,copy)NSString *commentUserName;

@property(nonatomic,copy)NSString *commentPhoto;

@property(nonatomic,copy)NSString *commentText;
@property(nonatomic,copy)NSString *commentByUserId;
@property(nonatomic,copy)NSString *commentByUserName;
@property(nonatomic,copy)NSString *commentByPhoto;
@property(nonatomic,copy)NSString *createDateStr;
@property(nonatomic,copy)NSString *checkStatus;

///评论大图
@property(nonatomic,copy)NSMutableArray *messageBigPicArray;

// 评论数据源
@property (nonatomic,copy) NSMutableArray *commentModelArray;

//@property (nonatomic, assign) BOOL shouldUpdateCache;

-(instancetype)initWithDic:(NSDictionary *)dic;


@end
