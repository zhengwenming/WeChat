//
//  ToolbarView.m
//  FaceKeyboard

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by ruofei on 16/3/28.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#import "ChatToolBar.h"
#import "ChatToolBarItem.h"
#import "ChatKeyBoardMacroDefine.h"

#define Image(str)              (str == nil || str.length == 0) ? nil : [UIImage imageNamed:str]
#define ItemW                   44                  //44
#define ItemH                   kChatToolBarHeight  //49
#define TextViewH               36
#define TextViewVerticalOffset  (ItemH-TextViewH)/2.0
#define TextViewMargin          8

@interface ChatToolBar ()<RFTextViewDelegate>

@property CGFloat previousTextViewHeight;

/** 临时记录输入的textView */
@property (nonatomic, copy) NSString *currentText;

@property (nonatomic, strong) UIButton *switchBarBtn;
@property (nonatomic, strong) UIButton *voiceBtn;
@property (nonatomic, strong) UIButton *faceBtn;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) RFTextView *textView;
@property (nonatomic, strong) RFRecordButton *recordBtn;

@property (readwrite) BOOL voiceSelected;
@property (readwrite) BOOL faceSelected;
@property (readwrite) BOOL moreFuncSelected;
@property (readwrite) BOOL switchBarSelected;

@end

@implementation ChatToolBar

#pragma mark -- dealloc

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"self.textView.contentSize"];
}

#pragma mark -- init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultValue];
        [self initSubviews];
    }
    return self;
}

- (void)setDefaultValue
{
    self.allowSwitchBar = NO;
    self.allowVoice = YES;
    self.allowFace = YES;
    self.allowMoreFunc = YES;
}

- (void)initSubviews
{
    // barView
    self.image = [[UIImage imageNamed:@"input-bar-flat"] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0f, 0.0f, 0.0f, 0.0f) resizingMode:UIImageResizingModeStretch];
    self.userInteractionEnabled = YES;
    self.previousTextViewHeight = TextViewH;
    
    // addSubView
    self.switchBarBtn = [self createBtn:kButKindSwitchBar action:@selector(toolbarBtnClick:)];
    self.switchBarBtn.hidden = YES;
    self.voiceBtn = [self createBtn:kButKindVoice action:@selector(toolbarBtnClick:)];
    self.faceBtn = [self createBtn:kButKindFace action:@selector(toolbarBtnClick:)];
    self.moreBtn = [self createBtn:kButKindMore action:@selector(toolbarBtnClick:)];
    self.recordBtn = [[RFRecordButton alloc] init];
    
    self.textView = [[RFTextView alloc] init];
    self.textView.frame = CGRectMake(0, 0, 0, TextViewH);
    self.textView.delegate = self;
    
    [self addSubview:self.voiceBtn];
    [self addSubview:self.faceBtn];
    [self addSubview:self.moreBtn];
    [self addSubview:self.switchBarBtn];
    [self addSubview:self.textView];
    [self addSubview:self.recordBtn];
    
    //设置frame
    [self setbarSubViewsFrame];
    
    //KVO
    [self addObserver:self forKeyPath:@"self.textView.contentSize" options:(NSKeyValueObservingOptionNew) context:nil];
   
    __weak __typeof(self) weekSelf = self;
    self.recordBtn.recordTouchDownAction = ^(RFRecordButton *sender){
        NSLog(@"开始录音");
        if (sender.highlighted) {
            sender.highlighted = YES;
            [sender setButtonStateWithRecording];
        }
        if ([weekSelf.delegate respondsToSelector:@selector(chatToolBarDidStartRecording:)]) {
            [weekSelf.delegate chatToolBarDidStartRecording:weekSelf];
        }
    };
    self.recordBtn.recordTouchUpInsideAction = ^(RFRecordButton *sender){
        NSLog(@"完成录音");
        [sender setButtonStateWithNormal];
        if ([weekSelf.delegate respondsToSelector:@selector(chatToolBarDidFinishRecoding:)]) {
            [weekSelf.delegate chatToolBarDidFinishRecoding:weekSelf];
        }
    };
    self.recordBtn.recordTouchUpOutsideAction = ^(RFRecordButton *sender){
        NSLog(@"取消录音");
        [sender setButtonStateWithNormal];
        if ([weekSelf.delegate respondsToSelector:@selector(chatToolBarDidCancelRecording:)]) {
            [weekSelf.delegate chatToolBarDidCancelRecording:weekSelf];
        }
    };
    
    //持续调用
    self.recordBtn.recordTouchDragInsideAction = ^(RFRecordButton *sender){
    };
    //持续调用
    self.recordBtn.recordTouchDragOutsideAction = ^(RFRecordButton *sender){
    };
    
    //中间状态  从 TouchDragInside ---> TouchDragOutside
    self.recordBtn.recordTouchDragExitAction = ^(RFRecordButton *sender){
        NSLog(@"将要取消录音");
        if ([weekSelf.delegate respondsToSelector:@selector(chatToolBarWillCancelRecoding:)]) {
            [weekSelf.delegate chatToolBarWillCancelRecoding:weekSelf];
        }
    };
    //中间状态  从 TouchDragOutside ---> TouchDragInside
    self.recordBtn.recordTouchDragEnterAction = ^(RFRecordButton *sender){
        NSLog(@"继续录音");
        if ([weekSelf.delegate respondsToSelector:@selector(chatToolBarContineRecording:)]) {
            [weekSelf.delegate chatToolBarContineRecording:weekSelf];
        }
    };
}

// 设置子视图frame
- (void)setbarSubViewsFrame
{
    CGFloat barViewH = self.frame.size.height;
    
    if (self.allowSwitchBar) {
        self.switchBarBtn.frame = CGRectMake(0, barViewH - ItemH, ItemW, ItemH);
    }else {
        self.switchBarBtn.frame = CGRectZero;
    }
    
    if (self.allowVoice){
        self.voiceBtn.frame = CGRectMake(CGRectGetMaxX(self.switchBarBtn.frame), barViewH - ItemH, ItemW, ItemH);
    }else {
        self.voiceBtn.frame = CGRectZero;
    }
    
    if (self.allowMoreFunc) {
        self.moreBtn.frame = CGRectMake(self.frame.size.width - ItemW, barViewH - ItemH, ItemW, ItemH);
    }else {
        self.moreBtn.frame = CGRectZero;
    }
    
    if (self.allowFace){
        self.faceBtn.frame = CGRectMake(self.frame.size.width - ItemW - CGRectGetWidth(self.moreBtn.frame), barViewH - ItemH, ItemW, ItemH);
    }else {
        self.faceBtn.frame = CGRectZero;
    }
    
    CGFloat textViewX = CGRectGetWidth(self.switchBarBtn.frame) + CGRectGetWidth(self.voiceBtn.frame);
    CGFloat textViewW = self.frame.size.width-CGRectGetWidth(self.switchBarBtn.frame)-CGRectGetWidth(self.voiceBtn.frame)-CGRectGetWidth(self.faceBtn.frame)-CGRectGetWidth(self.moreBtn.frame);
    
    // 调整边距
    if (textViewX == 0) {
        textViewX = TextViewMargin;
        textViewW = textViewW - TextViewMargin;
    }
    
    if (CGRectGetWidth(self.faceBtn.frame) + CGRectGetWidth(self.moreBtn.frame) == 0) {
        textViewW = textViewW - TextViewMargin;
    }
    
    self.textView.frame = CGRectMake(textViewX, TextViewVerticalOffset, textViewW, self.textView.frame.size.height);
    
    self.recordBtn.frame = self.textView.frame;
}
#pragma mark -- 加载barItems
- (void)loadBarItems:(NSArray<ChatToolBarItem *> *)barItems
{
    for (ChatToolBarItem* barItem in barItems)
    {
        [self setBtn:(NSInteger)barItem.itemKind normalStateImageStr:barItem.normalStr selectStateImageStr:barItem.selectStr highLightStateImageStr:barItem.highLStr];
    }
}

#pragma mark -- 调整文本内容
- (void)setTextViewContent:(NSString *)text
{
    self.currentText = self.textView.text = text;
}
- (void)clearTextViewContent
{
    self.currentText = self.textView.text = @"";
}

#pragma mark -- 调整placeHolder
- (void)setTextViewPlaceHolder:(NSString *)placeholder
{
    if (placeholder == nil) {
        return;
    }
    
    self.textView.placeHolder = placeholder;
}

- (void)setTextViewPlaceHolderColor:(UIColor *)placeHolderColor
{
    if (placeHolderColor == nil) {
        return;
    }
    self.textView.placeHolderTextColor = placeHolderColor;
}

#pragma mark -- 重新配置各个按钮
- (void)prepareForBeginComment
{
    self.voiceSelected = self.voiceBtn.selected = NO;
    self.faceSelected = self.faceBtn.selected = NO;
    self.moreFuncSelected = self.moreBtn.selected = NO;
    self.recordBtn.hidden = YES;
    self.textView.hidden = NO;
}
- (void)prepareForEndComment
{
    self.voiceSelected = self.voiceBtn.selected = NO;
    self.faceSelected = self.faceBtn.selected = NO;
    self.moreFuncSelected = self.moreBtn.selected = NO;
    self.recordBtn.hidden = YES;
    self.textView.hidden = NO;
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
}

#pragma mark -- 关于按钮
- (void)setBtn:(ButKind)btnKind normalStateImageStr:(NSString *)normalStr
selectStateImageStr:(NSString *)selectStr highLightStateImageStr:(NSString *)highLightStr
{
    UIButton *btn;
    
    switch (btnKind) {
        case kButKindFace:
            btn = self.faceBtn;
            break;
        case kButKindMore:
            btn = self.moreBtn;
            break;
        case kButKindVoice:
            btn = self.voiceBtn;
            break;
        case kButKindSwitchBar:
            btn = self.switchBarBtn;
            break;
        default:
            break;
    }
    [btn setImage:Image(normalStr) forState:UIControlStateNormal];
    [btn setImage:Image(selectStr) forState:UIControlStateSelected];
    [btn setImage:Image(highLightStr) forState:UIControlStateHighlighted];
}


- (UIButton *)createBtn:(ButKind)btnKind action:(SEL)sel
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    switch (btnKind) {
        case kButKindVoice:
            btn.tag = 1;
            break;
        case kButKindFace:
            btn.tag = 2;
            break;
        case kButKindMore:
            btn.tag = 3;
            break;
        case kButKindSwitchBar:
            btn.tag = 4;
            break;
        default:
            break;
    }
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    return btn;
}

#pragma mark -- UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.voiceSelected = self.voiceBtn.selected = NO;
    self.faceSelected = self.faceBtn.selected = NO;
    self.moreFuncSelected = self.moreBtn.selected = NO;
    
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(chatToolBarTextViewDidBeginEditing:)])
    {
        [self.delegate chatToolBarTextViewDidBeginEditing:self.textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        if ([self.delegate respondsToSelector:@selector(chatToolBarSendText:)])
        {
            self.currentText = @"";
            [self.delegate chatToolBarSendText:textView.text];
        }
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.currentText = textView.text;
    
    if ([self.delegate respondsToSelector:@selector(chatToolBarTextViewDidChange:)])
    {
        [self.delegate chatToolBarTextViewDidChange:self.textView];
    }
}

- (void)textViewDeleteBackward:(RFTextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(chatToolBarTextViewDeleteBackward:)]) {
        
        [self.delegate chatToolBarTextViewDeleteBackward:textView];
    }
}

#pragma mark - kvo回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:@"self.textView.contentSize"]) {
        [self layoutAndAnimateTextView:self.textView];
    }
}

#pragma mark -- 工具栏按钮点击事件
- (void)toolbarBtnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
        {
            [self handelVoiceClick:sender];
            break;
        }
        case 2:
        {
            [self handelFaceClick:sender];
            break;
        }
        case 3:
        {
            [self handelMoreClick:sender];
            break;
        }
        case 4:
        {
            [self handelSwitchBarClick:sender];
            break;
        }
        default:
            break;
    }
}

- (void)handelVoiceClick:(UIButton *)sender
{
    self.voiceSelected = self.voiceBtn.selected = !self.voiceBtn.selected;
    self.faceSelected = self.faceBtn.selected = NO;
    self.moreFuncSelected = self.moreBtn.selected = NO;
    BOOL keyBoardChanged = YES;
    
    if (sender.selected)
    {
        if (!self.textView.isFirstResponder)
        {
            keyBoardChanged = NO;
        }
        
        [self adjustTextViewContentSize];
        
        [self.textView resignFirstResponder];
    }
    else
    {
        [self resumeTextViewContentSize];
        
        [self.textView becomeFirstResponder];
    }
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.recordBtn.hidden = !sender.selected;
        self.textView.hidden = sender.selected;
    } completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(chatToolBar:voiceBtnPressed:keyBoardState:)])
    {
        [self.delegate chatToolBar:self voiceBtnPressed:sender.selected keyBoardState:keyBoardChanged];
    }
}

- (void)handelFaceClick:(UIButton *)sender
{
    self.faceSelected = self.faceBtn.selected = !self.faceBtn.selected;
    self.voiceSelected = self.voiceBtn.selected = NO;
    self.moreFuncSelected = self.moreBtn.selected = NO;
    BOOL keyBoardChanged = YES;
    
    if (sender.selected)
    {
        if (!self.textView.isFirstResponder)
        {
            keyBoardChanged = NO;
        }
        [self.textView resignFirstResponder];
    }
    else
    {
        [self.textView becomeFirstResponder];
    }
    
    [self resumeTextViewContentSize];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.recordBtn.hidden = YES;
        self.textView.hidden = NO;
    } completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(chatToolBar:faceBtnPressed:keyBoardState:)])
    {
        [self.delegate chatToolBar:self faceBtnPressed:sender.selected keyBoardState:keyBoardChanged];
    }

}

- (void)handelMoreClick:(UIButton *)sender
{
    self.moreFuncSelected = self.moreBtn.selected = !self.moreBtn.selected;
    self.voiceSelected = self.voiceBtn.selected = NO;
    self.faceSelected = self.faceBtn.selected = NO;
    
    BOOL keyBoardChanged = YES;
    
    if (sender.selected)
    {
        if (!self.textView.isFirstResponder)
        {
            keyBoardChanged = NO;
        }
        [self.textView resignFirstResponder];
    }else {
        [self.textView becomeFirstResponder];
    }
    
    [self resumeTextViewContentSize];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.recordBtn.hidden = YES;
        self.textView.hidden = NO;
    } completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(chatToolBar:moreBtnPressed:keyBoardState:)])
    {
        [self.delegate chatToolBar:self moreBtnPressed:sender.selected keyBoardState:keyBoardChanged];
    }

}
- (void)handelSwitchBarClick:(UIButton *)sender
{
    BOOL keyBoardChanged = YES;
    
    self.faceSelected = self.faceBtn.selected = NO;
    self.moreFuncSelected =  self.moreBtn.selected = NO;
    
    if (!self.textView.isFirstResponder)
    {
        keyBoardChanged = NO;
    }
    
    [self.textView resignFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(chatToolBarSwitchToolBarBtnPressed:keyBoardState:)])
    {
        [self.delegate chatToolBarSwitchToolBarBtnPressed:self keyBoardState:keyBoardChanged];
    }
}

#pragma mark -- 重写set方法
- (void)setAllowSwitchBar:(BOOL)allowSwitchBar
{
    _allowSwitchBar = allowSwitchBar;
    
    if (_allowSwitchBar) {
        self.switchBarBtn.hidden = NO;
    }else {
        self.switchBarBtn.hidden = YES;
    }
    [self setbarSubViewsFrame];
}

- (void)setAllowVoice:(BOOL)allowVoice
{
    _allowVoice = allowVoice;
    
    if (_allowVoice) {
        self.voiceBtn.hidden = NO;
    }else {
        self.voiceBtn.hidden = YES;
    }
    
    [self setbarSubViewsFrame];
}

- (void)setAllowFace:(BOOL)allowFace
{
    _allowFace = allowFace;
    
    if (_allowFace) {
        self.faceBtn.hidden = NO;
    }else {
        self.faceBtn.hidden = YES;
    }
    
    [self setbarSubViewsFrame];
}

- (void)setAllowMoreFunc:(BOOL)allowMoreFunc
{
    _allowMoreFunc = allowMoreFunc;
    if (_allowMoreFunc) {
        self.moreBtn.hidden = NO;
    }else {
        self.moreBtn.hidden = YES;
    }
    
    [self setbarSubViewsFrame];
}

#pragma mark -- 私有方法

- (void)adjustTextViewContentSize
{
    //调整 textView和recordBtn frame
    self.currentText = self.textView.text;
    self.textView.text = @"";
    self.textView.contentSize = CGSizeMake(CGRectGetWidth(self.textView.frame), TextViewH);
    self.recordBtn.frame = CGRectMake(self.textView.frame.origin.x, TextViewVerticalOffset, self.textView.frame.size.width, TextViewH);
}

- (void)resumeTextViewContentSize
{
    self.textView.text = self.currentText;
}


#pragma mark -- 计算textViewContentSize改变

- (CGFloat)getTextViewContentH:(RFTextView *)textView {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

- (CGFloat)fontWidth
{
    return 36.f; //16号字体
}

- (CGFloat)maxLines
{
    CGFloat h = [[UIScreen mainScreen] bounds].size.height;
    CGFloat line = 5;
    if (h == 480) {
        line = 3;
    }else if (h == 568){
        line = 3.5;
    }else if (h == 667){
        line = 4;
    }else if (h == 736){
        line = 4.5;
    }
    return line;
}

- (void)layoutAndAnimateTextView:(RFTextView *)textView
{
    CGFloat maxHeight = [self fontWidth] * [self maxLines];
    CGFloat contentH = [self getTextViewContentH:textView];
    
    BOOL isShrinking = contentH < self.previousTextViewHeight;
    CGFloat changeInHeight = contentH - self.previousTextViewHeight;
    
    if (!isShrinking && (self.previousTextViewHeight == maxHeight || textView.text.length == 0)) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewHeight);
    }
    
    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             if (isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewHeight = MIN(contentH, maxHeight);
                                 }
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self adjustTextViewHeightBy:changeInHeight];
                             }
                             CGRect inputViewFrame = self.frame;
                             self.frame = CGRectMake(0.0f,
                                                    0, //inputViewFrame.origin.y - changeInHeight
                                                    inputViewFrame.size.width,
                                                     (inputViewFrame.size.height + changeInHeight));
                             if (!isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewHeight = MIN(contentH, maxHeight);
                                 }
                                 // growing the view, animate the text view frame AFTER input view frame
                                 [self adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];
        self.previousTextViewHeight = MIN(contentH, maxHeight);
    }
    
    // Once we reached the max height, we have to consider the bottom offset for the text view.
    // To make visible the last line, again we have to set the content offset.
    if (self.previousTextViewHeight == maxHeight) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime,
                       dispatch_get_main_queue(),
                       ^(void) {
                           CGPoint bottomOffset = CGPointMake(0.0f, contentH - textView.bounds.size.height);
                           [textView setContentOffset:bottomOffset animated:YES];
                       });
    }
}

- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight
{
    //动态改变自身的高度和输入框的高度
    CGRect prevFrame = self.textView.frame;
    
    NSUInteger numLines = MAX([self.textView numberOfLinesOfText],
                              [[self.textView.text componentsSeparatedByString:@"\n"] count] + 1);
    
    
    self.textView.frame = CGRectMake(prevFrame.origin.x, prevFrame.origin.y, prevFrame.size.width, prevFrame.size.height + changeInHeight);
    
    self.textView.contentInset = UIEdgeInsetsMake((numLines >=6 ? 4.0f : 0.0f), 0.0f, (numLines >=6 ? 4.0f : 0.0f), 0.0f);
    
    // from iOS 7, the content size will be accurate only if the scrolling is enabled.
    //self.messageInputTextView.scrollEnabled = YES;
    if (numLines >=6) {
        CGPoint bottomOffset = CGPointMake(0.0f, self.textView.contentSize.height-self.textView.bounds.size.height);
        [self.textView setContentOffset:bottomOffset animated:YES];
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length-2, 1)];
    }
}


@end
