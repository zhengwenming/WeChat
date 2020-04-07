//
//  TimeLineBaseViewController.h
//  WeChat
//
//  Created by zhengwenming on 2017/9/18.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageInfoModel.h"
#import "WMPhotoBrowser.h"

@interface TimeLineBaseViewController : BaseViewController
@property(nonatomic,strong)NSMutableArray *dataSource;

#pragma mark
#pragma mark 从本地获取朋友圈的测试数据
-(void)getTestData;

@end
