//
//  HomeViewController.m
//  WeChat
//
//  Created by zhengwenming on 16/6/5.
//  Copyright © 2016年 zhengwenming. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()<UISearchBarDelegate,UITableViewDelegate>
{
    UISearchBar *searchBar_;
}
@property(nonatomic,retain)NSMutableArray *searchReslutArray;

@end

@implementation HomeViewController
-(NSMutableArray *)searchReslutArray{
    if (_searchReslutArray==nil) {
        _searchReslutArray = [NSMutableArray array];
    }
    return _searchReslutArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];

   searchBar_  = [[UISearchBar alloc]initWithFrame:CGRectMake(0, kNavbarHeight, kScreenWidth, 44)];
    searchBar_.placeholder = @"搜索";
    searchBar_.tintColor = kThemeColor;
    searchBar_.delegate = self;
    searchBar_.barStyle = UIBarStyleDefault;
    searchBar_.translucent = YES;
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"取消"];

    
    [self.dataSource addObject:@"1"];
    [self.dataSource addObject:@"2"];
    [self.dataSource addObject:@"3"];
    [self.dataSource addObject:@"4"];
    [self.dataSource addObject:@"5"];
    [self.dataSource addObject:@"6"];
    [self.dataSource addObject:@"7"];
    [self.dataSource addObject:@"8"];
    [self.dataSource addObject:@"9"];
    [self.dataSource addObject:@"10"];
    [self.dataSource addObject:@"11"];
    [self.dataSource addObject:@"12"];

    [self registerCellWithClass:@"UITableViewCell" tableView:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavbarHeight);
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = searchBar_;
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
   
    [self.tableView reloadData];
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;{
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self.searchReslutArray removeAllObjects];
    for(NSString *aString in self.dataSource)
    {
        NSRange range = [aString rangeOfString:searchBar.text];
        if (range.location!=NSNotFound) {
            [self.searchReslutArray addObject:aString];
        }
    }
    
    [self.tableView reloadData];

}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if([searchBar_.text isEqualToString:@""])//searchBar里面为空，没有东西
    {
        return self.dataSource.count;
    }else
    {
        return self.searchReslutArray.count;
    }
   
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    if([searchBar_.text isEqualToString:@""])
    {
        cell.textLabel.text = self.dataSource[indexPath.row];
    }else
    {
        cell.textLabel.text = self.searchReslutArray[indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    NSString *stringStr = @"";
    if([searchBar_.text isEqualToString:@""])
    {
        stringStr = self.dataSource[indexPath.row];
    }else
    {
        stringStr  = self.searchReslutArray[indexPath.row];
    }
    NSLog(@"%@",stringStr);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
