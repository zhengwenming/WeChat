//
//  ChatFacePanel.m
//  FaceKeyboard

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by ruofei on 16/3/30.
//  Copyright © 2016年 ruofei. All rights reserved.
//
//  2581502433@qq.com

/**
    尝试了 scroll + scroll
          collection + collection
    最终确定方案  scroll + collection
 */

#import "FacePanel.h"

#import "FaceThemeView.h"
#import "PanelBottomView.h"

#import "FaceThemeModel.h"

#import "ChatKeyBoardMacroDefine.h"

extern NSString * const FacePageViewFaceSelectedNotification;
extern NSString * const FacePageViewFaceName;
extern NSString * const FacePageViewDeleteKey;
extern NSString * const FacePageViewFaceThemeStyle;


@interface FacePanel () <UIScrollViewDelegate, PanelBottomViewDelegate>

@property (nonatomic, strong) NSArray *faceSources;

@end

@implementation FacePanel
{
    UIScrollView *_scrollView;
    PanelBottomView  *_panelBottomView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FacePageViewFaceSelectedNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

#pragma mark -- 数据源
- (void)loadFaceThemeItems:(NSArray<FaceThemeModel *>*)themeItems;
{
    self.faceSources = themeItems;
    
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * self.faceSources.count, 0);
    
    for (int i = 0; i < self.faceSources.count; i++) {
        FaceThemeView *faceView = [[FaceThemeView alloc] initWithFrame:CGRectMake(i*CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
        [faceView loadFaceTheme:self.faceSources[i]];
        [_scrollView addSubview:faceView];
    }
    
    [_panelBottomView loadfaceThemePickerSource:self.faceSources];
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {
    
        CGFloat pageWidth = scrollView.frame.size.width;
    
        NSInteger currentIndex = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
        [_panelBottomView changeFaceSubjectIndex:currentIndex];
    }
}

#pragma mark -- PanelBottomViewDelegate
- (void)panelBottomView:(PanelBottomView *)panelBottomView didPickerFaceSubjectIndex:(NSInteger)faceSubjectIndex
{
    [_scrollView setContentOffset:CGPointMake(faceSubjectIndex*self.frame.size.width, 0) animated:YES];
}

- (void)panelBottomViewSendAction:(PanelBottomView *)panelBottomView
{
    if ([self.delegate respondsToSelector:@selector(facePanelSendTextAction:)]) {
        [self.delegate facePanelSendTextAction:self];
    }
}

#pragma mark -- NSNotificationCenter
- (void)facePageViewFaceSelected:(NSNotification *)noti
{
    NSDictionary *info = [noti object];
    NSString *faceName = [info objectForKey:FacePageViewFaceName];
    BOOL isDelete = [[info objectForKey:FacePageViewDeleteKey] boolValue];
    FaceThemeStyle themeStyle = [[info objectForKey:FacePageViewFaceThemeStyle] integerValue];
    
    if ([self.delegate respondsToSelector:@selector(facePanelFacePicked:faceStyle:faceName:isDeleteKey:)]) {
        [self.delegate facePanelFacePicked:self faceStyle:themeStyle faceName:faceName isDeleteKey:isDelete];
    }
}

- (void)initSubViews
{
    self.backgroundColor = kChatKeyBoardColor;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kFacePanelHeight-kFacePanelBottomToolBarHeight)];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    
    _panelBottomView = [[PanelBottomView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame), self.frame.size.width, kFacePanelBottomToolBarHeight)];
    _panelBottomView.delegate = self;
    [self addSubview:_panelBottomView];
    
    
    __weak __typeof(self) weakSelf = self;
    _panelBottomView.addAction = ^(){
        if ([weakSelf.delegate respondsToSelector:@selector(facePanelAddSubject:)]) {
            [weakSelf.delegate facePanelAddSubject:weakSelf];
        }
    };
    
    _panelBottomView.setAction = ^(){
        if ([weakSelf.delegate respondsToSelector:@selector(facePanelSetSubject:)]) {
            [weakSelf.delegate facePanelSetSubject:weakSelf];
        }
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facePageViewFaceSelected:) name:FacePageViewFaceSelectedNotification object:nil];
}


@end
