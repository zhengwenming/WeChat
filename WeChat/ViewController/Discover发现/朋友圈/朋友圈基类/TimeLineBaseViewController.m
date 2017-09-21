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
@property(nonatomic,strong)NSDictionary *jsonDic;
@end

@implementation TimeLineBaseViewController
///本地的json测试数据
-(NSDictionary *)jsonDic{
    if (_jsonDic==nil) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"]]];
        _jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    }
    return _jsonDic;
}
#pragma mark
#pragma mark 从本地获取朋友圈1的测试数据
-(void)getTestData1{
        for (NSDictionary *eachDic in self.jsonDic[@"data"][@"rows"]) {
            MessageInfoModel1 *messageModel = [[MessageInfoModel1 alloc] initWithDic:eachDic];
            [self.dataSource addObject:messageModel];
    }
}
#pragma mark
#pragma mark 从本地获取朋友圈2的测试数据
-(void)getTestData2{
    for (NSDictionary *eachDic in self.jsonDic[@"data"][@"rows"]) {
        MessageInfoModel2 *messageModel = [[MessageInfoModel2 alloc] initWithDic:eachDic];
        [self.dataSource addObject:messageModel];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"朋友圈";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[[YYFPSLabel alloc]initWithFrame:CGRectMake(0, 5, 60, 30)]];
    [self.view addSubview:self.tableView];
    UIImageView * backgroundImageView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 260)];
    backgroundImageView.image = [UIImage imageNamed:@"background.jpeg"];
    self.tableView.tableHeaderView = backgroundImageView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).with.offset(-kNavbarHeight);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
