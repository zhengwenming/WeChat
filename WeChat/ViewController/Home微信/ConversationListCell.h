//
//  ConversationListCell.h
//  WeChat
//
//  Created by apple on 2020/4/8.
//  Copyright © 2020 zhengwenming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConversationListCell : UITableViewCell

@property(nonatomic,retain)ConversationModel *conversationModel;

@end

NS_ASSUME_NONNULL_END
