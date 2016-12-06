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
#import "FriendModel.h"

@interface SearchResultViewController (){
    UITableView *table;
    NSMutableArray *dataSource;
    UILabel *footerLabel;
}

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataSource = [[NSMutableArray alloc]init];
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    [table registerNib:[UINib nibWithNibName:NSStringFromClass([AddressBookCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AddressBookCell class])];
    
    table.showsVerticalScrollIndicator = NO;
    table.bouncesZoom = NO;
    table.delegate = self;
    table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    table.dataSource = self;
    [self.view addSubview:table];
    
    
    footerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, table.frame.size.width, 40)];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    footerLabel.textColor = [UIColor lightGrayColor];
    if (dataSource.count==0) {
        footerLabel.text = @"无结果";
        table.tableFooterView = footerLabel;
    }else{
        footerLabel.text = @"";
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section //行数
{
    return dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AddressBookCell *cell=(AddressBookCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AddressBookCell class])];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if(dataSource.count>0)
    {
        FriendModel *friends = [dataSource objectAtIndex:indexPath.row];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@",friends.userName];
        [cell.photoIV sd_setImageWithURL:[NSURL URLWithString:friends.photo] placeholderImage:[UIImage imageNamed:@"default_portrait"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        cell.photoIV.backgroundColor = [UIColor lightGrayColor];
        cell.photoIV.clipsToBounds = YES;
        }else{
        if (dataSource.count==0) {
            footerLabel.text = @"无结果";
            table.tableFooterView = footerLabel;
        }else{
            footerLabel.text = @"";
        }
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(void)updateAddressBookData:(NSArray *)AddressBookDataArray{
    [dataSource removeAllObjects];
    
    [dataSource addObjectsFromArray:AddressBookDataArray];
    
    [table reloadData];
    if (dataSource.count==0) {
        footerLabel.text = @"无结果";
        table.tableFooterView = footerLabel;
    }else{
        footerLabel.text = @"";
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendModel *friends = [dataSource objectAtIndex:indexPath.row];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (self.delegate&&[self.delegate respondsToSelector:@selector(selectPersonWithUserId:userName:photo:phoneNO:)]) {
            [self.delegate selectPersonWithUserId:friends.userId userName:friends.userName photo:friends.photo phoneNO:friends.phoneNO];
        }        
    }];
}
#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"Entering:%@ ",searchController.searchBar.text);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
