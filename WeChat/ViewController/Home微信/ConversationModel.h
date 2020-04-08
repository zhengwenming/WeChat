//
//  ConversationModel.h
//  WeChat
//
//  Created by apple on 2020/4/8.
//  Copyright © 2020 zhengwenming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConversationModel : NSObject
@property(nonatomic,copy)NSString *avatarURL;

@property(nonatomic,copy)NSString *userId;

@property(nonatomic,copy)NSString *userName;

@property(nonatomic,copy)NSString *text;

@property(nonatomic,copy)NSString *time;

@property(nonatomic,copy)NSString *extra;



@end

NS_ASSUME_NONNULL_END
