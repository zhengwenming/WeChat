//
//  WMTimeLineViewController.m
//  WeChat
//
//  Created by zhengwenming on 2017/9/21.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import "WMTimeLineViewController.h"
#import "WMTimeLineHeaderView.h"
#import "CommentCell.h"
#import "LikeUsersCell.h"
@interface WMTimeLineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation WMTimeLineViewController
-(UITableView *)tableView{
    if (_tableView==nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavbarHeight, self.view.frame.size.width, kScreenHeight-kNavbarHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];

        [_tableView registerClass:NSClassFromString(@"WMTimeLineHeaderView") forHeaderFooterViewReuseIdentifier:@"WMTimeLineHeaderView"];
//        [_tableView registerNib:[UINib nibWithNibName:@"LikeUsersCell" bundle:nil] forCellReuseIdentifier:@"LikeUsersCell"];
        [_tableView registerClass:NSClassFromString(@"CommentCell") forCellReuseIdentifier:@"CommentCell"];
//        UIImageView * backgroundImageView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 260)];
//        backgroundImageView.image = [UIImage imageNamed:@"background.jpeg"];
//        _tableView.tableHeaderView = backgroundImageView;
//        _tableView.contentInset = UIEdgeInsetsMake(-kNavbarHeight, 0, kBottomSafeHeight, 0);
//        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
-(void)textViewDidSendText:(NSString *)text{
    NSLog(@"%@",text);
}
/**
 键盘的frame改变
 */
- (void)keyboardChangeFrameMinY:(CGFloat)minY{
    
}
#pragma mark
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getTestData];
    [self.view addSubview:self.tableView];
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
//显示评论的数据
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MessageInfoModel *eachModel = self.dataSource[section];
    return eachModel.commentModelArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageInfoModel *eachModel = self.dataSource[indexPath.section];
    CommentInfoModel  *commentModel =  eachModel.commentModelArray[indexPath.row];
    return 60.f;

    return commentModel.rowHeight;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.1f;
////    MessageInfoModel *eachModel = self.dataSource[section];
////    return eachModel.headerHeight;
//}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0.1f)];
//    return footerView;
//
////    __weak __typeof(self) weakSelf= self;
////    WMTimeLineHeaderView *headerView = (WMTimeLineHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"WMTimeLineHeaderView"];
////    headerView.tapImageBlock = ^(NSInteger index, NSArray *dataSource) {
////        WMPhotoBrowser *browser = [WMPhotoBrowser new];
////        browser.dataSource = dataSource.mutableCopy;
////        browser.currentPhotoIndex = index;
////        browser.downLoadNeeded = YES;
////        [weakSelf.navigationController pushViewController:browser animated:YES];
//////        [weakSelf presentViewController:browser animated:YES completion:^{
////
////        }];
////    };
//
////    MessageInfoModel *eachModel = self.dataSource[section];
////    headerView.model = eachModel;
////    return headerView;
//}
///footer高度
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 01.f;
//}
/////footerView
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0.1f)];
//    return footerView;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageInfoModel *eachModel = self.dataSource[indexPath.section];
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
       cell.textLabel.text = eachModel.mutablAttrStr.string;
    
    return cell;
//    __weak __typeof(self) weakSelf= self;
//    CommentInfoModel  *commentModel =  eachModel.commentModelArray[indexPath.row];
//    CommentCell *commentCell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
//    commentCell.backgroundColor = [UIColor magentaColor];
//    return commentCell;
    
//    if (commentModel.likeUsersArray.count) {
//        LikeUsersCell *likeUsersCell = (LikeUsersCell *)[tableView dequeueReusableCellWithIdentifier:@"LikeUsersCell"];
//        likeUsersCell.model = commentModel;
//        likeUsersCell.backgroundColor = [UIColor yellowColor];
//        return likeUsersCell;
//    }else{
//        CommentCell *commentCell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
//        commentCell.model = commentModel;
//        commentCell.tapCommentBlock = ^(CommentCell *cell, CommentInfoModel *model) {
//            [weakSelf dealComment];
//        };
//        commentCell.backgroundColor = [UIColor magentaColor];
//        return commentCell;
//    }
}
-(void)dealComment{
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"%s",__FUNCTION__);
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__FUNCTION__);
}
@end
