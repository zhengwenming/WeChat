//
//  AddressBookCell.m
//  IHKApp
//
//  Created by 郑文明 on 15/4/23.
//  Copyright (c) 2015年 www.ihk.cn. All rights reserved.
//

#import "AddressBookCell.h"

@implementation AddressBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.photoIV.clipsToBounds = YES;
    self.photoIV.backgroundColor = [UIColor lightGrayColor];
    self.photoIV.layer.cornerRadius = 4;
    self.selectionStyle=UITableViewCellSelectionStyleNone;

}
-(void)setFrendModel:(FriendInfoModel *)frendModel{
    _frendModel = frendModel;
    

    self.nameLabel.text = frendModel.userName;
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:frendModel.photo] placeholderImage:[UIImage imageNamed:@"default_portrait"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
