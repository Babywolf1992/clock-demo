//
//  ModifyViewController.m
//  zdnz
//
//  Created by babywolf on 16/1/5.
//  Copyright © 2016年 com.babywolf. All rights reserved.
//

#import "ModifyViewController.h"
#import "UIViewExt.h"
#import "ChooseViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "Contants.h"

@interface ModifyViewController()

@property (nonatomic, strong) UIDatePicker *datePicker;

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

@end

@implementation ModifyViewController

- (instancetype)initWithMode:(ModifyMode)mode {
    if (self = [super init]) {
        self.user = [WFUser sharedUser];
        self.mode = mode;
        if (mode == 0) {
            self.title = @"修改闹钟";
        }else if (mode == 1) {
            self.title = @"修改会议";
        }else if (mode == 2) {
            self.title = @"修改纪念日";
        }
    }
    return self;
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, self.view.width, 260)];
    _datePicker.datePickerMode = UIDatePickerModeTime;
    _datePicker.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.1];
    [self.view addSubview:_datePicker];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh-mm"];
    NSLog(@"%d",_mode);
    if (_mode == 0) {
        NSDate *date = [df dateFromString:_clock.remindTime];
        _datePicker.date = date;
    }else if (_mode == 1) {
        NSDate *date = [df dateFromString:_meeting.remindTime];
        _datePicker.date = date;
    }else if (_mode == 2) {
        NSDate *date = [df dateFromString:_ann.remindTime];
        _datePicker.date = date;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    if (_mode == 0) {
        [self loadClockView];
    }else if (_mode == 1) {
        [self loadMeetingView];
    }else if (_mode == 2) {
        [self loadAnniversaryView];
    }
}

#pragma mark - appear Method
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_clockRepeatLabel) {
        [self changeRepeatTitle:_clockRepeatLabel];
    }
    if (_meetingRepeatLabel) {
        [self changeRepeatTitle:_meetingRepeatLabel];
    }
    if (_annRepeatLabel) {
        [self changeRepeatTitle:_annRepeatLabel];
    }
}

#pragma mark - load Method
- (void)loadClockView {
    _clockView = [[UIView alloc] initWithFrame:CGRectMake(0, _datePicker.bottom, self.view.width, self.view.height-_datePicker.bottom)];
    [self.view addSubview:_clockView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,  20, 100, 30)];
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
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake((_clockView.width-80)/2, _clockView.height-100, 80, 30)];
    [addBtn setTitle:@"修改" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setBackgroundColor:[UIColor redColor]];
    addBtn.layer.cornerRadius = 7;
    [addBtn addTarget:self action:@selector(modifyClock) forControlEvents:UIControlEventTouchUpInside];
    [_clockView addSubview:addBtn];
}

- (void)loadMeetingView {
    _meetingView = [[UIView alloc] initWithFrame:CGRectMake(0, _datePicker.bottom, self.view.width, self.view.height-_datePicker.bottom)];
    [self.view addSubview:_meetingView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 30)];
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
    BOOL isMute = [_meeting.mute intValue] == 1 ? YES : NO;
    _muteSwitch.on = isMute;
    [_muteSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [_meetingView addSubview:_muteSwitch];
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake((_meetingView.width-80)/2, _meetingView.height-80, 80, 30)];
    [addBtn setTitle:@"修改" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setBackgroundColor:[UIColor redColor]];
    addBtn.layer.cornerRadius = 7;
    [addBtn addTarget:self action:@selector(modifyMeeting) forControlEvents:UIControlEventTouchUpInside];
    [_meetingView addSubview:addBtn];
}

- (void)loadAnniversaryView {
    _anniversaryView = [[UIView alloc] initWithFrame:CGRectMake(0, _datePicker.bottom, self.view.width, self.view.height-_datePicker.bottom)];
    //    _anniversaryView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:_anniversaryView];
    
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
    _advanceTimeField.text = [NSString stringWithFormat:@"%@",_ann.advanceDays];
    _advanceTimeField.textAlignment = NSTextAlignmentRight;
    [_anniversaryView addSubview:_advanceTimeField];
    
    UIView *divideView3 = [[UIView alloc] initWithFrame:CGRectMake(0, advanceDayLabel.bottom+10, self.view.width, 2)];
    divideView3.backgroundColor = [UIColor lightGrayColor];
    [_anniversaryView addSubview:divideView3];
    
    UILabel *muteLabel = [[UILabel alloc] initWithFrame:CGRectMake(advanceDayLabel.left, divideView3.bottom+10, advanceDayLabel.width, advanceDayLabel.height)];
    muteLabel.text = @"静音";
    [_anniversaryView addSubview:muteLabel];
    _annMuteSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(_advanceTimeField.right-50, muteLabel.top, 50, muteLabel.height)];
    BOOL isMute = [_ann.mute intValue] == 1 ? YES : NO;
    _annMuteSwitch.on = isMute;
    [_annMuteSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [_anniversaryView addSubview:_annMuteSwitch];
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake((_anniversaryView.width-80)/2, _anniversaryView.height-80, 80, 30)];
    [addBtn setTitle:@"修改" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setBackgroundColor:[UIColor redColor]];
    addBtn.layer.cornerRadius = 7;
    [addBtn addTarget:self action:@selector(modifyAnniversary) forControlEvents:UIControlEventTouchUpInside];
    [_anniversaryView addSubview:addBtn];
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

- (void)chooseRepeatType {
    ChooseViewController *chooseCtrl = [[ChooseViewController alloc] init];
    int i = self.mode;
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

#pragma mark - modify Method
- (void)modifyClock {
    _clock.title = _titleField.text;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm"];
    _clock.remindTime = [df stringFromDate:_datePicker.date];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *url = kModifyAlarmURL;
    NSDictionary *parameters = @{@"_id":_clock.clock_id,
                              @"userId":_user.user_id,
                                 @"token":_user.token,
                               @"title":_clock.title,
                          @"repeatType":[NSString stringWithFormat:@"%d",_clock.repeatType],
                          @"remindTime":_clock.remindTime};
    NSMutableDictionary *pars = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    if (_clock.repeatRule) {
        [pars setValue:_clock.repeatRule forKey:@"repeatRule"];
    }
    [manager POST:url parameters:pars success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"result:%@",responseObject);
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)modifyMeeting {
    _meeting.mute = _muteSwitch.on ? @"1" : @"0";
    int preTime = [_pretimeField.text floatValue] * 60 * 60 * 1000;
    _meeting.preTime = [NSString stringWithFormat:@"%d",preTime];
    _meeting.title = _meetingField.text;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm"];
    _meeting.remindTime = [df stringFromDate:_datePicker.date];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];;
    NSString *url = kModifyMeetingURL;
    NSDictionary *parameters = @{@"_id":_meeting.meeting_id,
                                 @"userId":_user.user_id,
                                 @"token":_user.token,
                                 @"title":_meeting.title,
                                 @"repeatType":[NSString stringWithFormat:@"%d",_meeting.repeatType],
                                 @"remindTime":_meeting.remindTime,
                                 @"mute":_meeting.mute,
                                 @"preTime":_meeting.preTime};
    NSMutableDictionary *pars = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    if (_meeting.repeatRule) {
        [pars setValue:_meeting.repeatRule forKey:@"repeatRule"];
    }
    [manager POST:url parameters:pars success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"result:%@",responseObject);
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)modifyAnniversary {
    _ann.mute = _annMuteSwitch.on ? @"1" : @"0";
    _ann.advanceDays = _advanceTimeField.text;
    _ann.title = _annField.text;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm"];
    _ann.remindTime = [df stringFromDate:_datePicker.date];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *url = kModifyAnnURL;
    NSDictionary *parameters = @{@"_id":_ann.anniversary_id,
                                 @"userId":_user.user_id,
                                 @"token":_user.token,
                                 @"title":_ann.title,
                                 @"repeatType":[NSString stringWithFormat:@"%d",_ann.repeatType],
                                 @"remindTime":_ann.remindTime,
                                 @"mute":_ann.mute,
                                 @"advanceDays":_ann.advanceDays};
    NSMutableDictionary *pars = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    if (_ann.repeatRule) {
        [pars setValue:_ann.repeatRule forKey:@"repeatRule"];
    }
    [manager POST:url parameters:pars success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"result:%@",responseObject);
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)switchAction:(UISwitch *)sender {
    if (sender == _muteSwitch) {
        _meeting.mute = _muteSwitch.on ? @"1" : @"0";
    }else if (sender == _annMuteSwitch) {
        _ann.mute = _annMuteSwitch.on ? @"1" : @"0";
    }
}

#pragma mark - tapAction Method
- (void)tapAction {
    
    [_titleField resignFirstResponder];
    
    [_meetingField resignFirstResponder];
    
    [_pretimeField resignFirstResponder];
    
    _ann.title = _annField.text;
    [_annField resignFirstResponder];
    
    
    [_advanceTimeField resignFirstResponder];
}

@end
