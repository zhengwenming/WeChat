//
//  MorePannel.h
//  FaceKeyboard

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by ruofei on 16/3/31.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MoreItem;
@class MorePanel;
@protocol MorePannelDelegate <NSObject>

@optional
- (void)morePannel:(MorePanel *)morePannel didSelectItemIndex:(NSInteger)index;

@end

@interface MorePanel : UIView

@property (nonatomic, weak) id<MorePannelDelegate> delegate;

+ (instancetype)morePannel;

- (void)loadMoreItems:(NSArray<MoreItem *> *)items;

@end
