//
//  LikeUsersCell1.m
//  WeChat
//
//  Created by zhengwenming on 2017/9/23.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import "LikeUsersCell1.h"
#import "FriendInfoModel.h"
#import "UILabel+TapAction.h"

@interface LikeUsersCell1 ()<TapActionDelegate>
@property(nonatomic,strong)NSMutableArray *likeUsersArray;

@property(nonatomic,strong)NSMutableArray *nameArray;
@end

@implementation LikeUsersCell1

-(NSMutableArray *)nameArray{
    if (_nameArray==nil) {
        _nameArray = [NSMutableArray array];
    }
    return _nameArray;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.likeUsersLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.likeUsersLabel.numberOfLines = 0;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}
- (void)configLikeUsersWithMessageModel:(MessageInfoModel1 *)messageModel{
    _likeUsersArray = messageModel.likeUsers.mutableCopy;
    NSMutableArray *rangesArray = [NSMutableArray array];
    NSMutableAttributedString *mutablAttrStr = [[NSMutableAttributedString alloc]init];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    attch.image = [UIImage imageNamed:@"Like"];
    attch.bounds = CGRectMake(0, -5, attch.image.size.width, attch.image.size.height);
    //创建带有图片的富文本
    [mutablAttrStr insertAttributedString:[NSAttributedString attributedStringWithAttachment:attch] atIndex:0];
    
    
    for (int i = 0; i < messageModel.likeUsers.count; i++) {
        FriendInfoModel *friendModel = messageModel.likeUsers[i];
        //name0,name1,name2,name1
        [mutablAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:friendModel.userName]];
        if ([self.nameArray containsObject:friendModel.userName]) {//如果前面有人和我重复名字了
            friendModel.range = NSMakeRange(mutablAttrStr.length-friendModel.userName.length, friendModel.userName.length);
        }else{
            friendModel.range = [mutablAttrStr.string rangeOfString:friendModel.userName];
        }
        if (i != messageModel.likeUsers.count - 1) {
            [mutablAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@","]];
            
        }
        [rangesArray addObject:[NSValue valueWithRange:friendModel.range]];
        [self.nameArray addObject:friendModel.userName];
    }
    
    [mutablAttrStr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.f]} range:NSMakeRange(0, mutablAttrStr.length)];
    
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 0;
    [mutablAttrStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, mutablAttrStr.length)];
    // 给指定文字添加颜色
    for (NSValue *aRangeValue in rangesArray) {
        [mutablAttrStr addAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]} range:aRangeValue.rangeValue];
    }
    
    
    
    self.likeUsersLabel.attributedText = mutablAttrStr;
    
    // 给指定文字添加点击事件,并设置代理,代理中监听点击
    [self.likeUsersLabel tapActionWithStrings:self.nameArray delegate:self];
}
- (void)tapReturnString:(NSString *)string
                  range:(NSRange)range
                  index:(NSInteger)index{
    FriendInfoModel *aModel = self.likeUsersArray[index];
    if (self.tapNameBlock) {
        self.tapNameBlock(aModel);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
