//
//  BaseNavigationController.m
//  WeChat
//
//  Created by zhengwenming on 16/6/5.
//  Copyright © 2016年 zhengwenming. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@end

@implementation BaseNavigationController
//  防止导航控制器只有一个rootViewcontroller时触发手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //解决与左滑手势冲突
    CGPoint translation = [self.panGesture translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    if (self.childViewControllers.count > 1) {
        if (self.visibleViewController.isHideBackItem) {
            return NO;
        }else {
            if ([self.visibleViewController respondsToSelector:@selector(fullScreenGestureShouldBegin)]) {
                return [self.visibleViewController fullScreenGestureShouldBegin];
            }
        }
    }
    return self.childViewControllers.count == 1 ? NO : YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = [UIColor whiteColor];
    bar.tintColor = kThemeColor;
    bar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    
    
    UIGestureRecognizer *systemGes = self.interactivePopGestureRecognizer;
    id target =  systemGes.delegate;
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:NSSelectorFromString(@"handleNavigationTransition:")];
    [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.panGesture];

    self.panGesture.delegate = self;
    systemGes.enabled = NO;
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
        if (viewController.isHideBackItem) {
            viewController.navigationItem.hidesBackButton = YES;
        }else{
            viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:[viewController backIconName] highIcon:nil target:self action:@selector(back:)];
        }
    }
    [super pushViewController:viewController animated:animated];
}
-(void)back:(UIBarButtonItem *)sender{
    [self.view endEditing:YES];
    if ([self.visibleViewController isKindOfClass:[BaseViewController class]]) {
        BaseViewController *currentVC = (BaseViewController *)self.visibleViewController;
        if (currentVC.popBlock) {
            currentVC.popBlock(sender);
        }else{
            [self popViewControllerAnimated:YES];
        }
    }else{
        [self popViewControllerAnimated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
