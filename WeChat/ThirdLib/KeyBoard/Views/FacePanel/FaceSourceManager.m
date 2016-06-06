//
//  FaceSourceManager.m
//  FaceKeyboard

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by ruofei on 16/3/30.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#import "FaceSourceManager.h"

@implementation FaceSourceManager

//从持久化存储里面加载表情源
+ (NSArray *)loadFaceSource
{
    NSMutableArray *subjectArray = [NSMutableArray array];
    
    NSArray *sources = @[@"face", @"systemEmoji",@"emotion",@"systemEmoji",@"face",@"systemEmoji",@"emotion",@"emotion",@"face",@"face",@"emotion",@"face", @"emotion",@"face", @"emotion"];
    
    for (int i = 0; i < sources.count; ++i)
    {
        NSString *plistName = sources[i];
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
        NSDictionary *faceDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        NSArray *allkeys = faceDic.allKeys;
        
        FaceThemeModel *themeM = [[FaceThemeModel alloc] init];
        
        if ([plistName isEqualToString:@"face"]) {
            themeM.themeStyle = FaceThemeStyleCustomEmoji;
            themeM.themeDecribe = [NSString stringWithFormat:@"f%d", i];
            themeM.themeIcon = @"section0_emotion0";
        }else if ([plistName isEqualToString:@"systemEmoji"]){
            themeM.themeStyle = FaceThemeStyleSystemEmoji;
            themeM.themeDecribe = @"sEmoji";
            themeM.themeIcon = @"";
        }
        else {
            themeM.themeStyle = FaceThemeStyleGif;
            themeM.themeDecribe = [NSString stringWithFormat:@"e%d", i];
            themeM.themeIcon = @"f_static_000";
        }
        
        
        NSMutableArray *modelsArr = [NSMutableArray array];
        
        for (int i = 0; i < allkeys.count; ++i) {
            NSString *name = allkeys[i];
            FaceModel *fm = [[FaceModel alloc] init];
            fm.faceTitle = name;
            fm.faceIcon = [faceDic objectForKey:name];
            [modelsArr addObject:fm];
        }
        themeM.faceModels = modelsArr;
        
        [subjectArray addObject:themeM];
    }
    
    
    return subjectArray;
}


@end
