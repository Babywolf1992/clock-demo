//
//  ChooseViewController.m
//  zdnz
//
//  Created by babywolf on 15/12/31.
//  Copyright © 2015年 com.babywolf. All rights reserved.
//

#import "ChooseViewController.h"
#import "UIViewExt.h"
#import "ChooseCell.h"

@interface ChooseViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIAlertController *alertViewCtrl;

@end

@implementation ChooseViewController

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"重复";
        _repeatType = -1;
        NSArray *arr = @[@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO];
        _arr = [[NSMutableArray alloc] initWithArray:arr];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-80) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(_tableView.left, _tableView.bottom, _tableView.width, 80)];
    view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((view.width-80)/2, (view.height-30)/2, 80, 30)];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 8;
    [btn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 7;
    }else {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChooseCell *cell = [[ChooseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (indexPath.section == 0) {
        cell.isSelected = [_arr[indexPath.row] boolValue];
        NSArray *arr = @[@"每周一",@"每周二",@"每周三",@"每周四",@"每周五",@"每周六",@"每周日"];
        cell.textLabel.text = arr[indexPath.row];
    }else if (indexPath.section == 1) {
        cell.isSelected = [_arr[indexPath.row+7] boolValue];
        cell.textLabel.text = @"每天";
    }else if (indexPath.section == 2) {
        cell.isSelected = [_arr[indexPath.row+8] boolValue];
        cell.textLabel.text = @"每月";
    }else {
        cell.isSelected = [_arr[indexPath.row+9] boolValue];
        cell.textLabel.text = @"每年";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([_arr[indexPath.row] boolValue]) {
            _arr[indexPath.row] = @NO;
            for (int i = 7; i < 10; i++) {
                _arr[i] = @NO;
            }
            _repeatType = 0;
        }else {
            for (int i = 7; i < 10; i++) {
                _arr[i] = @NO;
            }
            _arr[indexPath.row] = @YES;
            int flag = 0;
            for (int i = 0; i < 7; i++) {
                if ([_arr[i] boolValue]) {
                    flag++;
                }
            }
            if (flag == 7) {
                _arr[7] = @YES;
                _repeatType = 1;
            }else {
                _repeatType = 0;
            }
        }
        if (_repeatType == 0) {
            _repeatRule = @"";
            for (int i = 0; i < 7; i++) {
                if ([_arr[i] boolValue]) {
                    NSString *str = [NSString stringWithFormat:@"week%d|",i+1];
                    _repeatRule = [_repeatRule stringByAppendingString:str];
                }
            }
            if (_repeatRule.length == 0) {
                _repeatType = -1;
            }else {
                _repeatRule = [_repeatRule substringToIndex:_repeatRule.length-1];
                if ([_repeatRule isEqualToString:@"week1|week2|week3|week4|week5"]) {
                    _repeatType = 2;
                }
            }
//            NSLog(@"%@",_repeatRule);
        }
        
    }else if (indexPath.section == 1) {
        if ([_arr[7] boolValue]) {
            for (int i = 0; i < 8; i++) {
                _arr[i] = @NO;
            }
            _repeatType = -1;
        }else {
            for (int i = 7; i < 10; i++) {
                _arr[i] = @NO;
            }
            for (int i = 0; i < 8; i++) {
                _arr[i] = @YES;
            }
            _repeatType = 1;
        }
    }else if (indexPath.section == 2) {
        if ([_arr[8] boolValue]) {
            _arr[8] = @NO;
            _repeatType = -1;
        }else {
            for (int i = 0; i < 10; i++) {
                _arr[i] = @NO;
            }
            _arr[8] = @YES;
            _repeatType = 3;
        }
    }else {
        if ([_arr[9] boolValue]) {
            _arr[9] = @NO;
            _repeatType = -1;
        }else {
            for (int i = 0; i < 10; i++) {
                _arr[i] = @NO;
            }
            _arr[9] = @YES;
            _repeatType = 4;
        }
    }
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

#pragma mark - commitAction Method
- (void)commitAction {
    if (_addMode == 1) {
        if (_repeatType == 0) {
            _clock.repeatRule = _repeatRule;
        }
        _clock.repeatType = _repeatType;
    }else if (_addMode == 2) {
        if (_repeatType == 0) {
            _meeting.repeatRule = _repeatRule;
        }
        _meeting.repeatType = _repeatType;
    }else {
        if (_repeatType == 0) {
            _ann.repeatRule = _repeatRule;
        }
        _ann.repeatType = _repeatType;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

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
