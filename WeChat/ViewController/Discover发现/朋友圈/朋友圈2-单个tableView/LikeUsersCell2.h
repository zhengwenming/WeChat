//
//  LikeUsersCell2.h
//  WeChat
//
//  Created by zhengwenming on 2017/9/23.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendInfoModel;
#import "MessageInfoModel2.h"

typedef void(^TapNameBlock)(FriendInfoModel *friendModel);




@interface LikeUsersCell2 : UITableViewCell
///显示点赞人列表label
@property (weak, nonatomic) IBOutlet UILabel *likeUsersLabel;

@property(nonatomic,strong)NSMutableArray *likeUsersArray;
@property(nonatomic,strong)CommentInfoModel2 *model;


///点击某个人名字的block回调
@property(nonatomic ,copy)TapNameBlock tapNameBlock;
@end
