//
//  WMPhotoBrowser.m
//  WMPhotoBrowser
//
//  Created by zhengwenming on 2018/1/2.
//  Copyright © 2018年 zhengwenming. All rights reserved.
//

#import "WMPhotoBrowser.h"
#import "WMPhotoBrowserCell.h"
#import "MBProgressHUD+Show.h"

@interface WMPhotoBrowser ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate> {
    
}
@property(nonatomic,assign)BOOL isHideNaviBar;
@property(nonatomic,strong) UICollectionView *collectionView;

@end

@implementation WMPhotoBrowser
- (instancetype)init{
    self = [super init];
    if (self) {
        if (@available(ios 11.0,*)) {
            UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            UITableView.appearance.estimatedRowHeight = 0;
            UITableView.appearance.estimatedSectionFooterHeight = 0;
            UITableView.appearance.estimatedSectionHeaderHeight = 0;
        }else{
            if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
                self.automaticallyAdjustsScrollViewInsets=NO;
            }
        }
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }else{

    }
}
-(void)deleteTheImage:(UIBarButtonItem *)sender{
        if (self.dataSource.count==1) {
            [self.dataSource removeObjectAtIndex:self.currentPhotoIndex];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.dataSource removeObjectAtIndex:self.currentPhotoIndex];
            self.title = [NSString stringWithFormat:@"%ld/%ld",self.currentPhotoIndex+1,self.dataSource.count];
            [self.collectionView reloadData];
        }
    
    if (self.deleteBlock) {
    self.deleteBlock(self.dataSource,self.currentPhotoIndex,self.collectionView);
    }
}
-(UICollectionView *)collectionView{
    if (_collectionView==nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollsToTop = NO;
        [_collectionView registerClass:[WMPhotoBrowserCell class] forCellWithReuseIdentifier:@"WMPhotoBrowserCell"];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentOffset = CGPointMake(0, 0);
        _collectionView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * self.dataSource.count, [UIScreen mainScreen].bounds.size.height);
    }
    return _collectionView;
}
#pragma mark
#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.downLoadNeeded) {
        UIButton *_saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveImageBtn.frame = CGRectMake(0, 0, 40, 40);
        _saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_saveImageBtn setImage:[UIImage imageNamed:@"savePicture"] forState:UIControlStateNormal];
        [_saveImageBtn setImage:[UIImage imageNamed:@"savePicture"] forState:UIControlStateHighlighted];
        [_saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_saveImageBtn];
    }else if(self.deleteNeeded){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteTheImage:)];
    }
    self.title = self.title?self.title:[NSString stringWithFormat:@"%ld/%ld",self.currentPhotoIndex+1,self.dataSource.count];
    self.view.backgroundColor = [UIColor blackColor];
    self.isHideNaviBar = NO;
    [self.view addSubview:self.collectionView];
    if (self.dataSource.count) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:(self.currentPhotoIndex) inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
}

- (void)saveImage{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentPhotoIndex inSection:0];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            WMPhotoBrowserCell *currentCell = (WMPhotoBrowserCell *)[_collectionView cellForItemAtIndexPath:indexPath];
            UIImageWriteToSavedPhotosAlbum(currentCell.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        });
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showErrorWithText:@"保存失败"];
    } else {
        [MBProgressHUD showSuccessWithText:@"保存成功"];
    }
    if (self.downLoadBlock) {
        self.downLoadBlock(self.dataSource,image,error);
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.title isEqualToString:@"图片预览"]) {
        
    }else{
        CGPoint offSet = scrollView.contentOffset;
        self.currentPhotoIndex = offSet.x / self.view.width;
        self.title = [NSString stringWithFormat:@"%ld/%ld",self.currentPhotoIndex+1,self.dataSource.count];
    }
//    if (self.currentPhotoIndex==0) {
//        scrollView.bounces = NO;
//    }else{
//        scrollView.bounces = YES;
//    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

#pragma mark - UICollectionViewDataSource && Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WMPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMPhotoBrowserCell" forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    __weak typeof(self) weakSelf = self;
    if (!cell.singleTapGestureBlock) {
        cell.singleTapGestureBlock = ^(){
            if (weakSelf.navigationController) {
                if (weakSelf.isHideNaviBar==YES) {
                    [weakSelf.navigationController setNavigationBarHidden:NO animated:YES];
                }else{
                    [weakSelf.navigationController setNavigationBarHidden:YES animated:YES];
                }
                weakSelf.isHideNaviBar = !weakSelf.isHideNaviBar;
            }else{
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }
        };
    }
    
    
    if (!cell.longPressGestureBlock) {
        cell.longPressGestureBlock = ^(WMPhotoBrowserCell *cell) {
            
            UIAlertController *alertAction = [UIAlertController alertControllerWithTitle:@"保存图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [alertAction addAction:[UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIImageWriteToSavedPhotosAlbum(cell.imageView.image, weakSelf,
                                               @selector(image:didFinishSavingWithError:contextInfo:), nil);
            }]];
            
            [alertAction addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"取消");
            }]];
            [weakSelf presentViewController:alertAction animated:YES completion:^{
                
            }];
        };
    }
    
    
    cell.currentIndexPath = indexPath;
    self.title = [NSString stringWithFormat:@"%ld/%ld",self.currentPhotoIndex+1,self.dataSource.count];
    return cell;
}
- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

