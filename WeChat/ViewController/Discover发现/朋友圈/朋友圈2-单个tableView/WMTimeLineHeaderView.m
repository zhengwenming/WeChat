//
//  WMTimeLineHeaderView.m
//  WeChat
//
//  Created by zhengwenming on 2017/9/18.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import "WMTimeLineHeaderView.h"

@interface WMTimeLineHeaderView (){
    CGFloat commentBtnWidth;
    CGFloat commentBtnHeight;
    CGFloat MaxLabelHeight;
}
@property(nonatomic,retain)UILabel *sepLine;
@property(nonatomic,retain)UIImageView *avatarIV;
@property(nonatomic,retain)UILabel *userNameLabel;
@property(nonatomic,retain)UILabel *timeStampLabel;
@property(nonatomic,retain)YYLabel *messageTextLabel;
@property(nonatomic,retain)UIButton *commentBtn;
@property(nonatomic,retain)UIButton *moreBtn;
@property(nonatomic,assign)BOOL isExpandNow;
@property(nonatomic,assign)NSInteger headerSection;


@property(nonatomic,retain)JGGView *jggView;

@property(nonatomic,retain)MessageInfoModel2 *model;

/**
 *  TapBlcok
 */
@property (nonatomic, copy)TapBlcok  tapBlock;
/**
 *  评论按钮的block
 */
@property (nonatomic, copy)void(^CommentBtnClickBlock)(UIButton *commentBtn,NSInteger headerSection);

/**
 *  更多按钮的block
 */
@property (nonatomic, copy)void(^MoreBtnClickBlock)(UIButton *moreBtn,BOOL isExpand);
/**
 *  九宫格
 */
@property(nonatomic,retain)UIView *JGGView;


@end

@implementation WMTimeLineHeaderView

/**
 *  self
 *
 *  @param reuseIdentifier 复用标示。一定要用这个初始化方法，HeaderView才会复用
 *
 *  @return
 */
- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.sepLine = [[UILabel alloc]init];
        self.sepLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.sepLine];
        
        
        self.avatarIV = [[UIImageView alloc]init];
        [self addSubview:self.avatarIV];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.userNameLabel = [[UILabel alloc]init];
        self.userNameLabel.font = [UIFont systemFontOfSize:14.0];
        self.userNameLabel.textColor = [UIColor orangeColor];
        [self addSubview:self.userNameLabel];
        
        self.timeStampLabel = [[UILabel alloc]init];
        self.timeStampLabel.font = [UIFont systemFontOfSize:12.0];
        self.timeStampLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:self.timeStampLabel];
        
        self.messageTextLabel = [[YYLabel alloc]init];
        self.messageTextLabel.clipsToBounds = YES;
        
        self.messageTextLabel.backgroundColor = [UIColor magentaColor];
        self.messageTextLabel.displaysAsynchronously = YES;
        self.messageTextLabel.numberOfLines = 0;
        self.messageTextLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:self.messageTextLabel];
        
        commentBtnWidth = 60;
        commentBtnHeight = 22;
        MaxLabelHeight = 75.0;
        self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.commentBtn.backgroundColor = [UIColor whiteColor];
        [self.commentBtn setTitle:@"评论" forState:UIControlStateNormal];
        [self.commentBtn setTitle:@"评论" forState:UIControlStateSelected];
        [self.commentBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.commentBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.commentBtn.layer.borderWidth = 1;
        self.commentBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [self.commentBtn setImage:[UIImage imageNamed:@"commentBtn"] forState:UIControlStateNormal];
        [self.commentBtn setImage:[UIImage imageNamed:@"commentBtn"] forState:UIControlStateSelected];
        
        [self.commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.commentBtn];
        
        
        self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.moreBtn setTitle:@"全文" forState:UIControlStateNormal];
        [self.moreBtn setTitle:@"收起" forState:UIControlStateSelected];
        [self.moreBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        self.moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [self.moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.moreBtn];
        self.isExpandNow = NO;
    }
    return self;
}
-(void)commentAction:(UIButton *)sender{
    if (self.CommentBtnClickBlock) {
        self.CommentBtnClickBlock(sender,self.headerSection);
    }
}
-(void)moreAction:(UIButton *)sender{
    if (self.MoreBtnClickBlock) {
        self.MoreBtnClickBlock(sender,_isExpandNow);
    }
}
-(void)setModel:(MessageInfoModel2 *)model{

}
@end
