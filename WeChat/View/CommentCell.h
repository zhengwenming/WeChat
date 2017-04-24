//
//  CommentCell.h
//  WeChat
//
//  Created by zhengwenming on 16/6/4.
//  Copyright © 2016年 zhengwenming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentModel;


@interface CommentCell : UITableViewCell


///处理点赞的人列表
- (void)configCellWithLikeUsers:(NSArray *)likeUsers;
///处理评论的文字（包括xx回复yy）
- (void)configCellWithModel:(CommentModel *)model;

@end

