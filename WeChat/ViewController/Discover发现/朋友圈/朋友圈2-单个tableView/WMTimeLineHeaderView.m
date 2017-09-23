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
@property(nonatomic,strong)CopyAbleLabel *messageTextLabel;
@property(nonatomic,retain)UIButton *commentBtn;
@property(nonatomic,retain)UIButton *moreBtn;
@property(nonatomic,assign)BOOL isExpandNow;
@property(nonatomic,assign)NSInteger headerSection;
@property(nonatomic,strong)JGGView *jggView;


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
        
        self.contentView.backgroundColor = [UIColor whiteColor];

        self.sepLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1.0 / YYScreenScale())];
        self.sepLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.sepLine];
        
        
        self.avatarIV = [[UIImageView alloc]initWithFrame:CGRectMake(kGAP, kGAP, kAvatar_Size, kAvatar_Size)];
        [self addSubview:self.avatarIV];
        self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarIV.frame)+kGAP, kGAP,kScreenWidth-kAvatar_Size-2*kGAP-kGAP, self.avatarIV.frame.size.height/2)];
        self.userNameLabel.font = [UIFont systemFontOfSize:14.0];
        self.userNameLabel.textColor = [UIColor colorWithRed:(54/255.0) green:(71/255.0) blue:(121/255.0) alpha:0.9];

        [self addSubview:self.userNameLabel];
        
        self.timeStampLabel = [[UILabel alloc]init];
        self.timeStampLabel.font = [UIFont systemFontOfSize:12.0];
        self.timeStampLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:self.timeStampLabel];
        
        self.messageTextLabel = [[CopyAbleLabel alloc]init];
        self.messageTextLabel.backgroundColor = [UIColor whiteColor];
        self.messageTextLabel.numberOfLines = 0;
        self.messageTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
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
        self.jggView = [[JGGView alloc] init];
        [self addSubview:self.jggView];
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
    [self.avatarIV sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.userNameLabel.text = model.userName;
    self.messageTextLabel.attributedText = model.mutablAttrStr;
    self.messageTextLabel.frame = model.textLayout.frameLayout;
    ///解决图片复用问题
    [self.jggView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.jggView.dataSource = model.messageSmallPics;
    self.jggView.frame = model.jggLayout.frameLayout;
}
@end
