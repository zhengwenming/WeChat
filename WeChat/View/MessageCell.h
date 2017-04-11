//
//  MessageCell.h
//  WeChat
//
//  Created by zhengwenming on 16/6/4.
//  Copyright © 2016年 zhengwenming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGGView.h"
#import "CommentCell.h"
@class MessageCell;
@class MessageModel;

@protocol MessageCellDelegate <NSObject>

- (void)reloadCellHeightForModel:(MessageModel *)model atIndexPath:(NSIndexPath *)indexPath;

- (void)passCellHeight:(CGFloat )cellHeight commentModel:(CommentModel *)commentModel   commentCell:(CommentCell *)commentCell messageCell:(MessageCell *)messageCell;

@end



@interface MessageCell : UITableViewCell

@property (nonatomic, strong) JGGView *jggView;

/**
 *  评论按钮的block
 */
@property (nonatomic, copy)void(^CommentBtnClickBlock)(UIButton *commentBtn,NSIndexPath * indexPath);

/**
 *  更多按钮的block
 */
@property (nonatomic, copy)void(^MoreBtnClickBlock)(UIButton *moreBtn,NSIndexPath * indexPath);


/**
 *  点击图片的block
 */
@property (nonatomic, copy)TapBlcok tapImageBlock;

/**
 *  点击文字的block
 */
@property (nonatomic, copy)void(^TapTextBlock)(UILabel *desLabel);

@property (nonatomic, weak) id<MessageCellDelegate> delegate;

- (void)configCellWithModel:(MessageModel *)model indexPath:(NSIndexPath *)indexPath;


@end
