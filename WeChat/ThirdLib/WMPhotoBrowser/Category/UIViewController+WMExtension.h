//
//  UIViewController+WMExtension.h
//  WMPhotoBrowser
//
//  Created by zhengwenming on 2018/6/14.
//  Copyright © 2018年 zhengwenming. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^PopBlock)(UIBarButtonItem *backItem);

@interface UIViewController (WMExtension)
@property(nonatomic,copy)PopBlock popBlock;
@property (nonatomic, assign) BOOL isHideBackItem;
//右滑返回功能，默认开启（YES）
- (BOOL)fullScreenGestureShouldBegin;
/**
 返回按钮的图片名字，不重写此方法的时候默认为绿色图片名字
 
 @return 图片名字
 */
-(NSString *)backIconName;
@end

@interface UITabBarController (WMExtension)

@end

@interface UINavigationController (WMExtension)<UIGestureRecognizerDelegate>

@end

@interface UIAlertController (WMExtension)

@end
