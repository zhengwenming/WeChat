//
//  AddressBookCell.h
//  IHKApp
//
//  Created by 郑文明 on 15/4/23.
//  Copyright (c) 2015年 www.ihk.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendInfoModel.h"

@interface AddressBookCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property(nonatomic,strong)FriendInfoModel *frendModel;
@end
