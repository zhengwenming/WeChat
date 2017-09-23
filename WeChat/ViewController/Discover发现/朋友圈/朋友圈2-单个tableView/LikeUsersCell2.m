//
//  LikeUsersCell2.m
//  WeChat
//
//  Created by zhengwenming on 2017/9/23.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import "LikeUsersCell2.h"

@implementation LikeUsersCell2

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.backgroundColor = [UIColor clearColor];
    self.likeUsersLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.likeUsersLabel.numberOfLines = 0;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.likeUsersLabel.text = @"测试";
}

#pragma mark
#pragma mark cell左边缩进64，右边缩进10
-(void)setFrame:(CGRect)frame{
    frame.origin.x = 64;
    frame.size.width = kScreenWidth - 64-10;
    [super setFrame:frame];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
