//
//  LikeUsersCell.h
//  WeChat
//
//  Created by zhengwenming on 2017/9/10.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LikeUsersCell : UITableViewCell
- (void)configCellWithLikeUsers:(NSArray *)likeUsers;

@property (weak, nonatomic) IBOutlet UILabel *likeUsersLabel;
@end
