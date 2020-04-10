//
//  ContactsViewController.m
//  WeChat
//
//  Created by zhengwenming on 16/6/5.
//  Copyright © 2016年 zhengwenming. All rights reserved.
//

#import "ContactsViewController.h"
#import "AddressBookCell.h"
#import "FriendInfoModel.h"
#import "WMSearchController.h"
#import "SearchResultViewController.h"
@interface ContactsViewController ()<UISearchBarDelegate,UISearchResultsUpdating,UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *dataSource;
    NSMutableArray *updateArray;
}
/// 搜索
@property (nonatomic, strong) WMSearchController *searchController;
@property(nonatomic,strong) NSArray *lettersArray;
@property(nonatomic,strong) NSMutableArray *topFixedArray;
@property(nonatomic,strong) NSMutableDictionary *nameDic;
@property(nonatomic,strong) UITableView *friendTableView;
@property(nonatomic,strong)UILabel *footerLabel;
@property(nonatomic,strong)UIView *footer;

@end

@implementation ContactsViewController

-(UITableView *)friendTableView{
    if (_friendTableView==nil) {
        _friendTableView = [UITableView new];
        _friendTableView.delegate = self;
        _friendTableView.dataSource = self;
        _friendTableView.rowHeight = 50.f;
        _friendTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_friendTableView registerNib:[UINib nibWithNibName:NSStringFromClass([AddressBookCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AddressBookCell class])];
        //设置右边索引index的字体颜色和背景颜色
        _friendTableView.sectionIndexColor = [UIColor darkGrayColor];
        _friendTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    return _friendTableView;
}
-(UILabel *)footerLabel{
    if (_footerLabel==nil) {
        _footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 1.0/(UIScreen.mainScreen.scale), self.view.frame.size.width, 50-1.0/(UIScreen.mainScreen.scale))];
        _footerLabel.textAlignment = NSTextAlignmentCenter;
        _footerLabel.textColor = [UIColor grayColor];
        _footerLabel.backgroundColor = [UIColor whiteColor];
        _footerLabel.font = [UIFont systemFontOfSize:17.f];
    }
    return _footerLabel;
}
-(UIView *)footer{
    if (_footer==nil) {
        _footer =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        _footer.backgroundColor = self.friendTableView.separatorColor;
        [_footer addSubview:self.footerLabel];
    }
    return _footer;
}
- (WMSearchController *)searchController{
    if (_searchController == nil) {
        SearchResultViewController *searchReslutVC = [[SearchResultViewController alloc] init];
        @weakify(self);
        [searchReslutVC setItemSelectedAction:^(SearchResultViewController *searchVC, FriendInfoModel *userModel) {
            @strongify(self);
            [self.searchController setActive:NO];
        }];
        _searchController = [WMSearchController searchController:searchReslutVC];
        _searchController.searchBar.delegate = self;
        [_searchController setEnableVoiceInput:YES];
    }
    return _searchController;
}
-(void)addFriends:(UIBarButtonItem *)sender{
    NSLog(@"addFriends");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    dataSource = [[NSMutableArray alloc]init];
    updateArray = [[NSMutableArray alloc]init];
    self.lettersArray = [[NSArray alloc]init];
    self.nameDic = [[NSMutableDictionary alloc]init];
    [self loadAddressBookData];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"contacts_add_friend"] style:UIBarButtonItemStylePlain target:self action:@selector(addFriends:)];
    
    [self.view addSubview:self.friendTableView];
    [self.friendTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.friendTableView.tableHeaderView = self.searchController.searchBar;
    self.friendTableView.tableFooterView = self.footer;
}
-(void)loadAddressBookData{
    self.topFixedArray = [NSMutableArray arrayWithCapacity:4];
        FriendInfoModel *friends_new = [FriendInfoModel new];
        friends_new.userName = @"新的朋友";
        friends_new.imgName = @"friends_new";
        [self.topFixedArray addObject:friends_new];
    
        FriendInfoModel *friends_group = [FriendInfoModel new];
        friends_group.userName = @"群聊";
        friends_group.imgName = @"friends_group";
        [self.topFixedArray addObject:friends_group];
        
        FriendInfoModel *friends_tag = [FriendInfoModel new];
        friends_tag.userName = @"标签";
        friends_tag.imgName = @"friends_tag";
        [self.topFixedArray addObject:friends_tag];
        
        FriendInfoModel *friends_public = [FriendInfoModel new];
        friends_public.userName = @"公众号";
        friends_public.imgName = @"friends_public";
        [self.topFixedArray addObject:friends_public];
    
    NSData *friendsData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"AddressBook" ofType:@"json"]]];
    NSDictionary *JSONDic = [NSJSONSerialization JSONObjectWithData:friendsData options:NSJSONReadingAllowFragments error:nil];
    for (NSDictionary *eachDic in JSONDic[@"friends"][@"row"]) {
        [dataSource addObject:[[FriendInfoModel alloc]initWithDic:eachDic]];
    }
    
    self.footerLabel.text = [NSString stringWithFormat:@"%lu位朋友及联系人",(unsigned long)dataSource.count];
    [self handleLettersArray];
}
#pragma mark
#pragma mark tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.lettersArray.count+1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section) {
        NSArray *nameArray = [self.nameDic objectForKey:self.lettersArray[section-1]];
        return nameArray.count;
    }else{
        return self.topFixedArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section) {
        AddressBookCell *cell = (AddressBookCell *)[tableView dequeueReusableCellWithIdentifier:@"AddressBookCell"];
        FriendInfoModel *frends = [[self.nameDic objectForKey:self.lettersArray[indexPath.section-1]] objectAtIndex:indexPath.row];
        cell.frendModel = frends;
        return cell;
    }
        AddressBookCell *cell = (AddressBookCell *)[tableView dequeueReusableCellWithIdentifier:@"AddressBookCell"];
        FriendInfoModel *frends = self.topFixedArray[indexPath.row];
        cell.frendModel = frends;
        return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    FriendInfoModel *friends = [[self.nameDic objectForKey:[self.lettersArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
}
-(void)selectPersonWithUserId:(NSString *)userId userName:(NSString *)userName photo:(NSString *)photo phoneNO:(NSString *)phoneNO{

}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
        headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        NSString *letterString =  self.lettersArray[section-1];
        UILabel *letterLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, headerView.frame.origin.y, headerView.frame.size.width-10, headerView.frame.size.height)];
        letterLabel.textColor = [UIColor grayColor];
        letterLabel.font = [UIFont systemFontOfSize:14.f];
        letterLabel.text =letterString;
        [headerView addSubview:letterLabel];
        return headerView;
    }
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==self.friendTableView&&section!=0) {
        return 25.0;
    }
    return CGFLOAT_MIN;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.lettersArray[section];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    NSInteger count = 0;
        for(NSString *letter in self.lettersArray){
            if([letter isEqualToString:title]){
                return count;
            }
            count++;
        }
        return 0;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
        return self.lettersArray;
}
#pragma mark
#pragma mark UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText) {
        [updateArray removeAllObjects];
        if ([PinyinHelper isIncludeChineseInString:searchText]) {// 如果是中文
            for(int i=0;i<dataSource.count;i++){
                FriendInfoModel *friends = dataSource[i];
                if ([friends.userName rangeOfString:searchText].location!=NSNotFound) {
                    [updateArray addObject:friends];
                }
            }
        }else{//如果是拼音
            for(int i=0;i<dataSource.count;i++){
                HanyuPinyinOutputFormat *formatter =  [[HanyuPinyinOutputFormat alloc] init];
                formatter.caseType = CaseTypeUppercase;
                formatter.vCharType = VCharTypeWithV;
                formatter.toneType = ToneTypeWithoutTone;
                //zhengshuang  e
                FriendInfoModel *friends = dataSource[i];
                
                NSString *outputPinyin=[[PinyinHelper toHanyuPinyinStringWithNSString:friends.userName withHanyuPinyinOutputFormat:formatter withNSString:@""] lowercaseString];
                
                if ([[outputPinyin lowercaseString]rangeOfString:[searchText lowercaseString]].location!=NSNotFound) {
                    [updateArray addObject:friends];
                }
            }
        }
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if (IS_IPHONEX) {
        for (UIView *view in searchBar.subviews[0].subviews) {
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.15 animations:^{
                        view.frame = CGRectMake(view.frame.origin.x, 12, view.frame.size.width, view.frame.size.height);
                        UIButton *canceLBtn = [searchBar valueForKey:@"cancelButton"];
                        canceLBtn.frame = CGRectMake(canceLBtn.frame.origin.x, 12, canceLBtn.frame.size.width, canceLBtn.frame.size.height);
                        
                    }];
                });
            }
        }
    }
    
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    if (IS_IPHONEX) {
        for (UIView *view in searchBar.subviews[0].subviews) {
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.1 animations:^{
                        view.frame = CGRectMake(view.frame.origin.x, 12, view.frame.size.width, view.frame.size.height);
                        UIButton *canceLBtn = [searchBar valueForKey:@"cancelButton"];
                        canceLBtn.frame = CGRectMake(canceLBtn.frame.origin.x, 12, canceLBtn.frame.size.width, canceLBtn.frame.size.height);
                    }];
                });
            }
        }
    }
    
    return YES;
}
//处理letterArray，包括按英文字母顺序排序
- (void)handleLettersArray{
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
    for(FriendInfoModel *friends  in dataSource){
        HanyuPinyinOutputFormat *formatter =  [[HanyuPinyinOutputFormat alloc] init];
        formatter.caseType = CaseTypeLowercase;
        formatter.vCharType = VCharTypeWithV;
        formatter.toneType = ToneTypeWithoutTone;
        NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:friends.userName withHanyuPinyinOutputFormat:formatter withNSString:@""];
//        NSLog(@"%@",[[outputPinyin substringToIndex:1] uppercaseString]);
        [tempDic setObject:friends forKey:[[outputPinyin substringToIndex:1] uppercaseString]];
    }
    
    self.lettersArray = tempDic.allKeys;
    for (NSString *letter in self.lettersArray) {
        NSMutableArray *tempArry = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i<dataSource.count; i++) {
            FriendInfoModel *friends = dataSource[i];
            HanyuPinyinOutputFormat *formatter =  [[HanyuPinyinOutputFormat alloc] init];
            formatter.caseType = CaseTypeUppercase;
            formatter.vCharType = VCharTypeWithV;
            formatter.toneType = ToneTypeWithoutTone;
            
            //把friend的userName汉子转为汉语拼音，比如：张磊---->zhanglei
            NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:friends.userName withHanyuPinyinOutputFormat:formatter withNSString:@""];
            if ([letter isEqualToString:[[outputPinyin substringToIndex:1] uppercaseString]]) {
                [tempArry addObject:friends];
            }
        }
        [self.nameDic setObject:tempArry forKey:letter];
    }
    
    self.lettersArray = tempDic.allKeys;
    //排序，排序的根据是字母
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 characterAtIndex:0] > [obj2 characterAtIndex:0]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 characterAtIndex:0] < [obj2 characterAtIndex:0]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    self.lettersArray = [[NSMutableArray alloc]initWithArray:[self.lettersArray sortedArrayUsingComparator:cmptr]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
