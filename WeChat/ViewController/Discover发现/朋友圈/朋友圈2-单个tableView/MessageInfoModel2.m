//
//  MessageInfoModel2.m
//  WeChat
//
//  Created by zhengwenming on 2017/9/21.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import "MessageInfoModel2.h"

@implementation MessageInfoModel2

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
-(NSMutableArray *)likeUsers{
    if (_likeUsers==nil) {
        _likeUsers = [NSMutableArray array];
    }
    return _likeUsers;
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
        for (NSDictionary *friendInfoDic in dic[@"likeUsers"]) {
            [self.likeUsers addObject:[[FriendInfoModel alloc]initWithDic:friendInfoDic]];
        }
        self.photo              = dic[@"photo"];
        self.messageSmallPics   = dic[@"messageSmallPics"];
        self.messageBigPics     = dic[@"messageBigPics"];
        if (self.likeUsers.count) {
            [self.commentModelArray addObject:self.likeUsers];
        }
        for (NSDictionary *eachDic in dic[@"commentMessages"] ) {
            CommentInfoModel2 *commentModel = [[CommentInfoModel2 alloc] initWithDic:eachDic];
            [self.commentModelArray addObject:commentModel];
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
        
        self.textLayout.frameLayout = CGRectMake(kGAP+kAvatar_Size+kGAP, kGAP+kAvatar_Size/2+2, kScreenWidth-2*kGAP-kAvatar_Size-kGAP, textHeight);
        
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
        
        self.headerHeight = CGRectGetMaxY(self.jggLayout.frameLayout)+kGAP;
    }
    return self;
}

@end

