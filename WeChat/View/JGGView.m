//
//  JGGView.m
//  IHK
//
//  Created by 郑文明 on 16/3/14.
//  Copyright © 2016年 郑文明. All rights reserved.
//

#import "JGGView.h"
#import "UIImageView+WebCache.h"



@implementation JGGView

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource completeBlock:(TapBlcok )tapBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        for (NSUInteger i=0; i<dataSource.count; i++) {
            UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0+([JGGView imageWidth]+kJGG_GAP)*(i%3),floorf(i/3.0)*([JGGView imageHeight]+kJGG_GAP),[JGGView imageWidth], [JGGView imageHeight])];
            if ([dataSource[i] isKindOfClass:[UIImage class]]) {
                iv.image = dataSource[i];
            }else if ([dataSource[i] isKindOfClass:[NSString class]]){
                [iv sd_setImageWithURL:[NSURL URLWithString:dataSource[i]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            }else if ([dataSource[i] isKindOfClass:[NSURL class]]){
                [iv sd_setImageWithURL:dataSource[i] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            }
            self.dataSource = dataSource;
            self.tapBlock = tapBlock;// 一定要给self.tapBlock赋值
            iv.userInteractionEnabled = YES;//默认关闭NO，打开就可以接受点击事件
            iv.tag = i;
            [self addSubview:iv];
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageAction:)];
            [iv addGestureRecognizer:singleTap];
        }
    }
    return self;
}
-(void)JGGView:(JGGView *)jggView DataSource:(NSArray *)dataSource completeBlock:(TapBlcok)tapBlock
{
        for (NSUInteger i=0; i<dataSource.count; i++) {
            UIImageView *iv = [UIImageView new];
            if ([dataSource[i] isKindOfClass:[UIImage class]]) {
                iv.image = dataSource[i];
            }else if ([dataSource[i] isKindOfClass:[NSString class]]){
                [iv sd_setImageWithURL:[NSURL URLWithString:dataSource[i]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            }else if ([dataSource[i] isKindOfClass:[NSURL class]]){
                [iv sd_setImageWithURL:dataSource[i] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            }
            jggView.dataSource = dataSource;
            jggView.tapBlock = tapBlock;
            iv.userInteractionEnabled = YES;//默认关闭NO，打开就可以接受点击事件
            iv.tag = i;
            [jggView addSubview:iv];
            //九宫格的布局
            CGFloat  Direction_X = (([JGGView imageWidth]+kJGG_GAP)*(i%3));
            CGFloat  Direction_Y  = (floorf(i/3.0)*([JGGView imageHeight]+kJGG_GAP));
            
            [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(jggView).offset(Direction_X);
                make.top.mas_equalTo(jggView).offset(Direction_Y);
                make.size.mas_equalTo(CGSizeMake([JGGView imageWidth], [JGGView imageHeight]));
            }];
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:jggView action:@selector(tapImageAction:)];
            [iv addGestureRecognizer:singleTap];
        }
    
}
#pragma mark
#pragma mark 配置图片的宽高
+(CGFloat)imageWidth{
    return ([UIScreen mainScreen].bounds.size.width-(2*kGAP+kAvatar_Size)*2)/3;
}
+(CGFloat)imageHeight{
    return ([UIScreen mainScreen].bounds.size.width-(2*kGAP+kAvatar_Size)*2)/3;
}
-(void)tapImageAction:(UITapGestureRecognizer *)tap{
    UIImageView *tapView = (UIImageView *)tap.view;
    
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = tapView.tag;
    photoBrowser.imageCount = _dataSource.count;
    photoBrowser.sourceImagesContainerView = self;
    [photoBrowser show];
    
    
    if (self.tapBlock) {
        self.tapBlock(tapView.tag,self.dataSource,self.indexpath);
    }
}
#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlString = self.dataSource[index];
    return [NSURL URLWithString:urlString];
}
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = self.subviews[index];
    return imageView.image;
}
@end
