//
//  TimeLineBaseViewController.h
//  WeChat
//
//  Created by zhengwenming on 2017/9/18.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageInfoModel1.h"
#import "MessageInfoModel2.h"
#import "WMPhotoBrowser.h"

@interface TimeLineBaseViewController : BaseViewController
#pragma mark
#pragma mark 从本地获取朋友圈1的测试数据
-(void)getTestData1;
#pragma mark
#pragma mark 从本地获取朋友圈2的测试数据
-(void)getTestData2;

@end
