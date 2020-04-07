//
//  TimeLineBaseViewController.m
//  WeChat
//
//  Created by zhengwenming on 2017/9/18.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import "TimeLineBaseViewController.h"

@implementation TimeLineBaseViewController
-(NSMutableArray *)dataSource{
    if (_dataSource==nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(void)getTestData{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"]]];
   NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    for (NSDictionary *eachDic in jsonDic[@"data"][@"rows"]) {
        MessageInfoModel *messageModel = [[MessageInfoModel alloc] initWithDic:eachDic];
        [self.dataSource addObject:messageModel];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"朋友圈";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[[YYFPSLabel alloc]initWithFrame:CGRectMake(0, 5, 60, 30)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
