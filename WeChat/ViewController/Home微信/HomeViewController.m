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
#import "FriendInfoModel.h"
#import "ConversationViewController.h"

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
    NSData *friendsData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"AddressBook" ofType:@"json"]]];
    NSDictionary *JSONDic = [NSJSONSerialization JSONObjectWithData:friendsData options:NSJSONReadingAllowFragments error:nil];
    for (NSDictionary *eachDic in JSONDic[@"friends"][@"row"]) {
        FriendInfoModel *fModel =  [[FriendInfoModel alloc]initWithDic:eachDic];
        ConversationModel *conversation = [ConversationModel new];
        conversation.avatarURL = fModel.photo;
        conversation.userName = fModel.userName;
        conversation.userId = fModel.userId;
        conversation.text = @"大家好，我是怕瓦落地，很高兴认识大家。";
        conversation.text = [NSString stringWithFormat:@"大家好，我是%@，很高兴认识大家",fModel.userName];
        conversation.time = @"两天前";
        [self.dataSource addObject:conversation];
    }
    
    self.homeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavbarHeight, self.view.frame.size.width, kScreenHeight-kNavbarHeight-kTabBarHeight) style:UITableViewStyleGrouped];
    self.homeTableView.dataSource = self;
    self.homeTableView.rowHeight = 66.f;
    self.homeTableView.delegate = self;
    self.homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ConversationModel *conversationModel = self.dataSource[indexPath.row];
    ConversationViewController *conversationVC = [ConversationViewController new];
    conversationVC.navigationItem.title = conversationModel.userName;
    [self.navigationController pushViewController:conversationVC animated:YES];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //更新数据
        [self.dataSource removeObjectAtIndex:indexPath.row];
        //更新UI
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }else if (editingStyle == UITableViewCellEditingStyleInsert) {
 
    }
}
#pragma mark - # Delegate
//设置滑动时显示多个按钮
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
//添加一个删除按钮
UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
    NSLog(@"点击了删除");
    //1.更新数据
    [self.dataSource removeObjectAtIndex:indexPath.row];
    //2.更新UI
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    
    }];
    //删除按钮颜色
    deleteAction.backgroundColor = [UIColor redColor];
    //添加一个置顶按钮
    UITableViewRowAction *unReadRowAction =[UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"标为未读" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"标为未读");
        //1.更新数据
//        [self.dataSource exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
        //2.更新UI
//        NSIndexPath *firstIndexPath =[NSIndexPath indexPathForRow:0 inSection:indexPath.section];
//        [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
            }];
    
    unReadRowAction.backgroundColor = [UIColor blackColor];
    return @[deleteAction,unReadRowAction];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
