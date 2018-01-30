//
//  WMPhotoBrowser.h
//  WMPhotoBrowser
//
//  Created by zhengwenming on 2018/1/2.
//  Copyright © 2018年 zhengwenming. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^DeleteBlock)(NSMutableArray *dataSource,NSUInteger currentIndex,UICollectionView *collectionView);
typedef void(^DownLoadBlock)(NSMutableArray *dataSource,UIImage *image,NSError *error);


@interface WMPhotoBrowser : UIViewController

/**
 *  需要预览的照片数组
 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 *  需要展示的当前的图片index
 */
@property (nonatomic, assign) NSInteger   currentPhotoIndex;

/**
 *  是否需要下载
 */
@property (assign, nonatomic)   BOOL downLoadNeeded;

/**
 *  是否需要删除
 */
@property (assign, nonatomic)   BOOL deleteNeeded;

/**
 *  下载回调
 */
@property (nonatomic, copy) DownLoadBlock    downLoadBlock;

/**
 *  删除回调
 */
@property (nonatomic, copy) DeleteBlock   deleteBlock;

@end


