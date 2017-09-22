//
//  MessageInfoModel2.h
//  WeChat
//
//  Created by zhengwenming on 2017/9/21.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentInfoModel2.h"
#import "FriendInfoModel.h"
#import "Layout.h"

@interface MessageInfoModel2 : NSObject

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

///点赞的人列表
@property(nonatomic,copy)NSMutableArray <FriendInfoModel *>*likeUsers;

///发布说说者头像
@property(nonatomic,copy)NSString *photo;

///评论小图
@property(nonatomic,copy)NSMutableArray *messageSmallPics;

///评论大图
@property(nonatomic,copy)NSMutableArray *messageBigPics;

///评论相关的所有信息
@property(nonatomic,copy)NSMutableArray *commentModelArray;
///sectionHeaderView的高度
@property (nonatomic, assign) CGFloat headerHeight;
///发布文字的布局
@property (nonatomic, strong) Layout *textLayout;
///九宫格的布局
@property (nonatomic, strong) Layout *jggLayout;

@property(nonatomic,strong)NSMutableAttributedString *mutablAttrStr;



-(instancetype)initWithDic:(NSDictionary *)dic;


@end
