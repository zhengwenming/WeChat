//
//  ChatKeyBoard.m
//  FaceKeyboard

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by ruofei on 16/3/29.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#import "ChatKeyBoard.h"

#import "ChatToolBar.h"
#import "FacePanel.h"
#import "MorePanel.h"

#import "MoreItem.h"
#import "ChatToolBarItem.h"
#import "FaceThemeModel.h"

#import "OfficialAccountToolbar.h"
#import "ChatKeyBoardMacroDefine.h"

#import "NSString+Emoji.h"

CGFloat getSupviewH(CGRect frame)
{
    return frame.origin.y + kChatToolBarHeight;
}

CGFloat getDifferenceH(CGRect frame)
{
    return kScreenHeight - (frame.origin.y + kChatToolBarHeight);
}

@interface ChatKeyBoard () <ChatToolBarDelegate, FacePanelDelegate, MorePannelDelegate>

@property (nonatomic, strong) ChatToolBar *chatToolBar;
@property (nonatomic, strong) FacePanel *facePanel;
@property (nonatomic, strong) MorePanel *morePanel;
@property (nonatomic, strong) OfficialAccountToolbar *OAtoolbar;

@property (nonatomic, assign) BOOL translucent;

@property (nonatomic, assign) CGRect keyboardInitialFrame;

@end

@implementation ChatKeyBoard

#pragma mark -- life

+ (instancetype)keyBoard
{
    return [self keyBoardWithNavgationBarTranslucent:YES];
}

+ (instancetype)keyBoardWithNavgationBarTranslucent:(BOOL)translucent
{
    CGRect frame = CGRectZero;
    if (translucent) {
        frame = CGRectMake(0, kScreenHeight - kChatToolBarHeight, kScreenWidth, kChatKeyBoardHeight);
    }else {
        frame = CGRectMake(0, kScreenHeight - kChatToolBarHeight - 64, kScreenWidth, kChatKeyBoardHeight);
    }
    return [[self alloc] initWithFrame:frame];
}

+ (instancetype)keyBoardWithParentViewBounds:(CGRect)bounds
{
    CGRect frame = CGRectMake(0, bounds.size.height - kChatToolBarHeight, kScreenWidth, kChatKeyBoardHeight);
    return [[self alloc] initWithFrame:frame];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [self removeObserver:self forKeyPath:@"self.chatToolBar.frame"];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _keyboardInitialFrame = frame;
        
        _chatToolBar = [[ChatToolBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kChatToolBarHeight)];
        _chatToolBar.delegate = self;
        [self addSubview:self.chatToolBar];
        
        _facePanel = [[FacePanel alloc] initWithFrame:CGRectMake(0, kChatKeyBoardHeight-kFacePanelHeight, kScreenWidth, kFacePanelHeight)];
        _facePanel.delegate = self;
        [self addSubview:self.facePanel];
        
        _morePanel = [[MorePanel alloc] initWithFrame:self.facePanel.frame];
        _morePanel.delegate = self;
        [self addSubview:self.morePanel];
        
        _OAtoolbar = [[OfficialAccountToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame), kScreenWidth, kChatToolBarHeight)];
        [self addSubview:self.OAtoolbar];
        
        __weak __typeof(self) weakself = self;
        self.OAtoolbar.switchAction = ^(){
            [UIView animateWithDuration:0.25 animations:^{
                weakself.OAtoolbar.frame = CGRectMake(0, CGRectGetMaxY(weakself.frame), CGRectGetWidth(weakself.frame), kChatToolBarHeight);
                CGFloat y = weakself.frame.origin.y;
                y = getSupviewH(weakself.keyboardInitialFrame) - weakself.chatToolBar.frame.size.height;
                weakself.frame = CGRectMake(0, y, weakself.frame.size.width, weakself.frame.size.height);
            }];
        };
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [self addObserver:self forKeyPath:@"self.chatToolBar.frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}


#pragma mark -- 跟随键盘的坐标变化
- (void)keyBoardWillChangeFrame:(NSNotification *)notification
{
    // 键盘已经弹起时，表情按钮被选择
    if (self.chatToolBar.faceSelected && (getSupviewH(self.keyboardInitialFrame) - CGRectGetMidY(self.frame)) < CGRectGetHeight(self.frame))
    {
        [UIView animateWithDuration:0.25 delay:0.03 options:UIViewAnimationOptionCurveLinear animations:^{
            self.morePanel.hidden = YES;
            self.facePanel.hidden = NO;
            self.frame = CGRectMake(0, getSupviewH(self.keyboardInitialFrame)-CGRectGetHeight(self.frame), kScreenWidth, CGRectGetHeight(self.frame));
            self.facePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame)-kFacePanelHeight, CGRectGetWidth(self.frame), kFacePanelHeight);
            self.morePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), kFacePanelHeight);
        } completion:nil];
    }
    // 键盘已经弹起时，more按钮被选择
    else if (self.chatToolBar.moreFuncSelected && (getSupviewH(self.keyboardInitialFrame) - CGRectGetMidY(self.frame)) < CGRectGetHeight(self.frame))
    {
        [UIView animateWithDuration:0.25 delay:0.03 options:UIViewAnimationOptionCurveLinear animations:^{
            self.morePanel.hidden = NO;
            self.facePanel.hidden = YES;
            self.frame = CGRectMake(0, getSupviewH(self.keyboardInitialFrame)-CGRectGetHeight(self.frame), kScreenWidth, CGRectGetHeight(self.frame));
            self.morePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame)-kFacePanelHeight, CGRectGetWidth(self.frame), kFacePanelHeight);
            self.facePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), kFacePanelHeight);
        } completion:nil];
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            
            CGRect begin = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
            CGRect end = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
            CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            
            CGFloat targetY = end.origin.y - (CGRectGetHeight(self.frame) - kMorePanelHeight) - getDifferenceH(self.keyboardInitialFrame);
            
            if(begin.size.height>0 && (begin.origin.y-end.origin.y>0))
            {
                // 键盘弹起 (包括，第三方键盘回调三次问题，监听仅执行最后一次)
                self.frame = CGRectMake(0, targetY, CGRectGetWidth(self.frame), self.frame.size.height);
                self.morePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), kFacePanelHeight);
                self.facePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), kFacePanelHeight);
                
            }
            else if (end.origin.y == kScreenHeight && begin.origin.y!=end.origin.y && duration > 0)
            {
                //键盘收起
                if (self.keyBoardStyle == KeyBoardStyleChat)
                {
                    self.frame = CGRectMake(0, targetY, CGRectGetWidth(self.frame), self.frame.size.height);
                    
                }else if (self.keyBoardStyle == KeyBoardStyleComment)
                {
                    if (self.chatToolBar.voiceSelected)
                    {
                       self.frame = CGRectMake(0, targetY, CGRectGetWidth(self.frame), self.frame.size.height);
                    }
                    else
                    {
                        self.frame = CGRectMake(0, getSupviewH(self.keyboardInitialFrame), CGRectGetWidth(self.frame), self.frame.size.height);
                    }
                }
            }
            else if ((begin.origin.y-end.origin.y<0) && duration == 0)
            {
                //键盘切换
                self.frame = CGRectMake(0, targetY, CGRectGetWidth(self.frame), self.frame.size.height);
            }
        }];
    }
}

#pragma mark -- kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:@"self.chatToolBar.frame"]) {
        
        CGRect newRect = [[change objectForKey:NSKeyValueChangeNewKey] CGRectValue];
        CGRect oldRect = [[change objectForKey:NSKeyValueChangeOldKey] CGRectValue];
        CGFloat changeHeight = newRect.size.height - oldRect.size.height;
        self.frame = CGRectMake(0, self.frame.origin.y - changeHeight, self.frame.size.width, self.frame.size.height + changeHeight);
        self.facePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame)-kFacePanelHeight, CGRectGetWidth(self.frame), kFacePanelHeight);
        self.morePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame)-kMorePanelHeight, CGRectGetWidth(self.frame), kMorePanelHeight);
        self.OAtoolbar.frame = CGRectMake(0, CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), kChatToolBarHeight);
    }
}

#pragma mark -- ChatToolBarDelegate

- (void)chatToolBar:(ChatToolBar *)toolBar voiceBtnPressed:(BOOL)select keyBoardState:(BOOL)change
{
    if (select && change == NO) {
        
        [UIView animateWithDuration:0.25 animations:^{
            CGFloat y = self.frame.origin.y;
            y = getSupviewH(self.keyboardInitialFrame) - self.chatToolBar.frame.size.height;
            self.frame = CGRectMake(0, y, self.frame.size.width, self.frame.size.height);
        }];
    }
}
- (void)chatToolBar:(ChatToolBar *)toolBar faceBtnPressed:(BOOL)select keyBoardState:(BOOL)change
{
    if (select && change == NO)
    {
        self.morePanel.hidden = YES;
        self.facePanel.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(0, getSupviewH(self.keyboardInitialFrame)-CGRectGetHeight(self.frame), kScreenWidth, CGRectGetHeight(self.frame));
            self.facePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame)-kFacePanelHeight, CGRectGetWidth(self.frame), kFacePanelHeight);
            self.morePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), kFacePanelHeight);
        }];
    }
}
- (void)chatToolBar:(ChatToolBar *)toolBar moreBtnPressed:(BOOL)select keyBoardState:(BOOL)change
{
    if (select && change == NO)
    {
        self.morePanel.hidden = NO;
        self.facePanel.hidden = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(0, getSupviewH(self.keyboardInitialFrame)-CGRectGetHeight(self.frame), kScreenWidth, CGRectGetHeight(self.frame));
            self.morePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame)-kMorePanelHeight, CGRectGetWidth(self.frame), kMorePanelHeight);
            self.facePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), kFacePanelHeight);
        }];
    }
}
- (void)chatToolBarSwitchToolBarBtnPressed:(ChatToolBar *)toolBar keyBoardState:(BOOL)change
{
    if (change == NO)
    {
        [UIView animateWithDuration:0.25 animations:^{
            CGFloat y = self.frame.origin.y;
            y = getSupviewH(self.keyboardInitialFrame) - kChatToolBarHeight;
            self.frame = CGRectMake(0,getSupviewH(self.keyboardInitialFrame), self.frame.size.width, self.frame.size.height);
            self.OAtoolbar.frame = CGRectMake(0, 0, self.frame.size.width, kChatToolBarHeight);
            self.frame = CGRectMake(0, y, self.frame.size.width, self.frame.size.height);
        }];
    }
    else
    {
        CGFloat y = getSupviewH(self.keyboardInitialFrame) - kChatToolBarHeight;
        self.frame = CGRectMake(0, getSupviewH(self.keyboardInitialFrame), self.frame.size.width, self.frame.size.height);
        self.OAtoolbar.frame = CGRectMake(0, 0, self.frame.size.width, kChatToolBarHeight);
        self.frame = CGRectMake(0, y, self.frame.size.width, self.frame.size.height);
    }
}

- (void)chatToolBarDidStartRecording:(ChatToolBar *)toolBar
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardDidStartRecording:)]) {
        [self.delegate chatKeyBoardDidStartRecording:self];
    }
}
- (void)chatToolBarDidCancelRecording:(ChatToolBar *)toolBar
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardDidCancelRecording:)]) {
        [self.delegate chatKeyBoardDidCancelRecording:self];
    }
}
- (void)chatToolBarDidFinishRecoding:(ChatToolBar *)toolBar
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardDidFinishRecoding:)]) {
        [self.delegate chatKeyBoardDidFinishRecoding:self];
    }
}
- (void)chatToolBarWillCancelRecoding:(ChatToolBar *)toolBar
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardWillCancelRecoding:)]) {
        [self.delegate chatKeyBoardWillCancelRecoding:self];
    }
}
- (void)chatToolBarContineRecording:(ChatToolBar *)toolBar
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardContineRecording:)]) {
        [self.delegate chatKeyBoardContineRecording:self];
    }
}

- (void)chatToolBarTextViewDidBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardTextViewDidBeginEditing:)]) {
        [self.delegate chatKeyBoardTextViewDidBeginEditing:textView];
    }
}
- (void)chatToolBarSendText:(NSString *)text
{
    
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardSendText:)]) {
        [self.delegate chatKeyBoardSendText:text];
    }
    [self.chatToolBar clearTextViewContent];
}
- (void)chatToolBarTextViewDidChange:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardTextViewDidChange:)]) {
        [self.delegate chatKeyBoardTextViewDidChange:textView];
    }
}

//聊天键盘删除内容
- (void)chatToolBarTextViewDeleteBackward:(RFTextView *)textView
{
    NSRange range = textView.selectedRange;
    NSString *handleText;
    NSString *appendText;
    if (range.location == textView.text.length) {
        handleText = textView.text;
        appendText = @"";
    }else {
        handleText = [textView.text substringToIndex:range.location];
        appendText = [textView.text substringFromIndex:range.location];
    }
    
    if (handleText.length > 0) {
        
        [self deleteBackward:handleText appendText:appendText];
    }
}

#pragma mark -- FacePanelDelegate
- (void)facePanelFacePicked:(FacePanel *)facePanel faceStyle:(FaceThemeStyle)themeStyle faceName:(NSString *)faceName isDeleteKey:(BOOL)deletekey
{
    NSString *text = self.chatToolBar.textView.text;
    if (deletekey == YES)
    {
        if (text.length <= 0) {
            [self.chatToolBar setTextViewContent:@""];
        }else {
            [self deleteBackward:text appendText:@""];
        }
    }else {
        [self.chatToolBar setTextViewContent:[text stringByAppendingString:faceName]];
    }
    
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardFacePicked:faceStyle:faceName:delete:)]) {
        [self.delegate chatKeyBoardFacePicked:self faceStyle:themeStyle faceName:faceName delete:deletekey];
    }
}

- (void)facePanelSendTextAction:(FacePanel *)facePanel
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardSendText:)]) {
        [self.delegate chatKeyBoardSendText:self.chatToolBar.textView.text];
    }
    [self.chatToolBar clearTextViewContent];
}

- (void)facePanelAddSubject:(FacePanel *)facePanel
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardAddFaceSubject:)]) {
        [self.delegate chatKeyBoardAddFaceSubject:self];
    }
}
- (void)facePanelSetSubject:(FacePanel *)facePanel
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardSetFaceSubject:)]) {
        [self.delegate chatKeyBoardSetFaceSubject:self];
    }
}

#pragma mark -- MorePannelDelegate
- (void)morePannel:(MorePanel *)morePannel didSelectItemIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoard:didSelectMorePanelItemIndex:)]) {
        [self.delegate chatKeyBoard:self didSelectMorePanelItemIndex:index];
    }
}

#pragma mark -- dataSource

- (void)setDataSource:(id<ChatKeyBoardDataSource>)dataSource
{
    _dataSource = dataSource;
    if (dataSource == nil) {
        return;
    }
    
    if ([self.dataSource respondsToSelector:@selector(chatKeyBoardToolbarItems)]) {
        NSArray<ChatToolBarItem *> *barItems = [self.dataSource chatKeyBoardToolbarItems];
        [self.chatToolBar loadBarItems:barItems];
    }
    
    if ([self.dataSource respondsToSelector:@selector(chatKeyBoardMorePanelItems)]) {
        NSArray<MoreItem *> *moreItems = [self.dataSource chatKeyBoardMorePanelItems];
        [self.morePanel loadMoreItems:moreItems];
    }
    
    if ([self.dataSource respondsToSelector:@selector(chatKeyBoardFacePanelSubjectItems)]) {
        NSArray<FaceThemeModel *> *themeItems = [self.dataSource chatKeyBoardFacePanelSubjectItems];
        [self.facePanel loadFaceThemeItems:themeItems];
    }
}

#pragma mark -- set方法
- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    
    [self.chatToolBar setTextViewPlaceHolder:placeHolder];
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
    _placeHolderColor = placeHolderColor;
    
    [self.chatToolBar setTextViewPlaceHolderColor:placeHolderColor];
}

-(void)setAllowVoice:(BOOL)allowVoice
{
    self.chatToolBar.allowVoice = allowVoice;
}

- (void)setAllowFace:(BOOL)allowFace
{
    self.chatToolBar.allowFace = allowFace;
}

- (void)setAllowMore:(BOOL)allowMore
{
    self.chatToolBar.allowMoreFunc = allowMore;
}

- (void)setAllowSwitchBar:(BOOL)allowSwitchBar
{
    self.chatToolBar.allowSwitchBar = allowSwitchBar;
}

- (void)setKeyBoardStyle:(KeyBoardStyle)keyBoardStyle
{
    _keyBoardStyle = keyBoardStyle;
    
    if (keyBoardStyle == KeyBoardStyleComment) {
        self.frame = CGRectMake(0, self.frame.origin.y+kChatToolBarHeight, self.frame.size.width, self.frame.size.height);
    }
}

- (void)keyboardUp
{
    if (self.keyBoardStyle == KeyBoardStyleChat)
    {
        [self.chatToolBar prepareForBeginComment];
        [self.chatToolBar.textView becomeFirstResponder];
    }
    else {
        NSException *excp = [NSException exceptionWithName:@"ChatKeyBoardException" reason:@"键盘开启了评论风格请使用- (void)keyboardUpforComment" userInfo:nil];
        [excp raise];

    }
}


- (void)keyboardDown
{
    if (self.keyBoardStyle == KeyBoardStyleChat)
    {
        if ([self.chatToolBar.textView isFirstResponder])
        {
            [self.chatToolBar.textView resignFirstResponder];
        }
        else
        {
            [UIView animateWithDuration:0.25 animations:^{
                CGFloat y = self.frame.origin.y;
                y = getSupviewH(self.keyboardInitialFrame) - self.chatToolBar.frame.size.height;
                self.frame = CGRectMake(0, y, self.frame.size.width, self.frame.size.height);
            }];
        }
    }else {
        NSException *excp = [NSException exceptionWithName:@"ChatKeyBoardException" reason:@"键盘开启了评论风格请使用- (void)keyboardDownForComment" userInfo:nil];
        [excp raise];
    }
}


- (void)keyboardUpforComment
{
    if (self.keyBoardStyle != KeyBoardStyleComment) {
        NSException *excp = [NSException exceptionWithName:@"ChatKeyBoardException" reason:@"键盘未开启评论风格" userInfo:nil];
        [excp raise];
    }
    [self.chatToolBar prepareForBeginComment];
    [self.chatToolBar.textView becomeFirstResponder];
}

- (void)keyboardDownForComment
{
    if (self.keyBoardStyle != KeyBoardStyleComment) {
        NSException *excp = [NSException exceptionWithName:@"ChatKeyBoardException" reason:@"键盘未开启评论风格" userInfo:nil];
        [excp raise];
    }
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.chatToolBar prepareForEndComment];
        self.frame = CGRectMake(0, getSupviewH(self.keyboardInitialFrame), self.frame.size.width, CGRectGetHeight(self.frame));
    } completion:nil];
}

#pragma mark - 回删表情或文字

- (void)deleteBackward:(NSString *)text appendText:(NSString *)appendText
{
    if (IsTextContainFace(text)) { // 如果最后一个是表情
        
        NSRange startRang = [text rangeOfString:@"[" options:NSBackwardsSearch];
        NSString *current = [text substringToIndex:startRang.location];
        [self.chatToolBar setTextViewContent:[current stringByAppendingString:appendText]];
        self.chatToolBar.textView.selectedRange = NSMakeRange(current.length, 0);
        
    }else { // 如果最后一个系统键盘输入的文字
        
        if ([text isEmoji]) { // 如果是Emoji表情
            NSString *current = [text substringToIndex:text.length - 2];
            
            [self.chatToolBar setTextViewContent:[current stringByAppendingString:appendText]];
            self.chatToolBar.textView.selectedRange = NSMakeRange(current.length, 0);
            
        }else { // 如果是纯文字
            NSString *current = [text substringToIndex:text.length - 1];
            
            [self.chatToolBar setTextViewContent:[current stringByAppendingString:appendText]];
            self.chatToolBar.textView.selectedRange = NSMakeRange(current.length, 0);
        }
    }
}


@end
