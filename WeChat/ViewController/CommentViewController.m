//
//  CommentViewController.m
//  WeChat
//
//  Created by zhengwenming on 16/6/4.
//  Copyright © 2016年 zhengwenming. All rights reserved.
//

#import "CommentViewController.h"
#import "MessageCell.h"
#import "MessageModel.h"

//键盘
#import "ChatKeyBoard.h"
#import "FaceSourceManager.h"
#import "MoreItem.h"
#import "ChatToolBarItem.h"
#import "FaceThemeModel.h"

@interface CommentViewController ()<ChatKeyBoardDelegate, ChatKeyBoardDataSource,UITableViewDelegate, UITableViewDataSource, ReloadMessageCellHightDelegate,UIScrollViewDelegate>{
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;
@property (nonatomic, assign) CGFloat history_Y_offset;
@property (nonatomic,copy)NSIndexPath *currentIndexPath;
@end

@implementation CommentViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        //注册键盘出现NSNotification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        //注册键盘隐藏NSNotification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
//#pragma mark -- ChatKeyBoardDataSource
//- (NSArray<MoreItem *> *)chatKeyBoardMorePanelItems
//{
//    MoreItem *item1 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
//    MoreItem *item2 = [MoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
//    MoreItem *item3 = [MoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];
//    MoreItem *item4 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
//    MoreItem *item5 = [MoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
//    MoreItem *item6 = [MoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];
//    MoreItem *item7 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
//    MoreItem *item8 = [MoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
//    MoreItem *item9 = [MoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];
//    return @[item1, item2, item3, item4, item5, item6, item7, item8, item9];
//}
- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems
{
    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"face" high:@"face_HL" select:@"keyboard"];
    
//    ChatToolBarItem *item2 = [ChatToolBarItem barItemWithKind:kBarItemVoice normal:@"voice" high:@"voice_HL" select:@"keyboard"];
//    
//    ChatToolBarItem *item3 = [ChatToolBarItem barItemWithKind:kBarItemMore normal:@"more_ios" high:@"more_ios_HL" select:nil];
//    
//    ChatToolBarItem *item4 = [ChatToolBarItem barItemWithKind:kBarItemSwitchBar normal:@"switchDown" high:nil select:nil];
    return @[item1];

//    return @[item1, item2, item3, item4];
}

- (NSArray<FaceThemeModel *> *)chatKeyBoardFacePanelSubjectItems
{
    return [FaceSourceManager loadFaceSource];
}

-(ChatKeyBoard *)chatKeyBoard{
    if (_chatKeyBoard==nil) {
        _chatKeyBoard =[ChatKeyBoard keyBoardWithNavgationBarTranslucent:YES];
        _chatKeyBoard.delegate = self;
        _chatKeyBoard.dataSource = self;
        _chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
        _chatKeyBoard.allowVoice = NO;
        _chatKeyBoard.allowMore = NO;
        _chatKeyBoard.allowSwitchBar = NO;
        _chatKeyBoard.placeHolder = @"评论";
        [self.view addSubview:_chatKeyBoard];
        [self.view bringSubviewToFront:_chatKeyBoard];
    }
    return _chatKeyBoard;
}
- (void)chatKeyBoardSendText:(NSString *)text{
    MessageModel *messageModel = [self.dataSource objectAtIndex:self.currentIndexPath.row];
    messageModel.shouldUpdateCache = YES;
    CommentModel *model = [[CommentModel alloc] init];
//    model.commentUserName = messageModel.userName;
    model.commentUserName = @"文明";
    model.commentByUserName = @"";
    model.commentId = [NSString stringWithFormat:@"commonModel%lu",  messageModel.commentModelArray.count + 100];
    model.commentText = text;
    [messageModel.commentModelArray addObject:model];
    
    messageModel.shouldUpdateCache = YES;
    [self reloadCellHeightForModel:messageModel atIndexPath:self.currentIndexPath];
    [self.chatKeyBoard keyboardDownForComment];
    self.chatKeyBoard.placeHolder = nil;
}

#pragma mark
#pragma mark 处理测试数据
-(void)dealData{
    self.dataSource = [[NSMutableArray alloc]init];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"]]];
    NSDictionary *JSONDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    for (NSDictionary *eachDic in JSONDic[@"data"][@"rows"]) {
        MessageModel *messageModel = [[MessageModel alloc] initWithDic:eachDic];
        [self.dataSource addObject:messageModel];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"朋友圈";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[[YYFPSLabel alloc]initWithFrame:CGRectMake(0, 5, 60, 30)]];

    [self dealData];
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    if (!cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageCell"];
        cell.delegate = self;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    __weak __typeof(self) weakSelf= self;
    __weak __typeof(_tableView) weakTable= _tableView;
    __weak __typeof(cell) weakCell= cell;
    
    __weak __typeof(window) weakWindow= window;

    __block MessageModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [cell configCellWithModel:model indexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    //评论
    cell.CommentBtnClickBlock = ^(UIButton *commentBtn,NSIndexPath * indexPath)
    {
        weakSelf.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"评论 %@",model.userName];
        weakSelf.history_Y_offset = [commentBtn convertRect:commentBtn.bounds toView:weakWindow].origin.y;
        weakSelf.currentIndexPath = indexPath;
        [weakSelf.chatKeyBoard keyboardUpforComment];
    };
    //更多
    cell.MoreBtnClickBlock = ^(UIButton *moreBtn,NSIndexPath * indexPath)
    {
        [weakSelf.chatKeyBoard keyboardDownForComment];
        weakSelf.chatKeyBoard.placeHolder = nil;
        model.isExpand = !model.isExpand;
        model.shouldUpdateCache = YES;
        [weakTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    
    
    //九宫格
    cell.tapImageBlock = ^(NSInteger index,NSArray *dataSource,NSIndexPath *indexpath){
        [weakSelf.chatKeyBoard keyboardDownForComment];

        
//        weakSelf.currentIndexPath = indexpath;
        
    };
    
    cell.TapTextBlock=^(UILabel *desLabel){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:desLabel.text delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    };
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageModel *model = [self.dataSource objectAtIndex:indexPath.row];
    
    CGFloat h = [MessageCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
        MessageCell *cell = (MessageCell *)sourceCell;
        [cell configCellWithModel:model indexPath:indexPath];
    } cache:^NSDictionary *{
        NSDictionary *cache = @{kHYBCacheUniqueKey : model.cid,
                                kHYBCacheStateKey  : @"",
                                kHYBRecalculateForStateKey : @(model.shouldUpdateCache)};
        model.shouldUpdateCache = NO;
        return cache;
    }];
    return h;
}

#pragma mark - ReloadMessageCellHightDelegate
- (void)reloadCellHeightForModel:(MessageModel *)model atIndexPath:(NSIndexPath *)indexPath {
//    self.currentIndexPath = indexPath;
//    [self.chatKeyBoard keyboardUpforComment];

    
    
//    CommentModel *commetModel = [[CommentModel alloc] init];
//    //    model.commentUserName = messageModel.userName;
//    commetModel.commentUserName = @"文明";
//    commetModel.commentByUserName = @"";
//    commetModel.commentText = text;
//    commetModel.uid = [NSString stringWithFormat:@"commonModel%lu",  model.commentModelArray.count + 1];
//    [model.commentModelArray addObject:model];
//    
//    [self reloadCellHeightForModel:model atIndexPath:self.currentIndexPath];
//    [self.chatKeyBoard keyboardDownForComment];
//    self.chatKeyBoard.placeHolder = nil;
    
    
    model.shouldUpdateCache = YES;

    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    
    CGFloat delta = self.history_Y_offset - ([UIApplication sharedApplication].keyWindow.bounds.size.height - keyboardHeight-85);
    
    
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = -64;
    }
    [self.tableView setContentOffset:offset animated:YES];
}

#pragma mark
#pragma mark keyboardWillHide
- (void)keyboardWillHide:(NSNotification *)notification {
    NSValue *animationDurationValue = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
//        [self.chatKeyBoard keyboardDownForComment];
//        self.chatKeyBoard.placeHolder = nil;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"CommentViewController didReceiveMemoryWarning");
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"CommentViewController dealloc");
}

@end
