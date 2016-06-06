//
//  PageFaceView.m
//  FaceKeyboard

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by ruofei on 16/3/30.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#import "FacePageView.h"
#import "FaceThemeView.h"
#import "FaceButton.h"
#import "ChatKeyBoardMacroDefine.h"

#define FaceContainerHeight       kFacePanelHeight - kFacePanelBottomToolBarHeight - kUIPageControllerHeight //146

#define DeleteKey       @"DeleteKey"

NSString * const FacePageViewFaceSelectedNotification = @"FacePageViewFaceSelectedNotification";
NSString * const FacePageViewFaceName = @"FacePageViewFaceName";
NSString * const FacePageViewDeleteKey = @"FacePageViewDeleteKey";
NSString * const FacePageViewFaceThemeStyle = @"FacePageViewFaceThemeStyle";

@interface  FacePageView ()
/** 按钮数组 */
@property (nonatomic, strong) NSMutableArray *buttons;
@end

@implementation FacePageView

- (void)prepareForReuse
{
    [super prepareForReuse];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initSystemEmojiFace];
    }
    return self;
}

- (void)setThemeStyle:(FaceThemeStyle)themeStyle
{
    if (_themeStyle != themeStyle)
    {
        _themeStyle = themeStyle;
        
        switch (_themeStyle) {
            case FaceThemeStyleSystemEmoji:
                [self initSystemEmojiFace];
                break;
            case FaceThemeStyleCustomEmoji:
                [self initCustomEmojiFace];
                break;
            case FaceThemeStyleGif:
                [self initGifFace];
                break;
            default:
                break;
        }
    }
}

- (void)initSystemEmojiFace
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger cols = 8;
    if (isIPhone4_5) {cols = 7;}else if (isIPhone6_6s) {cols = 8;}else if (isIPhone6p_6sp){cols = 9;}
    NSInteger lines = 3;
    
    CGFloat item = 40.f;//30
    NSInteger edgeDistance = 10.f;
    
    CGFloat vMargin = (FaceContainerHeight - lines * item) / (lines+1);
    CGFloat hMargin = (CGRectGetWidth(self.bounds) - cols * item - 2*edgeDistance) / cols;
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < lines; ++i) {
        for (int j = 0; j < cols; ++j) {
            FaceButton *btn = [FaceButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(j*item+edgeDistance+j*hMargin,i*item+(i+1)*vMargin,item,item);
            [btn addTarget:self action:@selector(faceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
            [array addObject:btn];
        }
    }
    self.buttons = array;
}

- (void)initCustomEmojiFace
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger cols = 7;
    if (isIPhone4_5) {cols = 7;}else if (isIPhone6_6s) {cols = 8;}else if (isIPhone6p_6sp){cols = 9;}
    
    NSInteger lines = 3;
    CGFloat item = 40.f;
    NSInteger edgeDistance = 10;
    
    CGFloat vMargin = (FaceContainerHeight - lines * item) / (lines+1);
    CGFloat hMargin = (CGRectGetWidth(self.bounds) - cols * item - 2*edgeDistance) / cols;
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < lines; ++i) {
        for (int j = 0; j < cols; ++j) {
            FaceButton *btn = [FaceButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(j*item+edgeDistance+j*hMargin,i*item+(i+1)*vMargin,item,item);
            [btn addTarget:self action:@selector(faceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
            [array addObject:btn];
        }
    }
    self.buttons = array;
}

- (void)initGifFace
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger cols = 4;
    NSInteger lines = 2;
    CGFloat item = 60.f;
    
    CGFloat vMargin = (FaceContainerHeight - lines * item) / (lines+1);
    CGFloat hMargin = (CGRectGetWidth(self.bounds) - cols * item) / (cols+1);
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < lines; ++i) {
        for (int j = 0; j < cols; ++j) {
            FaceButton *btn = [FaceButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(j*item+(j+1)*hMargin,i*item+(i+1)*vMargin,item,item);
            [btn addTarget:self action:@selector(faceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
            [array addObject:btn];
        }
    }
    self.buttons = array;
}

- (void)loadPerPageFaceData:(NSArray *)faceData;
{
    switch (_themeStyle) {
        case FaceThemeStyleSystemEmoji:
            [self loadSystemEmoji:faceData];
            break;
        case FaceThemeStyleCustomEmoji:
            [self loadCustomEmoji:faceData];
            break;
        case FaceThemeStyleGif:
            [self loadGifEmoji:faceData];
            break;
        default:
            break;
    }
}

- (void)loadSystemEmoji:(NSArray *)faceData
{
    for (int i = 0; i < faceData.count; i++) {
        FaceModel *fm = faceData[i];
        FaceButton *btn = self.buttons[i];
        btn.hidden = NO;
        [btn setTitle:fm.faceIcon forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:25.f];
        [btn setImage:nil forState:UIControlStateNormal];
        btn.faceTitle = fm.faceTitle;
    }
    
    FaceButton *btn =self.buttons[faceData.count];
    btn.hidden = NO;
    [btn setTitle:nil forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"Delete_ios7"] forState:UIControlStateNormal];
    btn.faceTitle = DeleteKey;
    
    for (NSInteger i = faceData.count+1; i < self.buttons.count; ++i) {
        FaceButton *btn = self.buttons[i];
        btn.hidden = YES;
        btn.faceTitle = nil;
        [btn setImage:nil forState:UIControlStateNormal];
        [btn setTitle:nil forState:UIControlStateNormal];
    }
}

- (void)loadCustomEmoji:(NSArray *)faceData
{
    for (int i = 0; i < faceData.count; i++) {
        FaceModel *fm = faceData[i];
        FaceButton *btn = self.buttons[i];
        btn.hidden = NO;
        [btn setImage:[UIImage imageNamed:fm.faceIcon] forState:UIControlStateNormal];
        btn.faceTitle = fm.faceTitle;
    }
    
    FaceButton *btn =self.buttons[faceData.count];
    btn.hidden = NO;
    [btn setImage:[UIImage imageNamed:@"Delete_ios7"] forState:UIControlStateNormal];
    btn.faceTitle = DeleteKey;
    
    for (NSInteger i = faceData.count+1; i < self.buttons.count; ++i) {
        FaceButton *btn = self.buttons[i];
        btn.hidden = YES;
        btn.faceTitle = nil;
        [btn setImage:nil forState:UIControlStateNormal];
    }
}

- (void)loadGifEmoji:(NSArray *)faceData
{
    for (int i = 0; i < faceData.count; i++) {
        FaceModel *fm = faceData[i];
        FaceButton *btn = self.buttons[i];
        btn.hidden = NO;
        [btn setImage:[UIImage imageNamed:fm.faceIcon] forState:UIControlStateNormal];
        btn.faceTitle = fm.faceTitle;
    }
    
    for (NSInteger i = faceData.count; i < self.buttons.count; ++i) {
        FaceButton *btn = self.buttons[i];
        btn.hidden = YES;
        btn.faceTitle = nil;
        [btn setImage:nil forState:UIControlStateNormal];
    }
}

- (void)faceBtnClick:(FaceButton *)button
{
    BOOL deleteKey = NO;
    if ([button.faceTitle isEqualToString:DeleteKey]) {
        deleteKey = YES;
    }
    NSDictionary *faceInfo = @{
                               FacePageViewFaceName : button.faceTitle ? button.faceTitle : @"",
                               FacePageViewDeleteKey : @(deleteKey),
                               FacePageViewFaceThemeStyle : @(self.themeStyle)
                               };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FacePageViewFaceSelectedNotification object:faceInfo];
}

@end
