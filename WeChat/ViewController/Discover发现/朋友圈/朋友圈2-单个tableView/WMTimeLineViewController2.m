//
//  WMTimeLineViewController2.m
//  WeChat
//
//  Created by zhengwenming on 2017/9/21.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import "WMTimeLineViewController2.h"
#import "WMTimeLineHeaderView.h"
#import "CommentCell2.h"
#import "LikeUsersCell1.h"


@interface WMTimeLineViewController2 ()

@end

@implementation WMTimeLineViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getTestData2];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:NSClassFromString(@"WMTimeLineHeaderView") forHeaderFooterViewReuseIdentifier:@"WMTimeLineHeaderView"];
    [self registerCellWithClass:@"CommentCell2" tableView:self.tableView];
    [self registerCellWithClass:@"LikeUsersCell1" tableView:self.tableView];

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
//显示评论的数据
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MessageInfoModel1 *eachModel = self.dataSource[section];
    NSArray  *commentMessages =  eachModel.commentModelArray;
    return commentMessages.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageInfoModel2 *eachModel = self.dataSource[indexPath.section];
    CommentInfoModel2  *commentModel =  eachModel.commentModelArray[indexPath.row];
    if ([commentModel isKindOfClass:[NSArray class]]) {
        return 44;
    }
    return commentModel.rowHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    MessageInfoModel2 *eachModel = self.dataSource[section];
    return eachModel.headerHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WMTimeLineHeaderView *headerView = (WMTimeLineHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"WMTimeLineHeaderView"];
    MessageInfoModel2 *eachModel = self.dataSource[section];
    headerView.model = eachModel;
    return headerView;
}
///footer高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.f;
}
///footerView
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10.f)];
    footerView.backgroundColor = [UIColor whiteColor];
    return footerView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentCell2 *cell2 = (CommentCell2 *)[tableView dequeueReusableCellWithIdentifier:@"CommentCell2"];
    LikeUsersCell1 *cell = (LikeUsersCell1 *)[tableView dequeueReusableCellWithIdentifier:@"LikeUsersCell1"];

    MessageInfoModel1 *eachModel = self.dataSource[indexPath.section];
    NSArray  *commentMessages =  eachModel.commentModelArray;
    cell2.model = commentMessages[indexPath.row];
    if ([commentMessages[indexPath.row] isKindOfClass:[NSArray class]]) {
        
        cell.backgroundColor = [UIColor cyanColor];
        return cell;

    }else{
        return cell2;

    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark
#pragma mark keyboardWillShow
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    __block  CGFloat keyboardHeight = [aValue CGRectValue].size.height;
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.bounds;
    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    //  [self.tableView setContentOffset:CGPointMake(0, self.history_Y_offset-keyboardHeight-kChatToolBarHeight+4) animated:YES];
    
    
    
}
#pragma mark
#pragma mark keyboardWillHide
- (void)keyboardWillHide:(NSNotification *)notification {
    NSValue *animationDurationValue = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        
    }];
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
