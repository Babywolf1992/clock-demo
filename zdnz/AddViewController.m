//
//  AddViewController.m
//  zdnz
//
//  Created by babywolf on 15/12/30.
//  Copyright © 2015年 com.babywolf. All rights reserved.
//

#import "AddViewController.h"
#import "Contants.h"
#import "ChooseViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "ClockViewContrller.h"

@interface AddViewController ()

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UIView *indexView;
@property (nonatomic, strong) UIView *clockView;
@property (nonatomic, strong) UIView *meetingView;
@property (nonatomic, strong) UIView *anniversaryView;

@property (nonatomic, strong) UILabel *clockRepeatLabel;
@property (nonatomic, strong) UILabel *meetingRepeatLabel;
@property (nonatomic, strong) UILabel *annRepeatLabel;

@property (nonatomic, strong) UITextField *titleField;
@property (nonatomic, strong) UITextField *meetingField;
@property (nonatomic, strong) UITextField *pretimeField;
@property (nonatomic, strong) UITextField *annField;
@property (nonatomic, strong) UITextField *advanceTimeField;

@property (nonatomic, strong) UISwitch *muteSwitch;
@property (nonatomic, strong) UISwitch *annMuteSwitch;

@property (nonatomic, strong) UIAlertController *alertViewCtrl;

@end

@implementation AddViewController

#pragma mark - initMethod
- (instancetype)init {
    if (self = [super init]) {
        self.title = @"添加闹钟";
        self.clock = [[WFClock alloc] initWithDate:_selectDay];
        self.meeting = [[WFMeeting alloc] initWithDate:_selectDay];
        self.ann = [[WFAnniversary alloc] initWithDate:_selectDay];
        self.user = [WFUser sharedUser];
    }
    return self;
}

- (instancetype)initWithDate:(NSDate *)date {
    self.selectDay = date;
    return [self init];
}

#pragma mark - loadMethod
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, self.view.width, 260)];
    _datePicker.datePickerMode = UIDatePickerModeTime;
    _datePicker.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.1];
    [self.view addSubview:_datePicker];
    [self loadIndexView];
    [self loadContentView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
}

- (void)loadIndexView {
    _indexView = [[UIView alloc]initWithFrame:CGRectMake(0, _datePicker.bottom, self.view.width, 30)];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width/3*i, 0, self.view.width/3, _indexView.height)];
        btn.tag = i;
        switch (i) {
            case 0:
            {
                [btn setTitle:@"闹钟" forState:UIControlStateNormal];
                btn.userInteractionEnabled = NO;
                btn.selected = YES;
            }
                break;
            case 1:
            {
                [btn setTitle:@"会议" forState:UIControlStateNormal];
            }
                break;
            case 2:
            {
                [btn setTitle:@"纪念日" forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
        [btn setBackgroundImage:[UIImage imageNamed:@"backgroundSelected"] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"background"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(changeIndex:) forControlEvents:UIControlEventTouchUpInside];
        [_indexView addSubview:btn];
    }
    
    [self.view addSubview:_indexView];
}

- (void)changeIndex:(UIButton *)sender {
    for (UIButton *btn in _indexView.subviews) {
        btn.userInteractionEnabled = YES;
        btn.selected = NO;
    }
    int x = sender.tag*self.view.width;
    [_contentView setContentOffset:CGPointMake(x, 0) animated:YES];
    sender.selected = YES;
    sender.userInteractionEnabled = NO;
}

- (void)loadContentView {
    _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _indexView.bottom, self.view.width, self.view.height-_datePicker.bottom-_indexView.height)];
    _contentView.delegate = self;
    [self loadClockView];
    [self loadMeetingView];
    [self loadAnniversaryView];;
    _contentView.contentSize = CGSizeMake(_contentView.width*3, _contentView.height);
    _contentView.pagingEnabled = YES;
    _contentView.bounces = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_contentView];
    
}

- (void)loadClockView {
    _clockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentView.width, _contentView.height)];
//    _clockView.backgroundColor = [UIColor redColor];
    [_contentView addSubview:_clockView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
    titleLabel.text = @"闹钟标题:";
    [_clockView addSubview:titleLabel];
    _titleField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabel.right, titleLabel.top, self.view.width-40-titleLabel.width, titleLabel.height)];
    _titleField.textAlignment = NSTextAlignmentRight;
    _titleField.text = self.clock.title;
    [_clockView addSubview:_titleField];
    UIView *divideView1 = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom+10, self.view.width, 2)];
    divideView1.backgroundColor = [UIColor lightGrayColor];
    [_clockView addSubview:divideView1];
    
    UILabel *repeatLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.left, divideView1.bottom+10, titleLabel.width, titleLabel.height)];
    repeatLabel.text = @"重复";
    [_clockView addSubview:repeatLabel];
    [self loadClockRepeatLabel:CGRectMake(repeatLabel.right, repeatLabel.top, _titleField.width, repeatLabel.height)];
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake((_clockView.width-80)/2, _clockView.height-80, 80, 30)];
    [addBtn setTitle:@"保存" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setBackgroundColor:[UIColor redColor]];
    addBtn.layer.cornerRadius = 7;
    [addBtn addTarget:self action:@selector(addClock) forControlEvents:UIControlEventTouchUpInside];
    [_clockView addSubview:addBtn];
}

- (void)loadClockRepeatLabel:(CGRect)rect {
    _clockRepeatLabel = [[UILabel alloc] initWithFrame:rect];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseRepeatType)];
    _clockRepeatLabel.userInteractionEnabled = YES;
    [_clockRepeatLabel addGestureRecognizer:tap];
    [self changeRepeatTitle:_clockRepeatLabel];
    _clockRepeatLabel.textAlignment = NSTextAlignmentRight;
    [_clockView addSubview:_clockRepeatLabel];
}

- (void)changeRepeatTitle:(UILabel *)label{
    NSString *repeatStr = @"";
    if (label == _clockRepeatLabel) {
        switch (_clock.repeatType) {
            case -1:
                repeatStr = @"仅一次";
                break;
            case 0:
                repeatStr = @"自定义";
                break;
            case 1:
                repeatStr = @"每天";
                break;
            case 2:
                repeatStr = @"工作日";
                break;
            case 3:
                repeatStr = @"每月";
                break;
            case 4:
                repeatStr = @"每年";
                break;
            default:
                break;
        }
    }else if (label == _meetingRepeatLabel) {
        switch (_meeting.repeatType) {
            case -1:
                repeatStr = @"仅一次";
                break;
            case 0:
                repeatStr = @"自定义";
                break;
            case 1:
                repeatStr = @"每天";
                break;
            case 2:
                repeatStr = @"工作日";
                break;
            case 3:
                repeatStr = @"每月";
                break;
            case 4:
                repeatStr = @"每年";
                break;
            default:
                break;
        }
    }else if (label == _annRepeatLabel) {
        switch (_ann.repeatType) {
            case -1:
                repeatStr = @"仅一次";
                break;
            case 0:
                repeatStr = @"自定义";
                break;
            case 1:
                repeatStr = @"每天";
                break;
            case 2:
                repeatStr = @"工作日";
                break;
            case 3:
                repeatStr = @"每月";
                break;
            case 4:
                repeatStr = @"每年";
                break;
            default:
                break;
        }
    }
    label.text = repeatStr;
}

- (void)loadMeetingView {
    _meetingView = [[UIView alloc] initWithFrame:CGRectMake(_contentView.width, 0, _contentView.width, _contentView.height)];
//    _meetingView.backgroundColor = [UIColor yellowColor];
    [_contentView addSubview:_meetingView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
    titleLabel.text = @"会议标题:";
    [_meetingView addSubview:titleLabel];
    _meetingField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabel.right, titleLabel.top, self.view.width-40-titleLabel.width, titleLabel.height)];
    _meetingField.textAlignment = NSTextAlignmentRight;
    _meetingField.text = self.meeting.title;
    [_meetingView addSubview:_meetingField];
    UIView *divideView1 = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom+10, self.view.width, 2)];
    divideView1.backgroundColor = [UIColor lightGrayColor];
    [_meetingView addSubview:divideView1];
    
    UILabel *repeatLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.left, divideView1.bottom+10, titleLabel.width, titleLabel.height)];
    repeatLabel.text = @"重复";
    [_meetingView addSubview:repeatLabel];
    _meetingRepeatLabel = [[UILabel alloc] initWithFrame:CGRectMake(repeatLabel.right, repeatLabel.top, _meetingField.width, repeatLabel.height)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseRepeatType)];
    _meetingRepeatLabel.userInteractionEnabled = YES;
    [_meetingRepeatLabel addGestureRecognizer:tap];
    [self changeRepeatTitle:_meetingRepeatLabel];
    _meetingRepeatLabel.textAlignment = NSTextAlignmentRight;
    [_meetingView addSubview:_meetingRepeatLabel];
    
    UIView *divideView2 = [[UIView alloc] initWithFrame:CGRectMake(0, repeatLabel.bottom+10, self.view.width, 2)];
    divideView2.backgroundColor = [UIColor lightGrayColor];
    [_meetingView addSubview:divideView2];
    
    UILabel *preTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(repeatLabel.left, divideView2.bottom+10, repeatLabel.width, repeatLabel.height)];
    preTimeLabel.text = @"提前/小时";
    [_meetingView addSubview:preTimeLabel];
    _pretimeField = [[UITextField alloc] initWithFrame:CGRectMake(_meetingRepeatLabel.left, preTimeLabel.top, _meetingRepeatLabel.width, preTimeLabel.height)];
    float time = [_meeting.preTime intValue]/1000.0/60/60;
    _pretimeField.text = [NSString stringWithFormat:@"%.1f",time];
    _pretimeField.textAlignment = NSTextAlignmentRight;
    [_meetingView addSubview:_pretimeField];
    
    UIView *divideView3 = [[UIView alloc] initWithFrame:CGRectMake(0, preTimeLabel.bottom+10, self.view.width, 2)];
    divideView3.backgroundColor = [UIColor lightGrayColor];
    [_meetingView addSubview:divideView3];
    
    UILabel *muteLabel = [[UILabel alloc] initWithFrame:CGRectMake(preTimeLabel.left, divideView3.bottom+10, preTimeLabel.width, preTimeLabel.height)];
    muteLabel.text = @"静音";
    [_meetingView addSubview:muteLabel];
    _muteSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(_pretimeField.right-50, muteLabel.top, 50, muteLabel.height)];
    BOOL isMute = [_meeting.mute isEqual: @"1"] ? YES : NO;
    _muteSwitch.on = isMute;
    [_muteSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [_meetingView addSubview:_muteSwitch];
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake((_meetingView.width-80)/2, _meetingView.height-80, 80, 30)];
    [addBtn setTitle:@"保存" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setBackgroundColor:[UIColor redColor]];
    addBtn.layer.cornerRadius = 7;
    [addBtn addTarget:self action:@selector(addMeeting) forControlEvents:UIControlEventTouchUpInside];
    [_meetingView addSubview:addBtn];
}

- (void)loadAnniversaryView {
    _anniversaryView = [[UIView alloc] initWithFrame:CGRectMake(_contentView.width*2, 0, _contentView.width, _contentView.height)];
//    _anniversaryView.backgroundColor = [UIColor purpleColor];
    [_contentView addSubview:_anniversaryView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
    titleLabel.text = @"纪念日标题:";
    [_anniversaryView addSubview:titleLabel];
    _annField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabel.right, titleLabel.top, self.view.width-40-titleLabel.width, titleLabel.height)];
    _annField.textAlignment = NSTextAlignmentRight;
    _annField.text = self.ann.title;
    [_anniversaryView addSubview:_annField];
    UIView *divideView1 = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom+10, self.view.width, 2)];
    divideView1.backgroundColor = [UIColor lightGrayColor];
    [_anniversaryView addSubview:divideView1];
    
    UILabel *repeatLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.left, divideView1.bottom+10, titleLabel.width, titleLabel.height)];
    repeatLabel.text = @"重复";
    [_anniversaryView addSubview:repeatLabel];
    _annRepeatLabel = [[UILabel alloc] initWithFrame:CGRectMake(repeatLabel.right, repeatLabel.top, _annField.width, repeatLabel.height)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseRepeatType)];
    _annRepeatLabel.userInteractionEnabled = YES;
    [_annRepeatLabel addGestureRecognizer:tap];
    [self changeRepeatTitle:_annRepeatLabel];
    _annRepeatLabel.textAlignment = NSTextAlignmentRight;
    [_anniversaryView addSubview:_annRepeatLabel];
    
    UIView *divideView2 = [[UIView alloc] initWithFrame:CGRectMake(0, repeatLabel.bottom+10, self.view.width, 2)];
    divideView2.backgroundColor = [UIColor lightGrayColor];
    [_anniversaryView addSubview:divideView2];
    
    UILabel *advanceDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(repeatLabel.left, divideView2.bottom+10, repeatLabel.width, repeatLabel.height)];
    advanceDayLabel.text = @"提前/天";
    [_anniversaryView addSubview:advanceDayLabel];
    _advanceTimeField = [[UITextField alloc] initWithFrame:CGRectMake(_annRepeatLabel.left, advanceDayLabel.top, _annRepeatLabel.width, advanceDayLabel.height)];
    _advanceTimeField.text = _ann.advanceDays;
    _advanceTimeField.textAlignment = NSTextAlignmentRight;
    [_anniversaryView addSubview:_advanceTimeField];
    
    UIView *divideView3 = [[UIView alloc] initWithFrame:CGRectMake(0, advanceDayLabel.bottom+10, self.view.width, 2)];
    divideView3.backgroundColor = [UIColor lightGrayColor];
    [_anniversaryView addSubview:divideView3];
    
    UILabel *muteLabel = [[UILabel alloc] initWithFrame:CGRectMake(advanceDayLabel.left, divideView3.bottom+10, advanceDayLabel.width, advanceDayLabel.height)];
    muteLabel.text = @"静音";
    [_anniversaryView addSubview:muteLabel];
    _annMuteSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(_advanceTimeField.right-50, muteLabel.top, 50, muteLabel.height)];
    BOOL isMute = [_ann.mute isEqual: @"1"] ? YES : NO;
    _annMuteSwitch.on = isMute;
    [_annMuteSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [_anniversaryView addSubview:_annMuteSwitch];
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake((_anniversaryView.width-80)/2, _anniversaryView.height-80, 80, 30)];
    [addBtn setTitle:@"保存" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setBackgroundColor:[UIColor redColor]];
    addBtn.layer.cornerRadius = 7;
    [addBtn addTarget:self action:@selector(addAnniversary) forControlEvents:UIControlEventTouchUpInside];
    [_anniversaryView addSubview:addBtn];
}

#pragma mark - appear Method
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self changeRepeatTitle:_clockRepeatLabel];
    [self changeRepeatTitle:_meetingRepeatLabel];
    [self changeRepeatTitle:_annRepeatLabel];
}

#pragma mark - UIScrollViewDelegate Method
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    int i = (float)point.x/self.view.width;
    UIButton *btn = _indexView.subviews[i];
    [self changeIndex:btn];
}

- (void)chooseRepeatType {
    ChooseViewController *chooseCtrl = [[ChooseViewController alloc] init];
    int i = _contentView.contentOffset.x/self.view.width;
    if (i == 0) {
        chooseCtrl.clock = _clock;
        chooseCtrl.addMode = 1;
    }else if (i == 1) {
        chooseCtrl.meeting = _meeting;
        chooseCtrl.addMode = 2;
    }else if (i == 2) {
        chooseCtrl.ann = _ann;
        chooseCtrl.addMode = 3;
    }
    [self.navigationController pushViewController:chooseCtrl animated:YES];
}

#pragma mark - click Method
- (void)addClock {
    [self tapAction];
//    NSURL *URL = [NSURL URLWithString:kAddAlarmURL];
//    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
//    request.timeoutInterval=5.0;//设置请求超时为5秒
//    request.HTTPMethod=@"POST";//设置请求方法
//    //设置请求体
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"yyyy-MM-dd"];
//    NSString *dayStr = [df stringFromDate:_selectDay];
//    [df setDateFormat:@"hh:mm"];
//    NSString *timeStr = [df stringFromDate:_datePicker.date];
//    NSString *remindTime = [NSString stringWithFormat:@"%@ %@",dayStr,timeStr];
//    NSString *url = kAddAlarmURL;
//    NSDictionary *parameters = @{@"userId":_user.user_id,
//                                 @"token":_user.token,
//                                 @"title":_clock.title,
//                                 @"remindTime":remindTime,
//                                 @"repeatType":[NSString stringWithFormat:@"%d",_clock.repeatType]};
//    
//    NSMutableDictionary *par = [[NSMutableDictionary alloc] initWithDictionary:parameters];
//    //    NSLog(@"%@",par);
//    if (_clock.repeatType == 0) {
//        [par setValue:_clock.repeatRule forKey:@"repeatRule"];
//    }
//    NSData *data = [NSJSONSerialization dataWithJSONObject:par options:NSJSONWritingPrettyPrinted error:nil];
//    //把拼接后的字符串转换为data，设置请求体
//    request.HTTPBody=data;
//    NSOperationQueue *queue=[NSOperationQueue mainQueue];
//    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        NSLog(@"--block回调数据--%@---%lu", [NSThread currentThread],(unsigned long)data.length);
//        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//         NSLog(@"%@",dict);
//    }];
//    return;
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *dayStr = [df stringFromDate:_selectDay];
    [df setDateFormat:@"hh:mm"];
    NSString *timeStr = [df stringFromDate:_datePicker.date];
    NSString *remindTime = [NSString stringWithFormat:@"%@ %@",dayStr,timeStr];
    NSString *url = kAddAlarmURL;
    NSDictionary *parameters = @{@"userId":_user.user_id,
                                 @"token":_user.token,
                                 @"title":_clock.title,
                                 @"remindTime":remindTime,
                                 @"repeatType":[NSString stringWithFormat:@"%d",_clock.repeatType]};

    NSMutableDictionary *par = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    NSLog(@"%@",par);
    if (_clock.repeatType == 0) {
        [par setValue:_clock.repeatRule forKey:@"repeatRule"];
    }
    [manager POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success:%@",responseObject);
//        [self showAlertViewCtrl:@"闹钟添加成功"];
        ClockViewContrller *clockCtrl = [[ClockViewContrller alloc] initWithMode:ShowModeClock];
        [self.navigationController pushViewController:clockCtrl animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
}

- (void)addMeeting {
    [self tapAction];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *dayStr = [df stringFromDate:_selectDay];
    [df setDateFormat:@"hh:mm"];
    NSString *timeStr = [df stringFromDate:_datePicker.date];
    NSString *remindTime = [NSString stringWithFormat:@"%@ %@",dayStr,timeStr];
    NSString *url = kAddMeetingURL;
    NSDictionary *parameters = @{@"userId":_user.user_id,
                                 @"token":_user.token,
                                 @"title":_meeting.title,
                                 @"remindTime":remindTime,
                                 @"repeatType":[NSString stringWithFormat:@"%d",_meeting.repeatType],
                                 @"preTime":_meeting.preTime,
                                 @"mute":_meeting.mute};
    NSMutableDictionary *par = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    if (_meeting.repeatType == 0) {
        [par setValue:_meeting.repeatRule forKey:@"repeatRule"];
    }
//    NSLog(@"%@",par);
    [manager POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        ClockViewContrller *clockCtrl = [[ClockViewContrller alloc] initWithMode:ShowModeMeeting];
        [self.navigationController pushViewController:clockCtrl animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)addAnniversary {
//    NSLog(@"%@",_ann);
    [self tapAction];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *dayStr = [df stringFromDate:_selectDay];
    [df setDateFormat:@"hh:mm"];
    NSString *timeStr = [df stringFromDate:_datePicker.date];
    NSString *remindTime = [NSString stringWithFormat:@"%@ %@",dayStr,timeStr];
    NSString *url = kAddAnnURL;
    NSDictionary *parameters = @{@"userId":_user.user_id,
                                 @"token":_user.token,
                                 @"title":_ann.title,
                                 @"remindTime":remindTime,
                                 @"repeatType":[NSString stringWithFormat:@"%d",_ann.repeatType],
                                 @"advanceDays":_ann.advanceDays,
                                 @"mute":_ann.mute};
    NSMutableDictionary *par = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    if (_meeting.repeatType == 0) {
        [par setValue:_ann.repeatRule forKey:@"repeatRule"];
    }
    //    NSLog(@"%@",par);
    [manager POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        ClockViewContrller *clockCtrl = [[ClockViewContrller alloc] initWithMode:ShowModeAnniversary];
        [self.navigationController pushViewController:clockCtrl animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)tapAction {
    _clock.title = _titleField.text;
    [_titleField resignFirstResponder];
    
    _meeting.title = _meetingField.text;
    [_meetingField resignFirstResponder];
    
    int preTime = [_pretimeField.text floatValue] * 60 * 60 * 1000;
    _meeting.preTime = [NSString stringWithFormat:@"%d",preTime];
    [_pretimeField resignFirstResponder];
    
    _ann.title = _annField.text;
    [_annField resignFirstResponder];
    
    _ann.advanceDays = _advanceTimeField.text;
    [_advanceTimeField resignFirstResponder];
}

- (void)switchAction:(UISwitch *)sender {
    if (sender == _muteSwitch) {
        _meeting.mute = _muteSwitch.on ? @"1" : @"0";
    }else if (sender == _annMuteSwitch) {
        _ann.mute = _annMuteSwitch.on ? @"1" : @"0";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AlertCtrl
- (void)showAlertViewCtrl:(NSString *)message {
    _alertViewCtrl = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:_alertViewCtrl animated:YES completion:^{
        [self performSelector:@selector(removeAlertViewCtrl) withObject:nil afterDelay:1];
    }];
}

- (void)removeAlertViewCtrl {
    [_alertViewCtrl dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
