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
    }
    return self;
}

@end

