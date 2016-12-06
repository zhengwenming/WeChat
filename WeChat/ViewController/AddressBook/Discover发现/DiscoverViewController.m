

//
//  DiscoverViewController.m
//  WeChat
//
//  Created by zhengwenming on 16/6/5.
//  Copyright © 2016年 zhengwenming. All rights reserved.
//

#import "DiscoverViewController.h"
#import "PersonCenterCell.h"

@interface DiscoverViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *discoverTable;
}

@end

@implementation DiscoverViewController
///懒加载评论页面（朋友圈页面）
-(CommentViewController *)commentVC{
    if (_commentVC==nil) {
        _commentVC = [[CommentViewController alloc]init];
    }
    return _commentVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTable];
}
-(void)initTable{
    discoverTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    discoverTable.delegate = self;
    discoverTable.dataSource = self;
    [discoverTable registerNib:[UINib nibWithNibName:@"PersonCenterCell" bundle:nil] forCellReuseIdentifier:@"PersonCenterCell"];
    [self.view addSubview:discoverTable];
    [discoverTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
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
        cell.titleLabel.text = @"朋友圈";

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
        [self.navigationController pushViewController:self.commentVC animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
