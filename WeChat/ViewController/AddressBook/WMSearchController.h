//
//  WMSearchController.h
//  WeChat
//
//  Created by zhengwenming on 2018/4/3.
//  Copyright © 2018年 zhengwenming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultViewController.h"


@interface WMSearchController : UISearchController
@property (nonatomic, assign) BOOL enableVoiceInput;

+ (WMSearchController *)searchController:(BaseViewController<WMSearchResultControllerProtocol> *)resultsController;


@end
