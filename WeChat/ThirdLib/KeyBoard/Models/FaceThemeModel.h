//
//  FaceModel.h
//  FaceKeyboard

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by ruofei on 16/3/30.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FaceThemeStyle)
{
    FaceThemeStyleSystemEmoji,       //30*30
    FaceThemeStyleCustomEmoji,       //40*40
    FaceThemeStyleGif                //60*60
};

@interface FaceModel : NSObject

/** 表情标题 */
@property (nonatomic, copy) NSString *faceTitle;
/** 表情图片 */
@property (nonatomic, copy) NSString *faceIcon;

@end

@interface FaceThemeModel : NSObject

@property (nonatomic, assign) FaceThemeStyle themeStyle;
@property (nonatomic, copy)   NSString *themeIcon;
@property (nonatomic, copy)   NSString *themeDecribe;
@property (nonatomic, strong) NSArray *faceModels;

@end
