//
//  DiscoverViewController.m
//  WeChat
//
//  Created by zhengwenming on 16/6/5.
//  Copyright © 2016年 zhengwenming. All rights reserved.
//

#import "DiscoverViewController.h"
#import "WMTimeLineViewController.h"
#import "PersonCenterCell.h"


@interface DiscoverViewController ()<UITableViewDelegate,UITableViewDataSource>{

}
@property(nonatomic,strong)UITableView *discoverTable;
///强引用朋友圈VC，做到像微信朋友圈一样，再次进入朋友圈依然显示上次浏览的位置
@property(nonatomic,strong)WMTimeLineViewController *timeLineVC;

@end

@implementation DiscoverViewController
///懒加载评论页面（朋友圈页面）
-(WMTimeLineViewController *)timeLineVC{
    if (_timeLineVC==nil) {
        _timeLineVC = [[WMTimeLineViewController alloc]init];
    }
    return _timeLineVC;
}
-(UITableView *)discoverTable{
    if (_discoverTable==nil) {
        _discoverTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavbarHeight, kScreenWidth, kScreenHeight-kTabBarHeight-kNavbarHeight) style:UITableViewStyleGrouped];
        _discoverTable.delegate = self;
        _discoverTable.dataSource = self;
        [_discoverTable registerNib:[UINib nibWithNibName:@"PersonCenterCell" bundle:nil] forCellReuseIdentifier:@"PersonCenterCell"];
    }
    return _discoverTable;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.discoverTable];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 2;
            break;
        default:
            break;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 42;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kAlmostZero;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCenterCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section==0) {//我的好友
        cell.titleIV.image = [UIImage imageNamed:@"ff_IconShowAlbum"];
        cell.titleLabel.text = @"朋友圈(一个tableView结构)";
    }else if (indexPath.section==1){//设置
        if (indexPath.row==0) {
            cell.titleIV.image = [UIImage imageNamed:@"ff_IconQRCode"];
            cell.titleLabel.text = @"扫一扫";
        }else if (indexPath.row==1){
            cell.titleIV.image = [UIImage imageNamed:@"ff_IconShake"];
            cell.titleLabel.text = @"摇一摇";
        }
    }else if(indexPath.section==2){
        cell.titleIV.image = [UIImage imageNamed:@"ff_IconLocationService"];
        cell.titleLabel.text = @"附近的人";
    }else if(indexPath.section==3){
        if (indexPath.row==0) {
            cell.titleIV.image = [UIImage imageNamed:@"CreditCard_ShoppingBag"];
            cell.titleLabel.text = @"购物";
        }else if (indexPath.row==1){
            cell.titleIV.image = [UIImage imageNamed:@"MoreGame"];
            cell.titleLabel.text = @"游戏";
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        //        [self.navigationController pushViewController:self.timeLineTwo animated:YES];
        [self.navigationController pushViewController:[[WMTimeLineViewController alloc]init] animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
