//
//  DiscoverViewController.h
//  WeChat
//
//  Created by zhengwenming on 16/6/5.
//  Copyright © 2016年 zhengwenming. All rights reserved.
//

#import "BaseViewController.h"
#import "WCTimeLineViewController.h"

@interface DiscoverViewController : BaseViewController
///强引用commentVC，做到像微信朋友圈一样，再次进入朋友圈依然显示上次浏览的位置
@property(nonatomic,strong)WCTimeLineViewController *timeLineVC;
@end
