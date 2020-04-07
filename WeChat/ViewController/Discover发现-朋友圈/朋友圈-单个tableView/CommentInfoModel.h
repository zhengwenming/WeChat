//
//  CommentInfoModel.h
//  WeChat
//
//  Created by zhengwenming on 2017/9/21.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentInfoModel : NSObject
@property (nonatomic, assign) BOOL isExpand;

@property(nonatomic,copy)NSString *commentId;

@property(nonatomic,copy)NSString *commentUserId;

@property(nonatomic,copy)NSString *commentUserName;

@property(nonatomic,copy)NSString *commentPhoto;

@property(nonatomic,copy)NSString *commentText;
@property(nonatomic,copy)NSAttributedString *attributedText;

@property(nonatomic,copy)NSString *commentByUserId;
@property(nonatomic,copy)NSString *commentByUserName;
@property(nonatomic,copy)NSString *commentByPhoto;
@property(nonatomic,copy)NSString *createDateStr;
@property(nonatomic,copy)NSString *checkStatus;

///评论大图
@property(nonatomic,copy)NSMutableArray *messageBigPicArray;
@property(nonatomic,copy)NSMutableAttributedString *likeUsersAttributedText;

@property(nonatomic,copy)NSMutableArray<CommentInfoModel *> *likeUsersArray;

// 评论数据源
@property (nonatomic,copy) NSMutableArray *commentModelArray;

@property (nonatomic, assign)CGFloat rowHeight;

-(instancetype)initWithDic:(NSDictionary *)dic;
@end
