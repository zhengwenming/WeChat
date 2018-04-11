/*!
 @header SearchResultViewController.m
 
 @abstract  作者Github地址：https://github.com/zhengwenming
            作者CSDN博客地址:http://blog.csdn.net/wenmingzheng
 
 @author   Created by zhengwenming on  16/3/11
 
 @version 1.00 16/3/11 Creation(版本信息)
 
   Copyright © 2016年 zhengwenming. All rights reserved.
 */

#import "SearchResultViewController.h"
#import "AddressBookCell.h"


@interface SearchResultViewController ()<UITableViewDataSource,UITableViewDelegate>{
}
@property(nonatomic,strong)UITableView *resultTableView;
@property(nonatomic,strong)NSMutableArray *dataSourceA;
@property(nonatomic,strong)NSMutableArray *jasonArray;
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UILabel *footerLabel;

@end

@implementation SearchResultViewController
- (void)setItemClickAction:(void (^)(__kindof UIViewController *searchResultVC, id data))itemClickAction{
    NSLog(@"setItemClickAction");
}
-(UIView *)headerView{
    if (_headerView==nil) {
        _headerView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, _headerView.frame.size.width-10, _headerView.frame.size.height)];
        headerLabel.font = [UIFont systemFontOfSize:14.f];
        headerLabel.text = @"联系人";
        headerLabel.textColor = [UIColor darkGrayColor];
        [_headerView addSubview:headerLabel];
    }
    return _headerView;
}
-(UILabel *)footerLabel{
    if (_footerLabel==nil) {
        _footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        _footerLabel.textAlignment = NSTextAlignmentCenter;
        _footerLabel.textColor = [UIColor lightGrayColor];
        _footerLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _footerLabel;
}
-(UITableView *)resultTableView{
    if (_resultTableView==nil) {
        _resultTableView = [UITableView new];
        [_resultTableView registerNib:[UINib nibWithNibName:NSStringFromClass([AddressBookCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AddressBookCell class])];
        _resultTableView.estimatedSectionHeaderHeight = 0;
        _resultTableView.estimatedSectionFooterHeight = 0;
        _resultTableView.rowHeight = 50;
        _resultTableView.showsVerticalScrollIndicator = NO;
        _resultTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _resultTableView.delegate = self;
        _resultTableView.dataSource = self;
        _resultTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _resultTableView;
}
-(NSMutableArray *)dataSourceA{
    if (_dataSourceA==nil) {
        _dataSourceA = [NSMutableArray array];
    }
    return _dataSourceA;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.resultTableView];
    self.resultTableView.tableHeaderView = self.headerView;
    self.resultTableView.tableFooterView = self.footerLabel;
    [self.resultTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, iPhoneX?(kTabBarHeight):0, 0));
    }];
    
    
    if (@available(iOS 11.0, *)) {
        self.resultTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {

    }
    
    NSData *friendsData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"AddressBook" ofType:@"json"]]];
    NSDictionary *JSONDic = [NSJSONSerialization JSONObjectWithData:friendsData options:NSJSONReadingAllowFragments error:nil];
    self.jasonArray = [NSMutableArray array];
    for (NSDictionary *eachDic in JSONDic[@"friends"][@"row"]) {
        [self.jasonArray addObject:[[FriendInfoModel alloc]initWithDic:eachDic]];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceA.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressBookCell *cell=(AddressBookCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AddressBookCell class])];
    FriendInfoModel *friends = [self.dataSourceA objectAtIndex:indexPath.row];
    cell.frendModel = friends;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendInfoModel *friendModel = [self.dataSourceA objectAtIndex:indexPath.row];
        if (self.itemSelectedAction) {
            self.itemSelectedAction(self, friendModel);
        }
}
#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//    searchController.searchResultsController.view.hidden = NO;

    if (searchController.searchBar.text) {
        [self.dataSourceA removeAllObjects];
        if ([PinyinHelper isIncludeChineseInString:searchController.searchBar.text]) {// 如果是中文
            for(int i=0;i<self.jasonArray.count;i++){
                FriendInfoModel *friends = self.jasonArray[i];
                if ([friends.userName rangeOfString:searchController.searchBar.text].location!=NSNotFound) {
                    [self.dataSourceA addObject:friends];
                }
            }
        }else{//如果是拼音
            for(int i=0;i<self.jasonArray.count;i++){
                HanyuPinyinOutputFormat *formatter =  [[HanyuPinyinOutputFormat alloc] init];
                formatter.caseType = CaseTypeUppercase;
                formatter.vCharType = VCharTypeWithV;
                formatter.toneType = ToneTypeWithoutTone;
                //zhengshuang  e
                FriendInfoModel *friends = self.jasonArray[i];

                NSString *outputPinyin=[[PinyinHelper toHanyuPinyinStringWithNSString:friends.userName withHanyuPinyinOutputFormat:formatter withNSString:@""] lowercaseString];

                if ([[outputPinyin lowercaseString]rangeOfString:[searchController.searchBar.text lowercaseString]].location!=NSNotFound) {
                    [self.dataSourceA addObject:friends];
                }
            }
        }
    }
    if (self.dataSourceA.count==0) {
        self.footerLabel.text = @"无结果";
        self.resultTableView.tableHeaderView = nil;
    }else{
        self.footerLabel.text = @"";
        self.resultTableView.tableHeaderView = self.headerView;
    }
    [self.resultTableView reloadData];
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
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"语音搜索按钮");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
