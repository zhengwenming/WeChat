//
//  WMSearchController.m
//  WeChat
//
//  Created by zhengwenming on 2018/4/3.
//  Copyright © 2018年 zhengwenming. All rights reserved.
//

#import "WMSearchController.h"

@interface WMSearchController ()

@end

@implementation WMSearchController
+ (WMSearchController *)searchController:(UIViewController<WMSearchResultControllerProtocol> *)resultsController{
    if (!resultsController) {
        return nil;
    }
    WMSearchController *searchController = [[WMSearchController alloc] initWithSearchResultsController:resultsController];
    searchController.searchResultsUpdater = resultsController;
    return searchController;
}

- (instancetype)initWithSearchResultsController:(UIViewController<WMSearchResultControllerProtocol>  *)searchResultsController{
    if (self = [super initWithSearchResultsController:searchResultsController]) {
        [self setDelegate:searchResultsController];
        self.searchBar.placeholder = @"搜索";
        self.searchBar.delegate = searchResultsController;
        self.searchBar.translucent = NO;
        self.searchBar.tintColor = kThemeColor;
        
//        for (UIView *view in self.searchBar.subviews[0].subviews) {
//            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
//                if (view) {
////                    [view removeFromSuperview];
//                }
//                break;
//            }
//        }
        
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"取消"];
        }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
-(void)viewDidLoad{
    [super viewDidLoad];
}
- (void)setEnableVoiceInput:(BOOL)showVoiceButton{
    _enableVoiceInput = showVoiceButton;
    [self.searchBar setShowsBookmarkButton:showVoiceButton];
    if (showVoiceButton) {
        [self.searchBar setImage:[UIImage imageNamed:@"VoiceSearchStartBtn"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
        [self.searchBar setImage:[UIImage imageNamed:@"VoiceSearchStartBtnHL"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateHighlighted];
    }
}

@end

