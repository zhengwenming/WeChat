//
//  CommentCell.h
//  WeChat
//
//  Created by zhengwenming on 2017/9/21.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentInfoModel.h"
@class CommentCell;
typedef void(^TapCommentBlock)(CommentCell *cell,CommentInfoModel *model);


@interface CommentCell : UITableViewCell
@property(nonatomic,strong)CommentInfoModel *model;
///点击某个人名字的block回调
@property(nonatomic ,copy)TapCommentBlock tapCommentBlock;

@end
