//
//  MorePannel.m
//  FaceKeyboard

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by ruofei on 16/3/31.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#import "MorePanel.h"
#import "MoreItem.h"
#import "ChatKeyBoardMacroDefine.h"

@class MoreItemView;

typedef void (^ItemViewAction)(MoreItemView *itemView);

@interface MoreItemView : UIView

@property (nonatomic, copy) ItemViewAction itemViewAction;

@end
@implementation MoreItemView
{
    UIButton    * _iconBtn;
    UILabel     * _nameLbl;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconBtn.frame = CGRectMake(0, 0, kMoreItemIconSize, kMoreItemIconSize);
        [_iconBtn addTarget:self action:@selector(iconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_iconBtn];
        
        _nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_iconBtn.frame), kMoreItemIconSize, kMoreItemH- kMoreItemIconSize)];
        _nameLbl.textAlignment = NSTextAlignmentCenter;
        _nameLbl.textColor = [UIColor blackColor];
        _nameLbl.font = [UIFont systemFontOfSize:13.f];
        [self addSubview:_nameLbl];
    }
    return self;
}

- (void)updateViewWithItem:(MoreItem *)item
{
    [_iconBtn setImage:[UIImage imageNamed:item.itemPicName] forState:UIControlStateNormal];
    [_iconBtn setImage:[UIImage imageNamed:item.itemHighlightPicName] forState:UIControlStateHighlighted];
    
    _nameLbl.text = item.itemName;
}

- (void)iconBtnClick:(UIButton *)sender
{
    if (self.itemViewAction) {
        self.itemViewAction(self);
    }
}

@end

@interface MorePanel () <UIScrollViewDelegate>

@end

@implementation MorePanel
{
    UIScrollView  *_contentView;
    UIPageControl * _pageControl;
}

+ (instancetype)morePannel
{
    return [[self alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-216, [[UIScreen mainScreen] bounds].size.width, 216)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kChatKeyBoardColor;
        
        _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kMorePanelHeight - kUIPageControllerHeight)];
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.pagingEnabled = YES;
        _contentView.delegate = self;
        [self addSubview:_contentView];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentView.frame), self.frame.size.width, kUIPageControllerHeight)];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        [self addSubview:_pageControl];
    }
    return self;
}

- (void)loadMoreItems:(NSArray<MoreItem *> *)items;
{
    NSInteger maxLinesOfPage = 2;
    NSInteger maxColsOfPage = 4;
    
    NSInteger pages = (items.count / (maxLinesOfPage * maxColsOfPage)) + 1;
    _pageControl.numberOfPages = pages;
    _contentView.contentSize = CGSizeMake(pages * self.frame.size.width, 0);
    
    CGFloat hMargin = (CGRectGetWidth(_contentView.frame) - kMoreItemIconSize * maxColsOfPage) / (maxColsOfPage + 1);
    CGFloat vMargin = (CGRectGetHeight(_contentView.frame) - kMoreItemH*maxLinesOfPage) / (maxLinesOfPage + 1);
    
    for (int i = 0; i < items.count; ++i) {
        NSInteger pageIndex = i / (maxLinesOfPage * maxColsOfPage);
        
        CGFloat x = pageIndex * CGRectGetWidth(_contentView.frame) + (i % maxColsOfPage) * (kMoreItemIconSize + hMargin) + hMargin;
        CGFloat y = ( (i - pageIndex * (maxLinesOfPage * maxColsOfPage) ) / maxColsOfPage) * (vMargin + kMoreItemH) + vMargin;
        
        MoreItem *item = items[i];
        MoreItemView *itemView = [[MoreItemView alloc] initWithFrame:CGRectMake(x, y, kMoreItemIconSize, kMorePanelHeight)];
        [itemView updateViewWithItem:item];
        itemView.tag = i;
        itemView.itemViewAction = ^(MoreItemView *itemView){
            if ([self.delegate respondsToSelector:@selector(morePannel:didSelectItemIndex:)]) {
                [self.delegate morePannel:self didSelectItemIndex:itemView.tag];
            }
        };
        [_contentView addSubview:itemView];
    }
}

#pragma mark -- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _contentView) {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger currentIndex = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
        _pageControl.currentPage = currentIndex;
    }
}

@end
