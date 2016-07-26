//
//  ContactsViewController.m
//  WeChat
//
//  Created by zhengwenming on 16/6/5.
//  Copyright © 2016年 zhengwenming. All rights reserved.
//

#import "ContactsViewController.h"
#import "AddressBookCell.h"
#import "FriendModel.h"
#import "SearchResultViewController.h"
@interface ContactsViewController ()<UISearchBarDelegate,SearchResultSelectedDelegate>{
    UISearchController *searchController;
    SearchResultViewController *resultController;
    UITableView *friendTableView;
    NSMutableArray *dataSource;
    NSMutableArray *updateArray;
    
    
}

@property(nonatomic,strong) NSArray *lettersArray;
@property(nonatomic,strong) NSMutableDictionary *nameDic;
@property(nonatomic,strong) NSMutableArray *results;

@end

@implementation ContactsViewController

- (void)keyboardWillShow:(NSNotification *)notification {
    //    [_tableView setFrame:CGRectMake(0, kNavbarHeight, kScreenWidth, kScreenHeight)];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    //    [_tableView setFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight-kNavbarHeight)];
}
-(void)initUI{
    self.nameDic = [[NSMutableDictionary alloc]init];
    self.results = [[NSMutableArray alloc]init];
    
    friendTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    
    [friendTableView registerNib:[UINib nibWithNibName:NSStringFromClass([AddressBookCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AddressBookCell class])];
    friendTableView.delegate = self;
    friendTableView.dataSource = self;
    
    [self.view addSubview:friendTableView];
    friendTableView.tableFooterView = [UIView new];
    resultController = [[SearchResultViewController alloc]init];
    resultController.delegate = self;
    searchController = [[UISearchController alloc] initWithSearchResultsController:resultController];
    
    
    searchController.searchResultsUpdater = resultController;
    searchController.searchBar.placeholder = @"搜索";
//    searchController.searchBar.tintColor = [UIColor greenColor];
    searchController.searchBar.delegate = self;
//    searchController.searchBar.searchTextPositionAdjustment = UIOffsetMake(0, 0);
    friendTableView.tableHeaderView = searchController.searchBar;
//    self.definesPresentationContext = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dataSource = [[NSMutableArray alloc]init];
    updateArray = [[NSMutableArray alloc]init];
    self.lettersArray = [[NSArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    [self loadAddressBookData];
    
}
-(void)loadAddressBookData{
    NSData *friendsData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"AddressBook" ofType:@"json"]]];
    NSDictionary *JSONDic = [NSJSONSerialization JSONObjectWithData:friendsData options:NSJSONReadingAllowFragments error:nil];
    for (NSDictionary *eachDic in JSONDic[@"friends"][@"row"]) {
        [dataSource addObject:[[FriendModel alloc]initWithDic:eachDic]];
    }
    [self handleLettersArray];
    [friendTableView reloadData];
}
#pragma mark
#pragma mark tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView==friendTableView) {
        return self.lettersArray.count;
    }else{
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==friendTableView) {
        NSArray *nameArray = [self.nameDic objectForKey:self.lettersArray[section]];
        return nameArray.count;
    }else{
        return dataSource.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifer = @"AddressBookCell";
    
    
    AddressBookCell *cell = (AddressBookCell *)[tableView dequeueReusableCellWithIdentifier:identifer];
    
    if (tableView==friendTableView) {
        if (dataSource.count) {
            FriendModel *frends = [[self.nameDic objectForKey:[self.lettersArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
            cell.nameLabel.text = frends.userName;
            [cell.photoIV sd_setImageWithURL:[NSURL URLWithString:frends.photo] placeholderImage:[UIImage imageNamed:@"default_portrait"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
            cell.photoIV.backgroundColor = [UIColor lightGrayColor];
            cell.photoIV.clipsToBounds = YES;
        }
    }else{
        NSString *userName = self.results[indexPath.row];
        FriendModel *friends = [[FriendModel alloc]init];
        for (NSInteger i = 0 ;i<dataSource.count; i++) {
            NSMutableArray *tempArray = [[NSMutableArray alloc]init];
            
            if ([userName isEqualToString:friends.userName]) {
                [tempArray addObject:friends];
            }
            FriendModel *frends = [tempArray objectAtIndex:0];
            cell.nameLabel.text = [NSString stringWithFormat:@"%@",frends.userName];
            [cell.photoIV sd_setImageWithURL:[NSURL URLWithString:frends.photo] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            }];
            cell.photoIV.backgroundColor = [UIColor lightGrayColor];
        }
    }
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FriendModel *friends;
    if (tableView==friendTableView) {
        friends = [[self.nameDic objectForKey:[self.lettersArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
    }else{
        friends = dataSource[indexPath.row];
    }
}
-(void)selectPersonWithUserId:(NSString *)userId userName:(NSString *)userName photo:(NSString *)photo phoneNO:(NSString *)phoneNO{
    NSLog(@"%@",userName);
    searchController.searchBar.text = @"";
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==friendTableView) {
        return 20.0;
    }
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.lettersArray objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView==friendTableView) {
        NSInteger count = 0;
        for(NSString *letter in self.lettersArray)
        {
            if([letter isEqualToString:title])
            {
                return count;
            }
            count++;
        }
        return 0;
    }
    else{
        return 0;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView==friendTableView) {
        return self.lettersArray;
        
    }else{
        return nil;
    }
}
#pragma mark
#pragma mark UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText) {
        
        [updateArray removeAllObjects];
        if ([PinyinHelper isIncludeChineseInString:searchText]) {// 中文
            for(int i=0;i<dataSource.count;i++)
            {
                FriendModel *friends = dataSource[i];
                if ([friends.userName rangeOfString:searchText].location!=NSNotFound) {
                    [updateArray addObject:friends];
                }
                
            }
        }else{//拼音
            for(int i=0;i<dataSource.count;i++)
            {
                HanyuPinyinOutputFormat *formatter =  [[HanyuPinyinOutputFormat alloc] init];
                formatter.caseType = CaseTypeUppercase;
                formatter.vCharType = VCharTypeWithV;
                formatter.toneType = ToneTypeWithoutTone;
                
                FriendModel *friends = dataSource[i];
                
                NSString *outputPinyin=[[PinyinHelper toHanyuPinyinStringWithNSString:friends.userName withHanyuPinyinOutputFormat:formatter withNSString:@""] lowercaseString];
                
                
                if ([[outputPinyin lowercaseString]rangeOfString:[searchText lowercaseString]].location!=NSNotFound) {
                    [updateArray addObject:friends];
                }
                
                
            }
        }
        
        
    }
    NSLog(@"%@",updateArray);
    [resultController updateAddressBookData:updateArray];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchController.searchBar.showsCancelButton = YES;
    UIButton *canceLBtn = [searchController.searchBar valueForKey:@"cancelButton"];
    [canceLBtn setTitle:@"取消" forState:UIControlStateNormal];
    [canceLBtn setTitleColor:[UIColor colorWithRed:14.0/255.0 green:180.0/255.0 blue:0.0/255.0 alpha:1.00] forState:UIControlStateNormal];
    searchBar.showsCancelButton = YES;
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
        [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    
    [searchBar resignFirstResponder];
}

- (void)handleLettersArray
{
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
    
    for(FriendModel *friends  in dataSource)
    {
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
            FriendModel *friends = dataSource[i];
            HanyuPinyinOutputFormat *formatter =  [[HanyuPinyinOutputFormat alloc] init];
            formatter.caseType = CaseTypeUppercase;
            formatter.vCharType = VCharTypeWithV;
            formatter.toneType = ToneTypeWithoutTone;
            
            
            NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:friends.userName withHanyuPinyinOutputFormat:formatter withNSString:@""];
            if ([letter isEqualToString:[[outputPinyin substringToIndex:1] uppercaseString]]) {
                [tempArry addObject:friends];
                
            }
            
        }
        [self.nameDic setObject:tempArry forKey:letter];
    }
    
    self.lettersArray = tempDic.allKeys;
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
