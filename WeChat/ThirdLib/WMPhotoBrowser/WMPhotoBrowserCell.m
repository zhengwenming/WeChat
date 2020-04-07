//
//  WMPhotoBrowserCell.m
//  WMPhotoBrowser
//
//  Created by zhengwenming on 2018/1/2.
//  Copyright © 2018年 zhengwenming. All rights reserved.
//

#import "WMPhotoBrowserCell.h"
#import "UIImageView+WebCache.h"

@interface WMPhotoBrowserCell ()<UIGestureRecognizerDelegate,UIScrollViewDelegate> {
    CGFloat _aspectRatio;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *imageContainerView;
@end

@implementation WMPhotoBrowserCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.scrollView.bouncesZoom = YES;
        self.scrollView.backgroundColor = [UIColor blackColor];
        self.scrollView.maximumZoomScale = 2.5;//放大比例
        self.scrollView.minimumZoomScale = 1.0;//缩小比例
        self.scrollView.multipleTouchEnabled = YES;
        self.scrollView.delegate = self;
        self.scrollView.scrollsToTop = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.scrollView.delaysContentTouches = NO;
        self.scrollView.canCancelContentTouches = YES;
        self.scrollView.alwaysBounceVertical = NO;
        [self.contentView addSubview:self.scrollView];
        
        self.imageContainerView = [[UIView alloc] init];
        self.imageContainerView.clipsToBounds = YES;
        [self.scrollView addSubview:self.imageContainerView];
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        self.imageView.clipsToBounds = YES;
        self.imageView.userInteractionEnabled = YES;
        [self.imageContainerView addSubview:self.imageView];
        //单击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self.contentView addGestureRecognizer:singleTap];
        //双击
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [singleTap requireGestureRecognizerToFail:doubleTap];
        [self.contentView addGestureRecognizer:doubleTap];
        //长按
        UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToSavePhoto:)];
        [self.contentView addGestureRecognizer:longPressGes];
    }
    return self;
}

-(void)longPressToSavePhoto:(UILongPressGestureRecognizer *)sender{
    if (sender.state== UIGestureRecognizerStateBegan){
        if (self.longPressGestureBlock) {
            self.longPressGestureBlock(self);
        }
    }
}

- (void)resizeSubviews {
    self.imageContainerView.origin = CGPointZero;
    self.imageContainerView.width = self.width;
    UIImage *image = self.imageView.image;
    if (image.size.height/image.size.width >self.height/self.width) {
        self.imageContainerView.height = floor(image.size.height / (image.size.width / self.width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.width;
        if (height < 1 || isnan(height)) height = self.height;
        height = floor(height);
        self.imageContainerView.height = height;
        self.imageContainerView.centerY = self.height / 2;
    }
    if (self.imageContainerView.height > self.height && self.imageContainerView.height - self.height <= 1) {
        self.imageContainerView.height = self.height;
    }
    self.scrollView.contentSize = CGSizeMake(self.width, MAX(self.imageContainerView.height, self.height));
    [self.scrollView scrollRectToVisible:self.bounds animated:NO];
    self.scrollView.alwaysBounceVertical = self.imageContainerView.height <= self.height ? NO : YES;
    self.imageView.frame = self.imageContainerView.bounds;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self resizeSubviews];
}
#pragma mark - UITapGestureRecognizer Event

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (self.scrollView.zoomScale > 1.0) {
        [self.scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = self.scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)setModel:(id )model {
    _model = model;
    [self.scrollView setZoomScale:1.0 animated:NO];
    if ([model isKindOfClass:[UIImage class]]){
        UIImage *aImage = (UIImage *)model;
        self.imageView.image = aImage;
    }else if ([model isKindOfClass:[NSString class]]){
        NSString *aString = (NSString *)model;
        if ([aString rangeOfString:@"http"].location!=NSNotFound) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:aString] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [self resizeSubviews];
            }];
        }else{
            self.imageView.image = [UIImage imageNamed:aString];
        }
    }else if ([model isKindOfClass:[NSURL class]]){
        NSURL *aURL = (NSURL *)model;
        [self.imageView sd_setImageWithURL:aURL placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self resizeSubviews];
        }];
    }
//    else if ([model isKindOfClass:[IMAMsg class]]){
//        IMAMsg *aImageMsg = (IMAMsg *)model;
//        TIMImageElem *elem = (TIMImageElem *)[aImageMsg.msg getElem:0];
//        [elem asyncThumbImage:^(NSString *path, UIImage *image, BOOL succ, BOOL isAsync) {
//            if ([path containsString:@"http"]) {
//                [self.imageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"ablePlaceHolder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                    [self resizeSubviews];
//                }];
//            }
//            
//        } inMsg:aImageMsg];
//    }
    [self resizeSubviews];
}
- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock();
    }
}

#pragma mark - UIScrollViewDelegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageContainerView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.width > scrollView.contentSize.width) ? (scrollView.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.height > scrollView.contentSize.height) ? (scrollView.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageContainerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.scrollView.contentOffset.x <= 0) {
        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
            return YES;
        }
    }
    return NO;
}

@end

