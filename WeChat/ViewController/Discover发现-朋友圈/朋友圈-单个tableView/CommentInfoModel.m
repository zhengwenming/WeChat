//
//  CommentInfoModel.m
//  WeChat
//
//  Created by zhengwenming on 2017/9/21.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import "CommentInfoModel.h"

@implementation CommentInfoModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.commentId          = dic[@"commentId"];
        self.commentUserId      = dic[@"commentUserId"];
        self.commentUserName    = dic[@"commentUserName"];
        self.commentPhoto       = dic[@"commentPhoto"];
        self.commentText        = dic[@"commentText"];
        self.commentByUserId    = dic[@"commentByUserId"];
        self.commentByUserName  = dic[@"commentByUserName"];
        self.commentByPhoto     = dic[@"commentByPhoto"];
        self.createDateStr      = dic[@"createDateStr"];
        self.checkStatus        = dic[@"checkStatus"];
        //开始提前计算rowHeight和attributedText
        NSString *str  = nil;
        if (![self.commentByUserName isEqualToString:@""]) {
            str= [NSString stringWithFormat:@"%@回复%@：%@",
                  self.commentUserName, self.commentByUserName, self.commentText];
        }else{
            str= [NSString stringWithFormat:@"%@：%@",
                  self.commentUserName, self.commentText];
        }
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
        [text addAttribute:NSForegroundColorAttributeName
                     value:[UIColor orangeColor]
                     range:NSMakeRange(0, self.commentUserName.length)];
        [text addAttribute:NSForegroundColorAttributeName
                     value:[UIColor orangeColor]
                     range:NSMakeRange(self.commentUserName.length + 2, self.commentByUserName.length)];
        UIFont *font = [UIFont systemFontOfSize:13.0];
        [text addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, str.length)];
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        if ([text.string isMoreThanOneLineWithSize:CGSizeMake(kScreenWidth - 2*kGAP-kAvatar_Size-10, CGFLOAT_MAX) font:font lineSpaceing:3.0]) {//margin
            style.lineSpacing = 3;
        }else{
            style.lineSpacing = CGFLOAT_MIN;
        }

        [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.string.length)];
        self.rowHeight = [text.string boundingRectWithSize:CGSizeMake(kScreenWidth - 2*kGAP-kAvatar_Size-10, CGFLOAT_MAX) font:font lineSpacing:3.0].height+0.5+3.0;//5.0为最后一行行间距
        self.attributedText = text;
    }
    return self;
}

- (NSMutableArray *)commentModelArray {
    if (_commentModelArray == nil) {
        _commentModelArray = [[NSMutableArray alloc] init];
    }
    return _commentModelArray;
}
-(NSMutableArray *)messageBigPics{
    if (_messageBigPicArray==nil) {
        _messageBigPicArray = [NSMutableArray array];
    }
    return _messageBigPicArray;
}

@end
