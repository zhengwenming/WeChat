//
//  ConversationViewController.m
//  WeChat
//
//  Created by zhengwenming on 2020/4/13.
//  Copyright © 2020 zhengwenming. All rights reserved.
//

#import "ConversationViewController.h"


@interface ConversationViewController()<UITableViewDelegate,UITableViewDataSource>
{
}
@property(nonatomic,strong)UITableView *messageList;
@property(nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation ConversationViewController
-(NSMutableArray *)dataSource{
    if (_dataSource==nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(UITableView *)messageList{
    if (_messageList==nil) {
        _messageList = [UITableView new];
        _messageList.delegate = self;
        _messageList.dataSource = self;
        _messageList.rowHeight = 50.f;
        _messageList.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        [_messageList registerNib:[UINib nibWithNibName:NSStringFromClass([AddressBookCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AddressBookCell class])];
    }
    return _messageList;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    for (NSInteger index = 0; index<30; index++) {
        [self.dataSource addObject:[NSString stringWithFormat:@"%ld",(long)index]];
    }
   
    [self.view addSubview:self.messageList];
    [self.messageList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.messageList mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 80, 0));
//        }];
//    });
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}
@end
