//
//  HomeViewController.m
//  WeChat
//
//  Created by zhengwenming on 16/6/5.
//  Copyright © 2016年 zhengwenming. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UISearchBar *searchBar_;
}
@property(nonatomic,retain)NSMutableArray *searchReslutArray;
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
-(NSMutableArray *)searchReslutArray{
    if (_searchReslutArray==nil) {
        _searchReslutArray = [NSMutableArray array];
    }
    return _searchReslutArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    searchBar_  = [[UISearchBar new]initWithFrame:CGRectMake(0, 0, kScreenWidth, 56)];
    searchBar_.placeholder = @"搜索";
    searchBar_.tintColor = kThemeColor;
    searchBar_.delegate = self;
    searchBar_.barStyle = UIBarStyleDefault;
    searchBar_.translucent = NO;
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"取消"];

    for (NSInteger index = 0; index<30; index++) {
            [self.dataSource addObject:[NSString stringWithFormat:@"%li",index]];
    }
    
    self.homeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavbarHeight, self.view.frame.size.width, kScreenHeight-kNavbarHeight-kTabBarHeight) style:UITableViewStyleGrouped];
    self.homeTableView.dataSource = self;
    self.homeTableView.delegate = self;
    self.homeTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.homeTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:self.homeTableView];
    self.homeTableView.tableHeaderView = searchBar_;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    [self.searchReslutArray removeAllObjects];
    [self.view endEditing:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    [self.searchReslutArray removeAllObjects];
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.homeTableView reloadData];
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;{
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self.searchReslutArray removeAllObjects];
    for(NSString *aString in self.dataSource){
        NSRange range = [aString rangeOfString:searchBar.text];
        if (range.location!=NSNotFound) {
            [self.searchReslutArray addObject:aString];
        }
    }
    
    [self.homeTableView reloadData];

}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([searchBar_.text isEqualToString:@""])//searchBar里面为空，没有东西
    {
        return self.dataSource.count;
    }else{
        return self.searchReslutArray.count;
    }
   
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    if([searchBar_.text isEqualToString:@""]){
        cell.textLabel.text = self.dataSource[indexPath.row];
    }else{
        cell.textLabel.text = self.searchReslutArray[indexPath.row];
    }
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
    NSString *stringStr = @"";
    if([searchBar_.text isEqualToString:@""]){
        stringStr = self.dataSource[indexPath.row];
    }else{
        stringStr  = self.searchReslutArray[indexPath.row];
    }
    NSLog(@"%@",stringStr);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
