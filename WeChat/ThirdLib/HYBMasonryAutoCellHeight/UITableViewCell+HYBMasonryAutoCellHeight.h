//
//  UITableViewCell+HYBMasonryAutoCellHeight.h
//  CellAutoHeightDemo
//
//  Created by huangyibiao on 15/9/1.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableView+HYBCacheHeight.h"

/**
 * 获取高度前会回调，需要在此BLOCK中配置数据，才能正确地获取高度
 */
typedef void(^HYBCellBlock)(UITableViewCell *sourceCell);

typedef NSDictionary *(^HYBCacheHeight)();

/**
 *	@author 黄仪标, 16-01-22 21:01:09
 *
 *	唯一键，通常是数据模型的id，保证唯一
 */
FOUNDATION_EXTERN NSString *const kHYBCacheUniqueKey;

/**
 *	@author 黄仪标, 16-01-22 21:01:57
 *
 *	对于同一个model，如果有不同状态，而且不同状态下高度不一样，那么也需要指定
 */
FOUNDATION_EXTERN NSString *const kHYBCacheStateKey;

/**
 *	@author 黄仪标, 16-01-22 21:01:47
 *
 *	用于指定更新某种状态的缓存，比如当评论时，增加了一条评论，此时该状态的高度若已经缓存过，则需要指定来更新缓存
 */
FOUNDATION_EXTERN NSString *const kHYBRecalculateForStateKey;

/**
 *  基于Masonry自动布局实现的自动计算cell的行高扩展
 *
 *  @author huangyibiao
 *  @email  huangyibiao520@163.com
 *  @github https://github.com/CoderJackyHuang
 *  @blog   http://www.henishuo.com/masonry-cell-height-auto-calculate/
 *
 *  @note Make friends with me：
 *        QQ:(632840804)
 *        Please tell me your real name when you send message to me.3Q.
 */
@interface UITableViewCell (HYBMasonryAutoCellHeight)


/************************************************************************
 *
 * @note UI布局必须放在UITableViewCell的初始化方法中：
 *
 * - initWithStyle:reuseIdentifier:
 *
 * 且必须指定hyb_lastViewInCell才能生效
 ************************************************************************/

/**
 * 必传设置的属性，也就是在cell中的contentView内最后一个视图，用于计算行高
 * 例如，创建了一个按钮button作为在cell中放到最后一个位置，则设置为：self.hyb_lastVieInCell = button;
 * 即可。
 * 默认为nil，如果在计算时，值为nil，会crash
 */
@property (nonatomic, strong) UIView *hyb_lastViewInCell;

/**
 * 可选设置的属性，默认为0，表示指定的hyb_lastViewInCell到cell的bottom的距离
 * 默认为0.0
 */
@property (nonatomic, assign) CGFloat hyb_bottomOffsetToCell;

/**
 * 通过此方法来计算行高，需要在config中调用配置数据的API
 *
 * @param tableView 必传，为哪个tableView缓存行高
 * @param config     必须要实现，且需要调用配置数据的API
 *
 * @return 计算的行高
 */
+ (CGFloat)hyb_heightForTableView:(UITableView *)tableView config:(HYBCellBlock)config;

/**
 *	@author 黄仪标, 16-01-22 23:01:56
 *
 *	此API会缓存行高
 *
 *	@param tableView 必传，为哪个tableView缓存行高
 *	@param config 必须要实现，且需要调用配置数据的API
 *	@param cache  返回相关key
 *
 *	@return 行高
 */
+ (CGFloat)hyb_heightForTableView:(UITableView *)tableView
                           config:(HYBCellBlock)config
                            cache:(HYBCacheHeight)cache;

@end
