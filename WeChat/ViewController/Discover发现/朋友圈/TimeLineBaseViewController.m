//
//  TimeLineBaseViewController.m
//  WeChat
//
//  Created by zhengwenming on 2017/9/18.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//


//-----------------------此类为朋友圈基类-------------------------

#import "TimeLineBaseViewController.h"

@interface TimeLineBaseViewController ()

@end

@implementation TimeLineBaseViewController
#pragma mark
#pragma mark 从本地获取测试数据
-(void)getTimeLineTestData{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"]]];
    NSDictionary *JSONDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    for (NSDictionary *eachDic in JSONDic[@"data"][@"rows"]) {
        MessageModel *messageModel = [[MessageModel alloc] initWithDic:eachDic];
        [self.dataSource addObject:messageModel];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"朋友圈";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[[YYFPSLabel alloc]initWithFrame:CGRectMake(0, 5, 60, 30)]];
    [self getTimeLineTestData];    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).with.offset(-kNavbarHeight);
    }];
    
    UIImageView * backgroundImageView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 260)];
    backgroundImageView.image = [UIImage imageNamed:@"background.jpeg"];
    self.tableView.tableHeaderView = backgroundImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
