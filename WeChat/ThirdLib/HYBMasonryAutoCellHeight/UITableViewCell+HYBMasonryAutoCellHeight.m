//
//  UITableViewCell+HYBMasonryAutoCellHeight.m
//  CellAutoHeightDemo
//
//  Created by huangyibiao on 15/9/1.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#import <objc/runtime.h>
#import "UITableView+HYBCacheHeight.h"

NSString *const kHYBCacheUniqueKey = @"kHYBCacheUniqueKey";
NSString *const kHYBCacheStateKey = @"kHYBCacheStateKey";
NSString *const kHYBRecalculateForStateKey = @"kHYBRecalculateForStateKey";
NSString *const kHYBCacheForTableViewKey = @"kHYBCacheForTableViewKey";

const void *s_hyb_lastViewInCellKey = "hyb_lastViewInCellKey";
const void *s_hyb_bottomOffsetToCellKey = "hyb_bottomOffsetToCellKey";

@implementation UITableViewCell (HYBMasonryAutoCellHeight)

#pragma mark - Public
+ (CGFloat)hyb_heightForTableView:(UITableView *)tableView config:(HYBCellBlock)config {
  UITableViewCell *cell = [tableView.hyb_reuseCells objectForKey:[[self class] description]];
  
  if (cell == nil) {
    cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault
                       reuseIdentifier:nil];
    [tableView.hyb_reuseCells setObject:cell forKey:[[self class] description]];
  }
  
  if (config) {
    config(cell);
  }
  
  return [cell private_hyb_heightForTableView:tableView];
}

+ (CGFloat)hyb_heightForTableView:(UITableView *)tableView
                           config:(HYBCellBlock)config
                            cache:(HYBCacheHeight)cache {
  if (cache) {
    NSDictionary *cacheKeys = cache();
    NSString *key = cacheKeys[kHYBCacheUniqueKey];
    NSString *stateKey = cacheKeys[kHYBCacheStateKey];
    NSString *shouldUpdate = cacheKeys[kHYBRecalculateForStateKey];
    
    NSMutableDictionary *stateDict = tableView.hyb_cacheCellHeightDict[key];
    NSString *cacheHeight = stateDict[stateKey];
 
    if (tableView == nil
        || tableView.hyb_cacheCellHeightDict.count == 0
        || shouldUpdate.boolValue
        || cacheHeight == nil) {
      CGFloat height = [self hyb_heightForTableView:tableView config:config];
      
      if (stateDict == nil) {
        stateDict = [[NSMutableDictionary alloc] init];
        tableView.hyb_cacheCellHeightDict[key] = stateDict;
      }
      
      [stateDict setObject:[NSString stringWithFormat:@"%lf", height] forKey:stateKey];
      
      return height;
    } else if (tableView.hyb_cacheCellHeightDict.count != 0
               && cacheHeight != nil
               && cacheHeight.integerValue != 0) {
      return cacheHeight.floatValue;
    }
  }
  
  return [self hyb_heightForTableView:tableView config:config];
}

- (void)setHyb_lastViewInCell:(UIView *)hyb_lastViewInCell {
  objc_setAssociatedObject(self,
                           s_hyb_lastViewInCellKey,
                           hyb_lastViewInCell,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)hyb_lastViewInCell {
  return objc_getAssociatedObject(self, s_hyb_lastViewInCellKey);
}

- (void)setHyb_bottomOffsetToCell:(CGFloat)hyb_bottomOffsetToCell {
  objc_setAssociatedObject(self,
                           s_hyb_bottomOffsetToCellKey,
                           @(hyb_bottomOffsetToCell),
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)hyb_bottomOffsetToCell {
  NSNumber *valueObject = objc_getAssociatedObject(self, s_hyb_bottomOffsetToCellKey);
  
  if ([valueObject respondsToSelector:@selector(floatValue)]) {
    return valueObject.floatValue;
  }
  
  return 0.0;
}

#pragma mark - Private
- (CGFloat)private_hyb_heightForTableView:(UITableView *)tableView {
  NSAssert(self.hyb_lastViewInCell != nil, @"您未指定cell排列中最后一个视图对象，无法计算cell的高度");
  
  [self layoutIfNeeded];
  
  CGFloat rowHeight = self.hyb_lastViewInCell.frame.size.height + self.hyb_lastViewInCell.frame.origin.y;
  rowHeight += self.hyb_bottomOffsetToCell;
  
  return rowHeight;
}



@end
