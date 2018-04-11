/*!
 @header SearchResultViewController.h
 
 @abstract  作者Github地址：https://github.com/zhengwenming
            作者CSDN博客地址:http://blog.csdn.net/wenmingzheng
 
 @author   Created by zhengwenming on  16/3/11
 
 @version 1.00 16/3/11 Creation(版本信息)
 
   Copyright © 2016年 zhengwenming. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "FriendInfoModel.h"



@protocol WMSearchResultControllerProtocol <UISearchResultsUpdating, UISearchBarDelegate>

- (void)setItemClickAction:(void (^)(__kindof UIViewController *searchResultVC, id data))itemClickAction;

@end



@interface SearchResultViewController : BaseViewController<WMSearchResultControllerProtocol>

@property (nonatomic, copy) void (^itemSelectedAction)(SearchResultViewController *searchResultVC, FriendInfoModel *userModel);


@end
