//
//  LikeUsersCell1.h
//  WeChat
//
//  Created by zhengwenming on 2017/9/23.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendInfoModel;
#import "MessageInfoModel1.h"

typedef void(^TapNameBlock)(FriendInfoModel *friendModel);
@interface LikeUsersCell1 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *likeUsersLabel;
@property(nonatomic ,copy)TapNameBlock tapNameBlock;

@property(nonatomic ,strong)MessageInfoModel1 *model;

@end
