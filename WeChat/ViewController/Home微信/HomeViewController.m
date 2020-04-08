//
//  HomeViewController.m
//  WeChat
//
//  Created by zhengwenming on 16/6/5.
//  Copyright © 2016年 zhengwenming. All rights reserved.
//

#import "HomeViewController.h"
#import "ConversationModel.h"
#import "ConversationListCell.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
}
@property(nonatomic,strong)UITableView *homeTableView;
@property(nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation HomeViewController
-(NSMutableArray *)dataSource{
    if (_dataSource==nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    ConversationModel *conversation1 = [ConversationModel new];
    conversation1.avatarURL = @"http://weixintest.ihk.cn/ihkwx_upload/userPhoto/15914867203-1461920972642.jpg";
    conversation1.userName = @"文明";
     conversation1.userId = @"274";
    conversation1.text = @"你好！在吗？";
    conversation1.time = @"昨天";
    [self.dataSource addObject:conversation1];
    
    ConversationModel *conversation2 = [ConversationModel new];
    conversation2.avatarURL = @"http://weixintest.ihk.cn/ihkwx_upload/userPhoto/18565061404-1448440129479.jpg";
    conversation2.userName = @"怕瓦落地";
     conversation2.userId = @"97";
    conversation2.text = @"大家好，我是怕瓦落地，很高兴认识大家。";
    conversation2.time = @"两天前";
    [self.dataSource addObject:conversation2];
    
    
    self.homeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavbarHeight, self.view.frame.size.width, kScreenHeight-kNavbarHeight-kTabBarHeight) style:UITableViewStyleGrouped];
    self.homeTableView.dataSource = self;
    self.homeTableView.rowHeight = 64.f;
    self.homeTableView.delegate = self;
    [self.homeTableView registerClass:NSClassFromString(@"ConversationListCell") forCellReuseIdentifier:@"ConversationListCell"];
    self.homeTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.homeTableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConversationListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConversationListCell" forIndexPath:indexPath];
    ConversationModel *conversation = self.dataSource[indexPath.row];
    cell.conversationModel = conversation;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
