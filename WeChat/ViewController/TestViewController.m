

//
//  TestViewController.m
//  WeChat
//
//  Created by zhengwenming on 16/6/4.
//  Copyright © 2016年 zhengwenming. All rights reserved.
//

#import "TestViewController.h"
#import "UIView+JGG.h"
#import "JGGView.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *picArray1 = @[
                         @"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160513/14631262033360.JPEG",
                         @"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160513/14631262036611.JPEG",
                         @"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160513/14631262041612.JPEG",
                         @"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160513/14631262041643.JPEG",
                         @"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160513/14631262041664.JPEG",
                         @"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160513/14631262041705.JPEG",
                         @"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160513/14631262041736.JPEG",
                         @"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160513/14631262041736.JPEG",
                         @"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160513/14631262041808.JPEG"
                         ];
    
    
    CGFloat jjg_height = 0.0;
    CGFloat jjg_width = 0.0;
    if (picArray1.count>0&&picArray1.count<=3) {
        jjg_height = [JGGView imageHeight];
        jjg_width  = (picArray1.count)*([JGGView imageWidth]+kGAP)-2*kGAP;
    }else if (picArray1.count>3&&picArray1.count<=6){
        jjg_height = 2*([JGGView imageHeight]+kGAP)-2*kGAP;
        jjg_width  = 3*([JGGView imageWidth]+kGAP)-2*kGAP;
    }else  if (picArray1.count>6&&picArray1.count<=9){
        jjg_height = 3*([JGGView imageHeight]+kGAP)-2*kGAP;
        jjg_width  = 3*([JGGView imageWidth]+kGAP)-2*kGAP;
    }
    
    
    JGGView *jggView1 = [JGGView new];
    [self.view addSubview:jggView1];
    
    [jggView1 JGGView:jggView1 DataSource:picArray1 completeBlock:^(NSInteger index, NSArray *dataSource,NSIndexPath *indexpath) {
        NSLog(@"%li",(long)index);
    }];
    jggView1.backgroundColor = [UIColor cyanColor];
    [jggView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        //将sv居中(很容易理解吧?)
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(70);
        make.size.mas_equalTo(CGSizeMake(jjg_width, jjg_height));
    }];

    
    
    
    NSArray *picArray2 = @[
                           @"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160513/14631262033360.JPEG",
                           @"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160513/14631262036611.JPEG",
                            @"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160513/14631262041612.JPEG",
                            @"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160513/14631262041643.JPEG",
                            @"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160513/14631262041664.JPEG",
                            @"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160513/14631262041705.JPEG",
                            @"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160513/14631262041736.JPEG",
                           @"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160513/14631262041808.JPEG"
                           ];
    
    if (picArray2.count>0&&picArray2.count<=3) {
        jjg_height = [JGGView imageHeight];
        jjg_width  = (picArray2.count)*([JGGView imageWidth]+kGAP)-kGAP;
    }else if (picArray2.count>3&&picArray2.count<=6){
        jjg_height = 2*([JGGView imageHeight]+kGAP)-kGAP;
        jjg_width  = 3*([JGGView imageWidth]+kGAP)-kGAP;
    }else  if (picArray2.count>6&&picArray2.count<=9){
        jjg_height = 3*([JGGView imageHeight]+kGAP)-kGAP;
        jjg_width  = 3*([JGGView imageWidth]+kGAP)-kGAP;
    }
    
    
    
    JGGView *jggView2 = [JGGView new];
    [self.view addSubview:jggView2];
    
    [jggView2 JGGView:jggView2 DataSource:picArray2 completeBlock:^(NSInteger index, NSArray *dataSource,NSIndexPath *indexpath) {
        NSLog(@"%li",(long)index);
    }];
    jggView2.backgroundColor = [UIColor cyanColor];
    [jggView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        //将sv居中(很容易理解吧?)
        make.left.mas_equalTo(jggView1);
        make.top.mas_equalTo(jggView1).offset(jjg_height+20);
        make.size.mas_equalTo(CGSizeMake(jjg_width, jjg_height));
    }];
    
    
    NSArray *picArray3 = @[
//                           @"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160513/14631262033360.JPEG",
                          @"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160513/14631262036611.JPEG",
                        @"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160513/14631262041612.JPEG",
                        @"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160513/14631262041643.JPEG",
                        @"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160513/14631262041664.JPEG",
                        @"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160513/14631262041705.JPEG",
                        @"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160513/14631262041736.JPEG",
                           @"http://weixintest.ihk.cn/ihkwx_upload/commentPic/20160513/14631262041808.JPEG"
                           ];
    
    if (picArray3.count>0&&picArray3.count<=3) {
        jjg_height = [JGGView imageHeight];
        jjg_width  = (picArray3.count)*([JGGView imageWidth]+kGAP)-kGAP;
    }else if (picArray3.count>3&&picArray3.count<=6){
        jjg_height = 2*([JGGView imageHeight]+kGAP)-kGAP;
        jjg_width  = 3*([JGGView imageWidth]+kGAP)-kGAP;
    }else  if (picArray3.count>6&&picArray3.count<=9){
        jjg_height = 3*([JGGView imageHeight]+kGAP)-kGAP;
        jjg_width  = 3*([JGGView imageWidth]+kGAP)-kGAP;
    }


    
    
    JGGView *jggView3 = [JGGView new];
    [self.view addSubview:jggView3];
    
    [jggView3 JGGView:jggView3 DataSource:picArray3 completeBlock:^(NSInteger index, NSArray *dataSource,NSIndexPath *indexpath) {
        NSLog(@"%li",(long)index);
    }];
    jggView3.backgroundColor = [UIColor redColor];
    [jggView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        //将sv居中(很容易理解吧?)
        make.left.mas_equalTo(jggView1);
        make.top.mas_equalTo(jggView2).offset(jjg_height+20);
        make.size.mas_equalTo(CGSizeMake(jjg_width, jjg_height));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
