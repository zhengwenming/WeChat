//
//  MessageModel.h
//  WeiChatDemo
//
//  Created by zhengwenming on 16/5/21.
//  Copyright © 2016年 zhengwenming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentModel.h"

/*
 {
 "message_id":656,
 "message":"咋啊啊啊啊啊杀杀杀杀杀",
 "createDate":1463646327000,
 "timeTag":"2天前",
 "createDateStr":"2016-05-19 16:25",
 "objId":"f1562484",
 "message_type":"text",
 "checkStatus":"YES",
 "userId":82,
 "userName":"俊",
 "photo":"http://weixintest.ihk.cn/ihkwx_upload/userPhoto/15914867203-1461920972642.jpg",
 "messageSmallPics":[
 "http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160519/14636463273330.JPEG",
 "http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160519/14636463273461.JPEG"
 ],
 "messageBigPics":[
 "http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160519/14636463273330.JPEG",
 "http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160519/14636463273461.JPEG"
 ],
 "commentMessages":[
 
 ]
 }
 */
@interface MessageModel : NSObject
@property (nonatomic, copy) NSString *cid;

///发布说说的id
@property(nonatomic,copy)NSString *message_id;

///发布说说的内容
@property(nonatomic,copy)NSString *message;

///发布说说的展开状态
@property (nonatomic, assign) BOOL isExpand;

///发布说说的时间标签
@property(nonatomic,copy)NSString *timeTag;

///发布说说的类型（可能含有视频）
@property(nonatomic,copy)NSString *message_type;

///发布说说者id
@property(nonatomic,copy)NSString *userId;

///发布说说者名字
@property(nonatomic,copy)NSString *userName;

///发布说说者头像
@property(nonatomic,copy)NSString *photo;

///评论小图
@property(nonatomic,copy)NSMutableArray *messageSmallPics;

///评论大图
@property(nonatomic,copy)NSMutableArray *messageBigPics;

///评论相关的所有信息
@property(nonatomic,copy)NSMutableArray *commentModelArray;


@property (nonatomic, assign) BOOL shouldUpdateCache;


-(instancetype)initWithDic:(NSDictionary *)dic;


@end
