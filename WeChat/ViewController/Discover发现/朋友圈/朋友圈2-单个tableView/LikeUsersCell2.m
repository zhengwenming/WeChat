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
    UIImage *image = [UIImage imageNamed:@"LikeCmtBg"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    self.backgroundView = [[UIImageView alloc]initWithImage:image];
//    self.backgroundColor = [UIColor colorWithRed:236.0/256.0 green:236.0/256.0 blue:236.0/256.0 alpha:1.0];

    self.likeUsersLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.likeUsersLabel.numberOfLines = 0;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setModel:(CommentInfoModel2 *)model{
    _model = model;
    self.likeUsersLabel.attributedText = model.likeUsersAttributedText;
}
#pragma mark
#pragma mark cell左边缩进leftSpace，右边缩进10
-(void)setFrame:(CGRect)frame{
    CGFloat leftSpace = 2*kGAP+kAvatar_Size;
    frame.origin.x = leftSpace;
    frame.size.width = kScreenWidth - leftSpace -10;
    [super setFrame:frame];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
