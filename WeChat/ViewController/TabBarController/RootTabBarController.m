//
//  RootTabBarController.m
//  WeChat
//
//  Created by zhengwenming on 16/6/5.
//  Copyright © 2016年 zhengwenming. All rights reserved.
//

#import "RootTabBarController.h"
#import "BaseNavigationController.h"

#define kSelImgKey  @"selectedImageName"
@interface RootTabBarController ()

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITabBar appearance] setTranslucent:NO];
    NSArray *childItemsArray = @[
                                 @{@"rootVCClassString"  : @"HomeViewController",
                                   @"title"  : @"微信",
                                   @"imageName"    : @"tabbar_mainframe",
                                   @"selectedImageName" : @"tabbar_mainframeHL"},
                                 
                                 @{@"rootVCClassString"  : @"ContactsViewController",
                                   @"title"  : @"通讯录",
                                   @"imageName"    : @"tabbar_contacts",
                                   @"selectedImageName" : @"tabbar_contactsHL"},
                                 
                                 @{@"rootVCClassString"  : @"DiscoverViewController",
                                   @"title"  : @"发现",
                                   @"imageName"    : @"tabbar_discover",
                                   @"selectedImageName" : @"tabbar_discoverHL"},
                                 
                                 @{@"rootVCClassString"  : @"MeViewController",
                                   @"title"  : @"我",
                                   @"imageName"    : @"tabbar_me",
                                   @"selectedImageName" : @"tabbar_meHL"} ];
    
    [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        UIViewController *vc = [NSClassFromString(dict[@"rootVCClassString"]) new];
        vc.title = dict[@"title"];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.title = dict[@"title"];
        item.image = [UIImage imageNamed:dict[@"imageName"]];
        item.selectedImage = [[UIImage imageNamed:dict[@"selectedImageName"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : kThemeColor} forState:UIControlStateSelected];
        [self addChildViewController:nav];
    }];
    self.tabBar.tintColor = kThemeColor;
//    self.tabBar.unselectedItemTintColor = kThemeColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
