//
//  LikeUsersCell.m
//  WeChat
//
//  Created by zhengwenming on 2017/9/10.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import "LikeUsersCell.h"
#import "FriendModel.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "MessageModel.h"


@interface LikeUsersCell ()<YBAttributeTapActionDelegate>
@property(nonatomic,strong)NSMutableArray *likeUsersArray;

@property(nonatomic,strong)NSMutableArray *nameArray;
@end

@implementation LikeUsersCell
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
    self.likeUsersLabel.userInteractionEnabled = YES;
    self.likeUsersLabel.numberOfLines = 0;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}
- (void)configCellLikeUsersWithMessageModel:(MessageModel *)messageModel{
    _likeUsersArray = messageModel.likeUsers.mutableCopy;
    NSMutableArray *rangesArray = [NSMutableArray array];
    NSMutableAttributedString *mutablAttrStr = [[NSMutableAttributedString alloc]init];
    for (int i = 0; i < messageModel.likeUsers.count; i++) {
        FriendModel *friendModel = messageModel.likeUsers[i];
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

    
    
    
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    attch.image = [UIImage imageNamed:@"Like"];
    attch.bounds = CGRectMake(0, -5, attch.image.size.width, attch.image.size.height);
    
    [mutablAttrStr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.f]} range:NSMakeRange(0, mutablAttrStr.length)];
    
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    
    //    style.lineSpacing = 0;
    
    [mutablAttrStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, mutablAttrStr.length)];
    
    
    
    // 给指定文字添加颜色
    
    for (NSValue *aRangeValue in rangesArray) {
        [mutablAttrStr addAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]} range:aRangeValue.rangeValue];
    }
    
    //创建带有图片的富文本
    [mutablAttrStr insertAttributedString:[NSAttributedString attributedStringWithAttachment:attch] atIndex:0];
    
    self.likeUsersLabel.attributedText = mutablAttrStr;
    
    // 给指定文字添加点击事件,并设置代理,代理中监听点击
    [self.likeUsersLabel yb_addAttributeTapActionWithStrings:self.nameArray delegate:self];
}

- (void)yb_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index

{
    FriendModel *aModel = self.likeUsersArray[index];
    
    if (self.tapNameBlock) {
        self.tapNameBlock(aModel);
    }
    NSRange r = NSMakeRange(range.location-1, range.length);
    
    NSLog(@"userId == %@",aModel.userId);
    NSLog(@"string == %@",string);
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
