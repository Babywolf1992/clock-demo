//
//  ClockViewContrller.m
//  zdnz
//
//  Created by babywolf on 16/1/3.
//  Copyright © 2016年 com.babywolf. All rights reserved.
//

#import "ClockViewContrller.h"
#import "UIViewExt.h"
#import "AFHTTPRequestOperationManager.h"
#import "WFUser.h"
#import "WFClock.h"
#import "WFMeeting.h"
#import "WFAnniversary.h"
#import "ModifyViewController.h"
#import "Contants.h"

@interface ClockViewContrller()

@property (nonatomic, strong) UIView *indexView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WFUser *user;

@end

@implementation ClockViewContrller

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"我的闹钟";
    }
    return self;
}

- (WFUser *)user {
    if (!_user) {
        _user = [WFUser sharedUser];
    }
    return _user;
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSArray alloc] init];
    }
    return _dataArr;
}

- (instancetype)initWithMode:(ShowMode)mode {
    if (self = [super init]) {
        self.title = @"我的闹钟";
        self.mode = mode;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    [self clearExtraLine:_tableView];
}

- (void)loadData {
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *url = kGetAlarmURL;
    NSDictionary *parameters = @{@"userId":self.user.user_id,@"token":_user.token};
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *arr = [responseObject objectForKey:@"alarms"];
        NSMutableArray *mArr = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            WFClock *clock = [[WFClock alloc] init];
            clock.clock_id = [dic objectForKey:@"_id"];
            clock.title = [dic objectForKey:@"title"];
            clock.repeatType = [[dic objectForKey:@"repeatType"] intValue];
            clock.remindTime = [dic objectForKey:@"remindTime"];
            if ([dic objectForKey:@"repeatRule"]) {
                clock.repeatRule = [dic objectForKey:@"repeatRule"];
            }
            [mArr addObject:clock];
        }
        self.dataArr = mArr;
        [self.tableView reloadData];
        [self clearExtraLine:_tableView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
}

- (void)loadMeetingData {
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *url = kGetMeetingURL;
    NSDictionary *parameters = @{@"userId":self.user.user_id,@"token":_user.token};
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
        NSArray *arr = [responseObject objectForKey:@"meetings"];
        NSMutableArray *mArr = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            WFMeeting *meeting = [[WFMeeting alloc] init];
            meeting.meeting_id = [dic objectForKey:@"_id"];
            meeting.title = [dic objectForKey:@"title"];
            meeting.repeatType = [[dic objectForKey:@"repeatType"] intValue];
            meeting.remindTime = [dic objectForKey:@"remindTime"];
            meeting.preTime = [dic objectForKey:@"preTime"];
            meeting.mute = [dic objectForKey:@"mute"];
            if ([dic objectForKey:@"repeatRule"]) {
                meeting.repeatRule = [dic objectForKey:@"repeatRule"];
            }
            [mArr addObject:meeting];
        }
        _dataArr = mArr;
        [_tableView reloadData];
        [self clearExtraLine:_tableView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)loadAnnData {
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *url = kGetAnnURL;
    NSDictionary *parameters = @{@"userId":self.user.user_id,@"token":_user.token};
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
        NSArray *arr = [responseObject objectForKey:@"anniversaries"];
        NSMutableArray *mArr = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            WFAnniversary *ann = [[WFAnniversary alloc] init];
            ann.anniversary_id = [dic objectForKey:@"_id"];
            ann.title = [dic objectForKey:@"title"];
            ann.repeatType = [[dic objectForKey:@"repeatType"] intValue];
            ann.remindTime = [dic objectForKey:@"remindTime"];
            ann.mute = [dic objectForKey:@"mute"];
            ann.advanceDays = [dic objectForKey:@"advanceDays"];
            if ([dic objectForKey:@"repeatRule"]) {
                ann.repeatRule = [dic objectForKey:@"repeatRule"];
            }
            [mArr addObject:ann];
        }
        _dataArr = mArr;
        [_tableView reloadData];
        [self clearExtraLine:_tableView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadIndexView];
    [self loadTableView];
    if (self.mode == 0) {
        [self loadData];
    }else if (self.mode == 1) {
        [self loadMeetingData];
    }else if (self.mode == 2) {
        [self loadAnnData];
    }
    
}

- (void)loadIndexView {
    _indexView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 40)];
//    _indexView.backgroundColor = [UIColor redColor];
    NSArray *arr = @[@"闹钟",@"会议",@"纪念日"];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*_indexView.width/3, 0, _indexView.width/3, 40)];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(changeMode:) forControlEvents:UIControlEventTouchUpInside];
        if (self.mode == i) {
            btn.selected = YES;
        }
        btn.tag = i;
        [_indexView addSubview:btn];
    }
    [self.view addSubview:_indexView];
}

- (void)loadTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _indexView.bottom, self.view.width, self.view.height-_indexView.bottom)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.allowsSelection = NO;
    [self.view addSubview:_tableView];
}

#pragma mark - click Method
- (void)changeMode:(UIButton *)sender {
    self.mode = (int)sender.tag;
    if (self.mode == 0) {
        [self loadData];
    }else if (self.mode == 1) {
        [self loadMeetingData];
    }else if (self.mode == 2) {
        [self loadAnnData];
    }
    for (UIButton *btn in _indexView.subviews) {
        btn.selected = NO;
    }
    sender.selected = YES;
    [_tableView reloadData];
    [self clearExtraLine:_tableView];
}

#pragma mark - tableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self.mode == 0) {
        WFClock *clock = _dataArr[indexPath.row];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 180, 20)];
        title.text = clock.title;
        title.font = [UIFont systemFontOfSize:15];
        [cell addSubview:title];
        UILabel *repeat = [[UILabel alloc] initWithFrame:CGRectMake(title.left, title.bottom, title.width, title.height)];
        switch (clock.repeatType) {
            case -1:
                repeat.text = @"仅一次";
                break;
            case 0:
                repeat.text = @"自定义";
                break;
            case 1:
                repeat.text = @"每天";
                break;
            case 2:
                repeat.text = @"工作日";
                break;
            case 3:
                repeat.text = @"每月一次";
                break;
            case 4:
                repeat.text = @"每年一次";
                break;
                
            default:
                break;
        }
        repeat.font = [UIFont systemFontOfSize:15];
        [cell addSubview:repeat];
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.width-60, (cell.height-30)/2, 60, 30)];
        NSString *str = [clock.remindTime substringFromIndex:11];
        timeLabel.text = str;
        timeLabel.font = [UIFont systemFontOfSize:17];
        [cell addSubview:timeLabel];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(timeLabel.right, timeLabel.top, 30, 30)];
        [btn setBackgroundImage:[UIImage imageNamed:@"guide_newuser_icon1"] forState:UIControlStateNormal];
        btn.tag = indexPath.row;
        [btn addTarget:self action:@selector(modifyClock:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn];
    }else if (self.mode == 1) {
        WFMeeting *meeting = _dataArr[indexPath.row];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 180, 20)];
        title.text = meeting.title;
        title.font = [UIFont systemFontOfSize:15];
        [cell addSubview:title];
        UILabel *repeat = [[UILabel alloc] initWithFrame:CGRectMake(title.left, title.bottom, title.width, title.height)];
        switch (meeting.repeatType) {
            case -1:
                repeat.text = @"仅一次";
                break;
            case 0:
                repeat.text = @"自定义";
                break;
            case 1:
                repeat.text = @"每天";
                break;
            case 2:
                repeat.text = @"工作日";
                break;
            case 3:
                repeat.text = @"每月一次";
                break;
            case 4:
                repeat.text = @"每年一次";
                break;
                
            default:
                break;
        }
        repeat.font = [UIFont systemFontOfSize:15];
        [cell addSubview:repeat];
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.width-60, (cell.height-30)/2, 60, 30)];
        NSString *str = [meeting.remindTime substringFromIndex:11];
        timeLabel.text = str;
        timeLabel.font = [UIFont systemFontOfSize:17];
        [cell addSubview:timeLabel];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(timeLabel.right, timeLabel.top, 30, 30)];
        [btn setBackgroundImage:[UIImage imageNamed:@"guide_newuser_icon2"] forState:UIControlStateNormal];
        btn.tag = indexPath.row;
        [btn addTarget:self action:@selector(modifyMeeting:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn];
    }else if (self.mode == 2) {
        WFAnniversary *ann = _dataArr[indexPath.row];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 180, 20)];
        title.text = ann.title;
        title.font = [UIFont systemFontOfSize:15];
        [cell addSubview:title];
        UILabel *repeat = [[UILabel alloc] initWithFrame:CGRectMake(title.left, title.bottom, title.width, title.height)];
        switch (ann.repeatType) {
            case -1:
                repeat.text = @"仅一次";
                break;
            case 0:
                repeat.text = @"自定义";
                break;
            case 1:
                repeat.text = @"每天";
                break;
            case 2:
                repeat.text = @"工作日";
                break;
            case 3:
                repeat.text = @"每月一次";
                break;
            case 4:
                repeat.text = @"每年一次";
                break;
                
            default:
                break;
        }
        repeat.font = [UIFont systemFontOfSize:15];
        [cell addSubview:repeat];
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.width-60, (cell.height-30)/2, 60, 30)];
        NSString *str = [ann.remindTime substringFromIndex:11];
        timeLabel.text = str;
        timeLabel.font = [UIFont systemFontOfSize:17];
        [cell addSubview:timeLabel];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(timeLabel.right, timeLabel.top, 30, 30)];
        btn.tag = indexPath.row;
        [btn setBackgroundImage:[UIImage imageNamed:@"addclock_birthday_hl"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(modifyAnn:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn];
    }
    return cell;
}

#pragma mark - button Action
- (void)modifyClock:(UIButton *)sender {
//    NSLog(@"%d",sender.tag);
    ModifyViewController *modifyCtrl = [[ModifyViewController alloc] initWithMode:ModifyModeClock];
    modifyCtrl.clock = _dataArr[sender.tag];
    [self.navigationController pushViewController:modifyCtrl animated:YES];
    
}

- (void)modifyMeeting:(UIButton *)sender {
    ModifyViewController *modifyCtrl = [[ModifyViewController alloc] initWithMode:ModifyModeMeeting];
    modifyCtrl.meeting = _dataArr[sender.tag];
    [self.navigationController pushViewController:modifyCtrl animated:YES];
}

- (void)modifyAnn:(UIButton *)sender {
    ModifyViewController *modifyCtrl = [[ModifyViewController alloc] initWithMode:ModifyModeAnniversary];
    modifyCtrl.ann = _dataArr[sender.tag];
    [self.navigationController pushViewController:modifyCtrl animated:YES];
}

#pragma mark - tableViewDelegate method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @[
             [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:NSLocalizedString(@"删除", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//                 NSLog(@"delete");
                 AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
                 manager.responseSerializer = [AFJSONResponseSerializer serializer];
                 manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                 NSString *url = @"";
                 NSDictionary *parameters;
                 if (_mode == 0) {
                     url = kDeleteAlarmURL;
                     WFClock *clock = _dataArr[indexPath.row];
                     parameters = @{@"userId":_user.user_id,@"alarmId":clock.clock_id,@"token":_user.token};
                 }else if (_mode == 1) {
                     url = kDeleteMeetingURL;
                     WFMeeting *meeting = _dataArr[indexPath.row];
                     parameters = @{@"userId":_user.user_id,@"meetingId":meeting.meeting_id,@"token":_user.token};
                 }else if (_mode == 2) {
                     url = kDeleteAnnURL;
                     WFAnniversary *ann = _dataArr[indexPath.row];
                     parameters = @{@"userId":_user.user_id,@"anniversaryId":ann.anniversary_id,@"token":_user.token};
//                     NSLog(@"%@",parameters);
                 }
                 [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                     NSLog(@"delete:%@",responseObject);
                     if (_mode == 0) {
                         [self loadData];
                     }else if (_mode == 1) {
                         [self loadMeetingData];
                     }else if (_mode == 2) {
                         [self loadAnnData];
                     }
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"%@",error);
                 }];
             }]
             ];
}

#pragma mark - 去掉多余的线
- (void)clearExtraLine :(UITableView *)tableView{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

@end
