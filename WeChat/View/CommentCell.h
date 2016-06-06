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
- (void)configCellWithModel:(CommentModel *)model;

@end

