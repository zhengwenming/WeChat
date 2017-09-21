//
//  LikeUsersCell.h
//  WeChat
//
//  Created by zhengwenming on 2017/9/10.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendInfoModel;
#import "MessageInfoModel1.h"

typedef void(^TapNameBlock)(FriendInfoModel *friendModel);
@interface LikeUsersCell : UITableViewCell

- (void)configLikeUsersWithMessageModel:(MessageInfoModel1 *)messageModel;

@property (weak, nonatomic) IBOutlet UILabel *likeUsersLabel;
@property(nonatomic ,copy)TapNameBlock tapNameBlock;
@end
