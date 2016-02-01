//
//  MainViewController.m
//  zdnz
//
//  Created by babywolf on 15/12/23.
//  Copyright © 2015年 com.babywolf. All rights reserved.
//

#import "MainViewController.h"
#import "Contants.h"
#import "AddViewController.h"
#import "ClockViewContrller.h"
#import "AFHTTPRequestOperationManager.h"
#import "WFClock.h"
#import "WFMeeting.h"
#import "WFAnniversary.h"
#import "UserViewController.h"

@interface MainViewController()

@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MainViewController

#pragma mark - init Method
- (instancetype)init {
    if (self = [super init]) {
        self.title = @"正点闹钟";
        self.user = [WFUser sharedUser];
        self.selectDay = [NSDate date];
    }
    return self;
}

#pragma mark - lazy loading
- (NSArray *)alarms {
    if (!_alarms) {
        _alarms = [NSArray array];
    }
    return _alarms;
}

- (NSArray *)meetings {
    if (!_meetings) {
        _meetings = [NSArray array];
    }
    return _meetings;
}

- (NSArray *)anns {
    if (!_anns) {
        _anns = [NSArray array];
    }
    return _anns;
}

#pragma mark - requestdata Method
- (void)loadData {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [df stringFromDate:_selectDay];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    [manager.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    NSString *url = kGetTodayDataURL;
    NSDictionary *parameters = @{@"userId":_user.user_id,@"date":dateStr,@"token":_user.token};
//    NSLog(@"%@",parameters);
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"result:%@",responseObject);
        NSMutableArray *mArr1 = [NSMutableArray array];
        NSMutableArray *mArr2 = [NSMutableArray array];
        NSMutableArray *mArr3 = [NSMutableArray array];
        for (NSDictionary *dic in responseObject) {
            NSString *eventType = [dic objectForKey:@"eventType"];
            if ([eventType isEqualToString:@"alarm"]) {
                WFClock *alarm = [[WFClock alloc] init];
                alarm.clock_id = [dic objectForKey:@"_id"];
                alarm.title = [dic objectForKey:@"title"];
                alarm.remindTime = [dic objectForKey:@"remindTime"];
                alarm.repeatType = [[dic objectForKey:@"repeatType"] intValue];
                if ([dic objectForKey:@"repeatRule"]) {
                    alarm.repeatRule = [dic objectForKey:@"repeatRule"];
                }
                [mArr1 addObject:alarm];
            }else if ([eventType isEqualToString:@"meeting"]) {
                WFMeeting *meeting = [[WFMeeting alloc] init];
                meeting.meeting_id = [dic objectForKey:@"_id"];
                meeting.title = [dic objectForKey:@"title"];
                meeting.remindTime = [dic objectForKey:@"remindTime"];
                meeting.repeatType = [[dic objectForKey:@"repeatType"] intValue];
                if ([dic objectForKey:@"repeatRule"]) {
                    meeting.repeatRule = [dic objectForKey:@"repeatRule"];
                }
                [mArr2 addObject:meeting];
            }else if ([eventType isEqualToString:@"anniversary"]) {
                WFAnniversary *ann = [[WFAnniversary alloc] init];
                ann.anniversary_id = [dic objectForKey:@"_id"];
                ann.title = [dic objectForKey:@"title"];
                ann.remindTime = [dic objectForKey:@"remindTime"];
                ann.repeatType = [[dic objectForKey:@"repeatType"] intValue];
                if ([dic objectForKey:@"repeatRule"]) {
                    ann.repeatRule = [dic objectForKey:@"repeatRule"];
                }
                [mArr3 addObject:ann];
            }
        }
        self.alarms = mArr1;
        self.meetings = mArr2;
        self.anns = mArr3;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
}

#pragma mark - view appear Method
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadData];
}

#pragma mark - load view Method
- (void)viewDidLoad {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    [button setTitle:@"个人中心" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushUserCtrl) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *myClockBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    [myClockBtn setTitle:@"我的闹钟" forState:UIControlStateNormal];
    [myClockBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    myClockBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [myClockBtn addTarget:self action:@selector(myClockAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:myClockBtn];
    self.navigationItem.rightBarButtonItem = item;
    
    self.view.backgroundColor = [UIColor whiteColor];

    CGFloat height = 300;
    _calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 64, self.view.width, height)];
    _calendar.dataSource = self;
    _calendar.delegate = self;
    NSDate *date = [NSDate date];
    [self selectDate:date];
    [self.view addSubview:_calendar];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _calendar.bottom, self.view.width, self.view.height-_calendar.bottom) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.allowsSelection = NO;
    [self.view addSubview:_tableView];
    
    _addBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width-50)/2, self.view.height-100, 50, 50)];
    [_addBtn setImage:[UIImage imageNamed:@"home_add"] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addBtn];
}

#pragma mark - calendar delegate Method
- (void)selectDate:(NSDate *)date {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy"];
    NSString *year = [df stringFromDate:date];
    [df setDateFormat:@"MM"];
    NSString *month = [df stringFromDate:date];
    [df setDateFormat:@"dd"];
    NSString *day = [df stringFromDate:date];
//    NSLog(@"%@,%@,%@",year,month,day);
    [_calendar selectDate:[_calendar dateWithYear:[year intValue] month:[month intValue] day:[day intValue]]];
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    self.selectDay = date;
    [self loadData];
    //    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //    [df setDateFormat:@"yyyy-MM-dd"];
    //    NSString *str = [df stringFromDate:date];
    //    NSLog(@"%@",str);
}

#pragma mark - button Action
- (void)addAction:(UIButton *)sender {
    AddViewController *addCtrl = [[AddViewController alloc] initWithDate:_selectDay];
    [self.navigationController pushViewController:addCtrl animated:YES];
}

- (void)myClockAction {
    ClockViewContrller *clockCtrl = [[ClockViewContrller alloc] init];
    [self.navigationController pushViewController:clockCtrl animated:YES];
}

- (void)pushUserCtrl {
    UserViewController *userCtrl = [[UserViewController alloc] init];
    [self.navigationController pushViewController:userCtrl animated:YES];
}

#pragma UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _alarms.count;
    }else if (section == 1) {
        return _meetings.count;
    }else if (section == 2) {
        return _anns.count;
    }else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
        title.tag = 101;
        [cell addSubview:title];
        UILabel *remindTime = [[UILabel alloc] initWithFrame:CGRectMake(title.right+10, title.top, 200, title.height)];
        remindTime.textAlignment = NSTextAlignmentRight;
        remindTime.tag = 102;
        [cell addSubview:remindTime];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width-10-30, (cell.height-30)/2, 30, 30)];
        imageView.tag = 103;
        [cell addSubview:imageView];
    }
    switch (indexPath.section) {
        case 0:
        {
            WFClock *alarm = _alarms[indexPath.row];
            UILabel *title = (UILabel *)[cell viewWithTag:101];
            title.text = alarm.title;
            UILabel *remindTime = [(UILabel *)cell viewWithTag:102];
            remindTime.text = [alarm.remindTime substringFromIndex:11];
            UIImageView *imgView = (UIImageView *)[cell viewWithTag:103];
            imgView.image = [UIImage imageNamed:@"guide_newuser_icon1"];
        }
            break;
        case 1:
        {
            WFMeeting *meeting = _meetings[indexPath.row];
            UILabel *title = (UILabel *)[cell viewWithTag:101];
            title.text = meeting.title;
            UILabel *remindTime = [(UILabel *)cell viewWithTag:102];
            remindTime.text = [meeting.remindTime substringFromIndex:11];
            UIImageView *imgView = (UIImageView *)[cell viewWithTag:103];
            imgView.image = [UIImage imageNamed:@"guide_newuser_icon2"];
        }
            break;
        case 2:
        {
            WFAnniversary *ann = _anns[indexPath.row];
            UILabel *title = (UILabel *)[cell viewWithTag:101];
            title.text = ann.title;
            UILabel *remindTime = [(UILabel *)cell viewWithTag:102];
            remindTime.text = [ann.remindTime substringFromIndex:11];
            UIImageView *imgView = (UIImageView *)[cell viewWithTag:103];
            imgView.image = [UIImage imageNamed:@"addclock_birthday_hl"];
        }
            break;
            
        default:
            break;
    }
    return cell;
}


@end
