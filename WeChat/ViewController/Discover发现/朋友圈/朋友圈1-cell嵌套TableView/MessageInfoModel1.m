//
//  MessageInfoModel1.m
//  WeChat
//
//  Created by zhengwenming on 2017/9/21.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import "MessageInfoModel1.h"

@implementation MessageInfoModel1
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

-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.cid                = dic[@"cid"];
        self.shouldUpdateCache  = NO;
        self.message_id         = dic[@"message_id"];
        self.message            = dic[@"message"];
        self.timeTag            = dic[@"timeTag"];
        self.message_type       = dic[@"message_type"];
        self.userId             = dic[@"userId"];
        self.userName           = dic[@"userName"];
        for (NSDictionary *friendInfoDic in dic[@"likeUsers"]) {
            [self.likeUsers addObject:[[FriendInfoModel alloc]initWithDic:friendInfoDic]];
        }
        
        if (self.likeUsers.count) {
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13.0]};
            NSMutableAttributedString *mutablAttrStr = [[NSMutableAttributedString alloc]init];
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            //定义图片内容及位置和大小
            attch.image = [UIImage imageNamed:@"Like"];
            attch.bounds = CGRectMake(0, -5, attch.image.size.width, attch.image.size.height);
            [mutablAttrStr insertAttributedString:[NSAttributedString attributedStringWithAttachment:attch] atIndex:0];
            for (int i = 0; i < self.likeUsers.count; i++) {
                FriendInfoModel *friendModel = self.likeUsers[i];
                [mutablAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:friendModel.userName]];
                if (i != self.likeUsers.count - 1) {
                    [mutablAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@","]];
                    
                }
            }
            [mutablAttrStr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.f]} range:NSMakeRange(0, mutablAttrStr.length)];
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineSpacing = 0;
            [mutablAttrStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, mutablAttrStr.length)];
            self.commentNameTotalHeihgt = [mutablAttrStr.string boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - kGAP-kAvatar_Size - 2*kGAP, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height+5;
        }else{
            self.commentNameTotalHeihgt  = 0;
        }
        self.photo              = dic[@"photo"];
        self.messageSmallPics   = dic[@"messageSmallPics"];
        self.messageBigPics     = dic[@"messageBigPics"];
        if (self.likeUsers.count) {
            [self.commentModelArray addObject:self.likeUsers];
        }
        for (NSDictionary *eachDic in dic[@"commentMessages"] ) {
            CommentInfoModel1 *commentModel = [[CommentInfoModel1 alloc] initWithDic:eachDic];
            [self.commentModelArray addObject:commentModel];
        }
    }
    return self;
}

@end

