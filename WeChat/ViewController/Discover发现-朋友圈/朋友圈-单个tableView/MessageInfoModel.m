//
//  MessageInfoModel2.m
//  WeChat
//
//  Created by zhengwenming on 2017/9/21.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import "MessageInfoModel.h"



@implementation MessageInfoModel

-(NSMutableArray *)commentModelArray{
    if (_commentModelArray==nil) {
        _commentModelArray = [NSMutableArray array];
    }
    return _commentModelArray;
}

-(NSMutableArray *)messageSmallPics{
    if (_messageSmallPics==nil) {
        _messageSmallPics = [NSMutableArray array];
    }
    return _messageSmallPics;
}

-(NSMutableArray *)messageBigPics{
    if (_messageBigPics==nil) {
        _messageBigPics = [NSMutableArray array];
    }
    return _messageBigPics;
}
-(Layout *)textLayout{
    if (_textLayout==nil) {
        _textLayout = [Layout new];
    }
    return _textLayout;
}
-(Layout *)jggLayout{
    if (_jggLayout==nil) {
        _jggLayout = [Layout new];
    }
    return _jggLayout;
}
-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.cid                = dic[@"cid"];
        self.message_id         = dic[@"message_id"];
        self.message            = dic[@"message"];
        self.timeTag            = dic[@"timeTag"];
        self.message_type       = dic[@"message_type"];
        self.userId             = dic[@"userId"];
        self.userName           = dic[@"userName"];
        self.photo              = dic[@"photo"];
        self.messageSmallPics   = dic[@"messageSmallPics"];
        self.messageBigPics     = dic[@"messageBigPics"];
        
        NSMutableArray <FriendInfoModel *>*likeUsers = [NSMutableArray array];
        
        for (NSDictionary *friendInfoDic in dic[@"likeUsers"]) {
            [likeUsers addObject:[[FriendInfoModel alloc]initWithDic:friendInfoDic]];
        }
        if (likeUsers.count) {
            CommentInfoModel *infoModel = [CommentInfoModel new];
            infoModel.likeUsersArray = likeUsers.mutableCopy;
            //处理点赞人的attributeStr字符串
            NSMutableArray *rangesArray = [NSMutableArray array];
            NSMutableArray *nameArray = [NSMutableArray array];

            NSMutableAttributedString *mutablAttrStr = [[NSMutableAttributedString alloc]init];
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            //定义图片内容及位置和大小
            attch.image = [UIImage imageNamed:@"Like"];
            attch.bounds = CGRectMake(0, -5, attch.image.size.width, attch.image.size.height);
            //创建带有图片的富文本
            [mutablAttrStr insertAttributedString:[NSAttributedString attributedStringWithAttachment:attch] atIndex:0];
            
            
            for (int i = 0; i <likeUsers.count; i++) {
                FriendInfoModel *friendModel = likeUsers[i];
                //name0,name1,name2,name1
                [mutablAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:friendModel.userName]];
                if ([nameArray containsObject:friendModel.userName]) {//如果前面有人和我重复名字了
                    friendModel.range = NSMakeRange(mutablAttrStr.length-friendModel.userName.length, friendModel.userName.length);
                }else{
                    friendModel.range = [mutablAttrStr.string rangeOfString:friendModel.userName];
                }
                if (i != likeUsers.count - 1) {
                    [mutablAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@","]];
                    
                }
                [rangesArray addObject:[NSValue valueWithRange:friendModel.range]];
                [nameArray addObject:friendModel.userName];
            }
            UIFont *font = [UIFont systemFontOfSize:13.f];
            [mutablAttrStr addAttributes:@{NSFontAttributeName : font} range:NSMakeRange(0, mutablAttrStr.length)];
            
            
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineSpacing = 3.0;
            [mutablAttrStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, mutablAttrStr.length)];
            // 给指定文字添加颜色
            for (NSValue *aRangeValue in rangesArray) {
                [mutablAttrStr addAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]} range:aRangeValue.rangeValue];
            }
            infoModel.likeUsersAttributedText = mutablAttrStr;
            //算likeUser点赞人cell的rowHeight
            infoModel.rowHeight = [mutablAttrStr.string boundingRectWithSize:CGSizeMake(kScreenWidth-kGAP-kAvatar_Size-2*kGAP, CGFLOAT_MAX) font:font lineSpacing:3.0].height+0.5+8+5;
//            [self.commentModelArray addObject:infoModel];
        }
        //
        for (NSDictionary *eachDic in dic[@"commentMessages"] ) {
            [self.commentModelArray addObject:[[CommentInfoModel alloc] initWithDic:eachDic]];
        }
        
        NSMutableParagraphStyle *muStyle = [[NSMutableParagraphStyle alloc]init];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        muStyle.alignment = NSTextAlignmentLeft;//对齐方式
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.message];
        [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attrString.length)];
        [attrString addAttribute:NSParagraphStyleAttributeName value:muStyle range:NSMakeRange(0, attrString.length)];

        if ([attrString.string isMoreThanOneLineWithSize:CGSizeMake(kScreenWidth-kGAP-kAvatar_Size-2*kGAP, CGFLOAT_MAX) font:font lineSpaceing:3.0]) {//margin
            muStyle.lineSpacing = 3.0;//设置行间距离
        }else{
            muStyle.lineSpacing = CGFLOAT_MIN;//设置行间距离
        }

        
        self.mutablAttrStr = attrString;
        
        //算text的layout
        CGFloat textHeight = [attrString.string boundingRectWithSize:CGSizeMake(kScreenWidth-kGAP-kAvatar_Size-2*kGAP, CGFLOAT_MAX) font:font lineSpacing:3.0].height+0.5;
        
        self.textLayout.frameLayout = CGRectMake(kGAP+kAvatar_Size+kGAP, kGAP+kAvatar_Size/2+5, kScreenWidth-2*kGAP-kAvatar_Size-kGAP, textHeight);
        
        //算九宫格的layout

        CGFloat jgg_Width = kScreenWidth-2*kGAP-kAvatar_Size-50;
        CGFloat image_Width = (jgg_Width-2*kGAP)/3;
        CGFloat jgg_height = 0;
        if (self.messageSmallPics.count==0) {
            jgg_height = 0;
        }else if (self.messageSmallPics.count<=3) {
            jgg_height = image_Width;
        }else if (self.messageSmallPics.count>3&&self.messageSmallPics.count<=6){
            jgg_height = 2*image_Width+kGAP;
        }else  if (self.messageSmallPics.count>6&&self.messageSmallPics.count<=9){
            jgg_height = 3*image_Width+2*kGAP;
        }
        
        self.jggLayout.frameLayout =  CGRectMake(self.textLayout.frameLayout.origin.x, CGRectGetMaxY(self.textLayout.frameLayout)+kGAP, jgg_Width, jgg_height);
        
        self.headerHeight = CGRectGetMaxY(self.jggLayout.frameLayout)+((self.messageSmallPics.count==0)?0.f:kGAP);
    }
    return self;
}

@end

