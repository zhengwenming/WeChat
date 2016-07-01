

//
//  BaseViewController.m
//  WeChat
//
//  Created by zhengwenming on 16/6/4.
//  Copyright © 2016年 zhengwenming. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor]; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
-(int)getRandomNumber:(int)from to:(int)to

{
    
    return (int)(from + (arc4random() % (to - from + 1)));
    
}
@end
