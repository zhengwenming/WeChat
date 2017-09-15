//
//  LikeUsersCell.h
//  WeChat
//
//  Created by zhengwenming on 2017/9/10.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendModel;
@class MessageModel;

typedef void(^TapNameBlock)(FriendModel *friendModel);
@interface LikeUsersCell : UITableViewCell

- (void)configLikeUsersWithMessageModel:(MessageModel *)messageModel;

@property (weak, nonatomic) IBOutlet UILabel *likeUsersLabel;
@property(nonatomic ,copy)TapNameBlock tapNameBlock;
@end
