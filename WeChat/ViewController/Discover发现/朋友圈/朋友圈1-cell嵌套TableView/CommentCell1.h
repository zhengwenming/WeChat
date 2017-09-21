//
//  CommentCell1.h
//  WeChat
//
//  Created by zhengwenming on 2017/9/21.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentInfoModel1.h"

@interface CommentCell1 : UITableViewCell
///处理评论的文字（包括xx回复yy）
- (void)configCellWithModel:(CommentInfoModel1 *)model;

@end
