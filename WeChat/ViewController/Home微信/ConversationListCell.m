//
//  ConversationListCell.m
//  WeChat
//
//  Created by apple on 2020/4/8.
//  Copyright © 2020 zhengwenming. All rights reserved.
//

#import "ConversationListCell.h"

@interface ConversationListCell ()
@property(nonatomic,strong)UIImageView *avatarIV;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *lastMsgLabel;
@property(nonatomic,strong)UILabel *lastMsgTimeLabel;
@property(nonatomic,strong)UILabel *tipLabel;
@property(nonatomic,strong)UILabel *unReadBadge;
@property(nonatomic,strong)UIView  *line;


@end

@implementation ConversationListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.avatarIV = [[UIImageView alloc] init];
        self.avatarIV.layer.cornerRadius = 3;
        self.avatarIV.clipsToBounds = YES;
        [self.contentView addSubview:self.avatarIV];
        [self.avatarIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(15);
            make.top.mas_equalTo(12);
            make.bottom.mas_equalTo(-12);
        }];
        [self.avatarIV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.avatarIV.mas_height);
        }];
        
        
        self.lastMsgTimeLabel = [[UILabel alloc] init];
        self.lastMsgTimeLabel.textColor = [UIColor colorWithRed:160.f/256.f green:160.f/256.f blue:160.f/256.f alpha:1.0];
        self.lastMsgTimeLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:self.lastMsgTimeLabel];
        [self.lastMsgTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(12);
            make.right.mas_equalTo(self.contentView).offset(-10);
        }];
        
        [self.lastMsgTimeLabel setContentCompressionResistancePriority:300 forAxis:UILayoutConstraintAxisHorizontal];

        //会话名字或者群名字or人名
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.font = [UIFont systemFontOfSize:17.0f];
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.avatarIV.mas_right).offset(10);
            make.top.mas_equalTo(self.avatarIV).offset(1.5);
            make.right.mas_lessThanOrEqualTo(self.lastMsgTimeLabel.mas_left).mas_offset(-5);
        }];
        [self.nameLabel setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisHorizontal];
        
        //最后一条消息的具体内容
        self.lastMsgLabel = [[UILabel alloc] init];
        self.lastMsgLabel.textColor = [UIColor lightGrayColor];
        self.lastMsgLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.contentView addSubview:self.lastMsgLabel];
        [self.lastMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(4);
            make.left.mas_equalTo(self.nameLabel);
            make.right.mas_lessThanOrEqualTo(self.contentView);
        }];
        [self.lastMsgLabel setContentCompressionResistancePriority:110 forAxis:UILayoutConstraintAxisHorizontal];

        self.line = [UIView new];
        self.line.backgroundColor = [UIColor lightGrayColor];
        self.line.alpha = 0.65;
        [self.contentView addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.mas_equalTo(self.contentView.mas_bottom).mas_offset(-1);
            make.left.mas_equalTo(self.lastMsgLabel);
            make.height.mas_equalTo(1.0/(UIScreen.mainScreen.scale));
            make.right.mas_equalTo(self.contentView);
        }];
    }
    return self;
}
-(void)setConversationModel:(ConversationModel *)conversationModel{
    _conversationModel = conversationModel;
    [self.avatarIV sd_setImageWithURL:[NSURL URLWithString:conversationModel.avatarURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.nameLabel.text = conversationModel.userName;
    self.lastMsgLabel.text = conversationModel.text;
    self.lastMsgTimeLabel.text = conversationModel.time;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
