//
//  CommentCell2.h
//  WeChat
//
//  Created by zhengwenming on 2017/9/21.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentInfoModel2.h"
@class CommentCell2;
typedef void(^TapCommentBlock)(CommentCell2 *cell,CommentInfoModel2 *model);


@interface CommentCell2 : UITableViewCell
@property(nonatomic,strong)CommentInfoModel2 *model;
///点击某个人名字的block回调
@property(nonatomic ,copy)TapCommentBlock tapCommentBlock;

@end
