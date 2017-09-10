//
//  LikeUsersCell.m
//  WeChat
//
//  Created by zhengwenming on 2017/9/10.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import "LikeUsersCell.h"

@implementation LikeUsersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.likeUsersLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}
- (void)configCellWithLikeUsers:(NSArray *)likeUsers {
    NSString *allString = @"";
    for (NSString *name in likeUsers) {
        allString = [NSString stringWithFormat:@"%@,%@",allString,name];
    }
    self.likeUsersLabel.text = [allString substringFromIndex:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
