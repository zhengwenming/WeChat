//
//  WMTimeLineViewController.m
//  WeChat
//
//  Created by zhengwenming on 2017/9/18.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import "WMTimeLineViewController.h"
#import "WMTimeLineHeaderView.h"
#import "CommentCell.h"

@interface WMTimeLineViewController ()

@end

@implementation WMTimeLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerCellWithNib:@"CommentCell" tableView:self.tableView];
    [self.tableView registerClass:NSClassFromString(@"WMTimeLineHeaderView") forHeaderFooterViewReuseIdentifier:@"WMTimeLineHeaderView"];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
//显示评论的数据
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MessageModel *eachModel = self.dataSource[section];
    NSArray  *commentMessages =  eachModel.commentModelArray;
    return commentMessages.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    WMTimeLineHeaderView *headerView = (WMTimeLineHeaderView *)[self tableView:tableView viewForHeaderInSection:section];
    return headerView.frame.size.height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *eachModel = self.dataSource[indexPath.section];
    NSArray  *commentMessages =  eachModel.commentModelArray;
    return 100+1+10;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WMTimeLineHeaderView *headerView = (WMTimeLineHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"WMTimeLineHeaderView"];
    MessageModel *messageModel = self.dataSource[section];
    return headerView;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:@"tableView"];
    
    MessageModel *eachModel = self.dataSource[indexPath.section];
    NSArray  *commentMessages =  eachModel.commentModelArray;
    CommentModel *commentModel = commentMessages[indexPath.row];
    cell.detailTextLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return cell;
}

-(NSMutableAttributedString *)getAttributedStringWithCommentModel:(CommentModel *)model{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSParagraphStyleAttributeName:paragraphStyle};
    NSMutableAttributedString *attributedString = nil;
    if ([model.commentByUserName isEqualToString:@""]) {
        attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: %@",model.commentUserName,model.commentText] attributes:attributes];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, model.commentUserName.length)];
    }else{
        attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@回复%@: %@",model.commentByUserName,model.commentUserName,model.commentText] attributes:attributes];
        
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, model.commentByUserName.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(model.commentByUserName.length+2, model.commentUserName.length)];
        
    }
    
    
    
    
    
    return attributedString;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(NSString *)getStringWithCommentModel:(CommentModel *)model{
    NSString *aString = nil;
    if ([model.commentByUserName isEqualToString:@""]) {
        aString = [NSString stringWithFormat:@"%@: %@",model.commentUserName,model.commentText];
    }else{
        aString = [NSString stringWithFormat:@"%@回复%@: %@",model.commentByUserName,model.commentUserName,model.commentText];
    }
    return aString;
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
