//
//  PageFaceView.h
//  FaceKeyboard

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by ruofei on 16/3/30.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceThemeModel.h"
/**
    负责展示主题的每一页
 */
@interface FacePageView : UICollectionViewCell

@property (nonatomic, assign) FaceThemeStyle themeStyle;

- (void)loadPerPageFaceData:(NSArray *)faceData;

@end
