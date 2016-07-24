/*!
 @header SearchResultViewController.h
 
 @abstract  作者Github地址：https://github.com/zhengwenming
            作者CSDN博客地址:http://blog.csdn.net/wenmingzheng
 
 @author   Created by zhengwenming on  16/3/11
 
 @version 1.00 16/3/11 Creation(版本信息)
 
   Copyright © 2016年 zhengwenming. All rights reserved.
 */

#import <UIKit/UIKit.h>

@protocol SearchResultSelectedDelegate <NSObject>

-(void)selectPersonWithUserId:(NSString *)userId userName:(NSString *)userName photo:(NSString *)photo phoneNO:(NSString *)phoneNO;


@end

@interface SearchResultViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating>

-(void)updateAddressBookData:(NSArray *)AddressBookDataArray;//得到数据
@property(nonatomic,weak)id<SearchResultSelectedDelegate>delegate;


@end
