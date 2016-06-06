//
//  ChatFacePanel.h
//  FaceKeyboard

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by ruofei on 16/3/30.
//  Copyright © 2016年 ruofei. All rights reserved.
//


/**
 *  管理所有的表情主题
 */

#import <UIKit/UIKit.h>
#import "FaceThemeModel.h"

@class FacePanel;
@protocol FacePanelDelegate <NSObject>
@optional
- (void)facePanelFacePicked:(FacePanel *)facePanel faceStyle:(FaceThemeStyle)themeStyle faceName:(NSString *)faceName isDeleteKey:(BOOL)deletekey;
- (void)facePanelSendTextAction:(FacePanel *)facePanel;
- (void)facePanelAddSubject:(FacePanel *)facePanel;
- (void)facePanelSetSubject:(FacePanel *)facePanel;

@end

@interface FacePanel : UIView

@property (nonatomic, weak) id<FacePanelDelegate> delegate;

- (void)loadFaceThemeItems:(NSArray<FaceThemeModel *>*)themeItems;

@end
