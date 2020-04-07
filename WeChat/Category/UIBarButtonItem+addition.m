//
//  UIBarButtonItem+addition.m
//  TongXueBao
//
//  Created by 郑文明 on 16/10/19.
//  Copyright © 2016年 郑文明. All rights reserved.
//

@implementation BackView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    UINavigationBar *navBar = nil;
    UIView *aView = self.superview;
    while (aView) {
        if ([aView isKindOfClass:[UINavigationBar class]]) {
            navBar = (UINavigationBar *)aView;
            break;
        }
        aView = aView.superview;
    }
    UINavigationItem * navItem =   (UINavigationItem *)navBar.items.lastObject;
    UIBarButtonItem *leftItem = navItem.leftBarButtonItem;
    UIBarButtonItem *rightItem = navItem.rightBarButtonItem;

    
    if (rightItem) {//右边按钮
        BackView *backView = rightItem.customView;
//        backView.backgroundColor = [UIColor magentaColor];
//        backView.btn.backgroundColor = [UIColor yellowColor];
        if ([backView isKindOfClass:self.class]) {
            if ([[[UIDevice currentDevice] systemVersion]intValue]>=11) {
//                backView.btn.x = backView.width -backView.btn.width-20;
                backView.btn.x = backView.width -backView.btn.width;
            }else{
                backView.btn.x = backView.width -backView.btn.width;
            }
            for (UIView *aView in backView.subviews) {
                if ([aView isKindOfClass:[UILabel class]]) {
                    UILabel *textLabel = (UILabel *)aView;
                    [backView bringSubviewToFront:textLabel];
                }
            }
        }
    }
    if (leftItem) {//左边按钮
        BackView *backView = leftItem.customView;
//        backView.backgroundColor = [UIColor magentaColor];
//        backView.btn.backgroundColor = [UIColor yellowColor];

        if ([[[UIDevice currentDevice] systemVersion]intValue]>=11) {
            
        }else{
//            backView.btn.x = 20;
        }
    }
}



@end

#import "UIBarButtonItem+addition.h"

@implementation UIBarButtonItem (addition)
+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon
                         highIcon:(NSString *)highIcon
                           target:(id)target
                           action:(SEL)action {
    return  [self.class itemWithIcon:icon highIcon:highIcon title:nil target:target action:action];
}

+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon
                         highIcon:(NSString *)highIcon
                            title:(NSString *)title
                           target:(id)target
                           action:(SEL)action {
    BackView *customView = [[BackView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [customView addGestureRecognizer:tap];
    customView.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    customView.btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    if (icon) {
        [customView.btn setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    }
    if (highIcon) {
        [customView.btn setBackgroundImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    }
    customView.btn.frame = CGRectMake(0, 0, customView.btn.currentBackgroundImage.size.width, customView.btn.currentBackgroundImage.size.height);
    customView.btn.centerY = customView.centerY;
    [customView.btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:customView.btn];
    if (title.length) {
        customView.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(customView.btn.frame) + 5, CGRectGetMinY(customView.btn.frame), 80, 44)];
        customView.titleLabel.centerY = customView.btn.centerY;
        customView.titleLabel.text = title;
        customView.titleLabel.textColor = [UIColor whiteColor];
        customView.titleLabel.userInteractionEnabled = YES;
        [customView.titleLabel addGestureRecognizer:tap];
        [customView addSubview:customView.titleLabel];
    }
    
    return  [[UIBarButtonItem alloc] initWithCustomView:customView];
}

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title
                            target:(id)target
                            action:(SEL)action {
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [btn setTitleColor:kThemeColor forState:UIControlStateNormal];
    [btn setTitleColor:kThemeColor forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
    btn.frame = CGRectMake(0, 0, title.length * 22, 30);
//    btn.backgroundColor = [UIColor redColor];
    return  [[UIBarButtonItem alloc] initWithCustomView:btn];
}


@end
