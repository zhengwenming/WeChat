//
//  MessageCell.m
//  WeChat
//
//  Created by zhengwenming on 16/6/4.
//  Copyright © 2016年 zhengwenming. All rights reserved.
//

#import "MessageCell.h"
#import "MessageModel.h"
#import "WMPlayer.h"

@interface MessageCell () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) WMPlayer *wmplayer;
@property (nonatomic, strong) MessageModel *messageModel;

@property (nonatomic, strong) NSIndexPath *indexPath;
@end

@implementation MessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.headImageView = [[UIImageView alloc] init];
        self.headImageView.backgroundColor = [UIColor whiteColor];
        self.headImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.headImageView];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(kGAP);
            make.width.height.mas_equalTo(kAvatar_Size);
        }];
        //      self.headImageView.clipsToBounds = YES;
        //      self.headImageView.layer.cornerRadius = kAvatar_Size/2;
        // nameLabel
        self.nameLabel = [UILabel new];
        [self.contentView addSubview:self.nameLabel];
        self.nameLabel.textColor = [UIColor colorWithRed:(54/255.0) green:(71/255.0) blue:(121/255.0) alpha:0.9];
        self.nameLabel.preferredMaxLayoutWidth = screenWidth - kGAP-kAvatar_Size - 2*kGAP-kGAP;
        self.nameLabel.numberOfLines = 0;
//        self.nameLabel.displaysAsynchronously = YES;
        self.nameLabel.font = [UIFont systemFontOfSize:14.0];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImageView.mas_right).offset(10);
            make.top.mas_equalTo(self.headImageView);
            make.right.mas_equalTo(-kGAP);
        }];
        // desc
        self.descLabel = [UILabel new];
//        self.descLabel.displaysAsynchronously = YES;
        
        self.descLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UITapGestureRecognizer *tapText = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapText:)];
        [self.descLabel addGestureRecognizer:tapText];
        [self.contentView addSubview:self.descLabel];
        self.descLabel.preferredMaxLayoutWidth =screenWidth - kGAP-kAvatar_Size ;
        self.descLabel.numberOfLines = 0;
        self.descLabel.font = [UIFont systemFontOfSize:14.0];
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kGAP);
        }];
        
//

        self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.moreBtn setTitle:@"全文" forState:UIControlStateNormal];
        [self.moreBtn setTitle:@"收起" forState:UIControlStateSelected];
        [self.moreBtn setTitleColor:[UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.moreBtn setTitleColor:[UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0] forState:UIControlStateSelected];

        self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        self.moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.moreBtn.selected = NO;
        [self.moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.moreBtn];
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.descLabel);
            make.top.mas_equalTo(self.descLabel.mas_bottom);
        }];
        
        self.jggView = [JGGView new];
        [self.contentView addSubview:self.jggView];
        [self.jggView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.moreBtn);
            make.top.mas_equalTo(self.moreBtn.mas_bottom).offset(kGAP);
        }];
        
        
        
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
        [self.contentView addSubview:self.commentBtn];
        self.commentBtn.layer.cornerRadius = 24/2;
        [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.descLabel);
            make.top.mas_equalTo(self.jggView.mas_bottom).offset(kGAP);
            make.width.mas_equalTo(55);
            make.height.mas_equalTo(24);
        }];
        
        
        
        self.tableView = [[UITableView alloc] init];
        self.tableView.scrollEnabled = NO;
        [self.contentView addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.jggView);
            make.top.mas_equalTo(self.commentBtn.mas_bottom).offset(kGAP);
            make.right.mas_equalTo(-kGAP);
        }];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.hyb_lastViewInCell = self.tableView;
        self.hyb_bottomOffsetToCell = 0.0;
    }
    
    return self;
}
-(void)tapText:(UITapGestureRecognizer *)tap{
    if (self.TapTextBlock) {
        UILabel *descLabel = (UILabel *)tap.view;
        self.TapTextBlock(descLabel);
    }
}
-(void)moreAction:(UIButton *)sender{
//    sender.selected = !sender.selected;
    if (self.MoreBtnClickBlock) {
        self.MoreBtnClickBlock(sender,self.indexPath);
    }
}
-(void)commentAction:(UIButton *)sender{
    if (self.CommentBtnClickBlock) {
        self.CommentBtnClickBlock(sender,self.indexPath);
    }
}
- (void)configCellWithModel:(MessageModel *)model indexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    
    self.nameLabel.text = model.userName;
    
    
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        // Create attributed string.
//        NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc] initWithString:model.message];
//        NSMutableAttributedString *userNameText = [[NSMutableAttributedString alloc] initWithString:model.userName];
//        
//        messageText.yy_font = [UIFont systemFontOfSize:14.0];
//        userNameText.yy_font = [UIFont systemFontOfSize:17.0];
//
//        messageText.yy_color = [UIColor blackColor];
//        //        [text yy_setColor:[UIColor redColor] range:NSMakeRange(0, 4)];
//        messageText.yy_lineSpacing = 2;
////        userNameText.yy_lineSpacing = 0;
//
//        // Create text container
//        YYTextContainer *messageContainer = [YYTextContainer new];
//        YYTextContainer *userNameContainer = [YYTextContainer new];
//
//        messageContainer.size = CGSizeMake([UIScreen mainScreen].bounds.size.width - kGAP-kAvatar_Size - 2*kGAP, CGFLOAT_MAX);
//        userNameContainer.size = CGSizeMake([UIScreen mainScreen].bounds.size.width - kGAP-kAvatar_Size - 2*kGAP, CGFLOAT_MAX);
//
//        messageContainer.maximumNumberOfRows = 0;
//        userNameContainer.maximumNumberOfRows = 0;
//
//        // Generate a text layout.
//        YYTextLayout *messageLayout = [YYTextLayout layoutWithContainer:messageContainer text:messageText];
//        
//        YYTextLayout *userNameLayout = [YYTextLayout layoutWithContainer:messageContainer text:userNameText];
//
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.descLabel.size = messageLayout.textBoundingSize;
//            self.descLabel.textLayout = messageLayout;
//            
//            self.nameLabel.size = userNameLayout.textBoundingSize;
//            self.nameLabel.textLayout = userNameLayout;
//        });
//    });
    
    
    
    
    
    
    
    
    
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.messageModel = model;
    NSMutableParagraphStyle *muStyle = [[NSMutableParagraphStyle alloc]init];
    muStyle.lineSpacing = 3;//设置行间距离
    muStyle.alignment = NSTextAlignmentLeft;//对齐方式
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:model.message];
     [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, attrString.length)];//下划线

    [attrString addAttribute:NSParagraphStyleAttributeName value:muStyle range:NSMakeRange(0, attrString.length)];
    self.descLabel.attributedText = attrString;
    
    self.descLabel.highlightedTextColor = [UIColor redColor];//设置文本高亮显示颜色，与highlighted一起使用。
    self.descLabel.highlighted = YES; //高亮状态是否打开
    self.descLabel.enabled = YES;//设置文字内容是否可变
    self.descLabel.userInteractionEnabled = YES;//设置标签是否忽略或移除用户交互。默认为NO
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSParagraphStyleAttributeName:muStyle};

    CGFloat h = [model.message boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - kGAP-kAvatar_Size - 2*kGAP, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height+0.5;
    
    if (h<=60) {
        [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.descLabel);
            make.top.mas_equalTo(self.descLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
    }else{
        [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.descLabel);
            make.top.mas_equalTo(self.descLabel.mas_bottom);
        }];
    }
    
    if (model.isExpand) {//展开
        [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kGAP);
            make.height.mas_equalTo(h);
        }];
    }else{//闭合
        [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kGAP);
            make.height.mas_lessThanOrEqualTo(60);
        }];
    }
    self.moreBtn.selected = model.isExpand;

    
    CGFloat jjg_height = 0.0;
    CGFloat jjg_width = 0.0;
    if (model.messageBigPics.count>0&&model.messageBigPics.count<=3) {
        jjg_height = [JGGView imageHeight];
        jjg_width  = (model.messageBigPics.count)*([JGGView imageWidth]+kJGG_GAP)-kJGG_GAP;
    }else if (model.messageBigPics.count>3&&model.messageBigPics.count<=6){
        jjg_height = 2*([JGGView imageHeight]+kJGG_GAP)-kJGG_GAP;
        jjg_width  = 3*([JGGView imageWidth]+kJGG_GAP)-kJGG_GAP;
    }else  if (model.messageBigPics.count>6&&model.messageBigPics.count<=9){
        jjg_height = 3*([JGGView imageHeight]+kJGG_GAP)-kJGG_GAP;
        jjg_width  = 3*([JGGView imageWidth]+kJGG_GAP)-kJGG_GAP;
    }
    ///解决图片复用问题
    [self.jggView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    ///布局九宫格
    [self.jggView JGGView:self.jggView DataSource:model.messageBigPics completeBlock:^(NSInteger index, NSArray *dataSource,NSIndexPath *indexpath) {
        self.tapImageBlock(index,dataSource,self.indexPath);
    }];
    [self.jggView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.moreBtn);
        make.top.mas_equalTo(self.moreBtn.mas_bottom).offset(kJGG_GAP);
        make.size.mas_equalTo(CGSizeMake(jjg_width, jjg_height));
    }];
 
    CGFloat tableViewHeight = 0;
    for (CommentModel *commentModel in model.commentModelArray) {
        CGFloat cellHeight = [CommentCell hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
            CommentCell *cell = (CommentCell *)sourceCell;
            [cell configCellWithModel:commentModel];
        } cache:^NSDictionary *{
            return @{kHYBCacheUniqueKey : commentModel.commentId,
                     kHYBCacheStateKey : @"",
                     kHYBRecalculateForStateKey : @(YES)};
        }];
        tableViewHeight += cellHeight;
    }
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(tableViewHeight);
    }];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }else{
        NSLog(@"Cell 被复用了");
    }
    
    CommentModel *model = [self.messageModel.commentModelArray objectAtIndex:indexPath.row];
    [cell configCellWithModel:model];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageModel.commentModelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentModel *model = [self.messageModel.commentModelArray objectAtIndex:indexPath.row];
   CGFloat cell_height = [CommentCell hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
        CommentCell *cell = (CommentCell *)sourceCell;
        [cell configCellWithModel:model];
    } cache:^NSDictionary *{
         NSDictionary *cache = @{kHYBCacheUniqueKey : model.commentId,
                 kHYBCacheStateKey : @"",
                 kHYBRecalculateForStateKey : @(NO)};
//        model.shouldUpdateCache = NO;
        return cache;
                 }];
    return cell_height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CommentModel *commentModel = [self.messageModel.commentModelArray objectAtIndex:indexPath.row];
    CGFloat cell_height = [CommentCell hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
        CommentCell *cell = (CommentCell *)sourceCell;
        
       

        [cell configCellWithModel:commentModel];
    } cache:^NSDictionary *{
        NSDictionary *cache = @{kHYBCacheUniqueKey : commentModel.commentId,
                                kHYBCacheStateKey : @"",
                                kHYBRecalculateForStateKey : @(NO)};
        //        model.shouldUpdateCache = NO;
        return cache;
    }];
   
    
    if ([self.delegate respondsToSelector:@selector(passCellHeightWithMessageModel:commentModel:atCommentIndexPath:cellHeight:commentCell:messageCell:)]) {
        self.messageModel.shouldUpdateCache = YES;
        CommentCell *commetCell =  (CommentCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self.delegate passCellHeightWithMessageModel:_messageModel commentModel:commentModel atCommentIndexPath:indexPath cellHeight:cell_height commentCell:commetCell messageCell:self];
    }
    
}

@end
