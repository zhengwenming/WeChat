//
//  HomeViewController.m
//  WeChat
//
//  Created by zhengwenming on 16/6/5.
//  Copyright © 2016年 zhengwenming. All rights reserved.
//

#import "HomeViewController.h"
#import "ConversationModel.h"

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
    conversation1.avatar = @"http://weixintest.ihk.cn/ihkwx_upload/userPhoto/15914867203-1461920972642.jpg";
    conversation1.userName = @"文明";
    conversation1.text = @"你好！";
    
    [self.dataSource addObject:conversation1];
    
    self.homeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavbarHeight, self.view.frame.size.width, kScreenHeight-kNavbarHeight-kTabBarHeight) style:UITableViewStyleGrouped];
    self.homeTableView.dataSource = self;
    self.homeTableView.rowHeight = 60.f;
    self.homeTableView.delegate = self;
    self.homeTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.homeTableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    ConversationModel *conversation = self.dataSource[indexPath.row];
    
    cell.imageView.clipsToBounds = YES;
    cell.imageView.layer.cornerRadius = 3;    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:conversation.avatar] placeholderImage:[UIImage imageNamed:@"placeholder"]];

    cell.textLabel.text = conversation.userName;
    cell.detailTextLabel.text = conversation.text;
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
