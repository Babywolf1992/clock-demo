//
//  SettingPasswordViewController.m
//  zdnz
//
//  Created by babywolf on 16/1/8.
//  Copyright © 2016年 com.babywolf. All rights reserved.
//

#import "SettingPasswordViewController.h"
#import "Contants.h"
#import "AFHTTPRequestOperationManager.h"

@interface SettingPasswordViewController()

@property (nonatomic, strong) UITextField *oldpsd;
@property (nonatomic, strong) UITextField *newpsd;
@property (nonatomic, strong) UITextField *reviewpsd;

@property (nonatomic, strong) UIAlertController *alertViewCtrl;

@end

@implementation SettingPasswordViewController

- (WFUser *)user {
    if (!_user) {
        _user = [WFUser sharedUser];
    }
    return _user;
}

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"设置";
    }
    return self;
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    
    _oldpsd = [[UITextField alloc] initWithFrame:CGRectMake(10, 64, self.view.width-20, 40)];
    _oldpsd.textAlignment = NSTextAlignmentRight;
    UILabel *oldlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    _oldpsd.leftViewMode = UITextFieldViewModeAlways;
    _oldpsd.leftView = oldlabel;
    _oldpsd.secureTextEntry = YES;
    oldlabel.text = @"当前密码:";
    [self.view addSubview:_oldpsd];
    
    _newpsd = [[UITextField alloc] initWithFrame:CGRectMake(_oldpsd.left, _oldpsd.bottom, _oldpsd.width, _oldpsd.height)];
    _newpsd.textAlignment = NSTextAlignmentRight;
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    _newpsd.leftViewMode = UITextFieldViewModeAlways;
    _newpsd.leftView = newLabel;
    _newpsd.secureTextEntry = YES;
    newLabel.text = @"新的密码:";
    [self.view addSubview:_newpsd];
    
    _reviewpsd = [[UITextField alloc] initWithFrame:CGRectMake(_newpsd.left, _newpsd.bottom, _newpsd.width, _newpsd.height)];
    _reviewpsd.textAlignment = NSTextAlignmentRight;
    UILabel *reviewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    _reviewpsd.leftViewMode = UITextFieldViewModeAlways;
    _reviewpsd.leftView = reviewLabel;
    _reviewpsd.secureTextEntry = YES;
    reviewLabel.text = @"校验密码:";
    [self.view addSubview:_reviewpsd];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.height-50, self.view.width-40, 30)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"修改密码" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    btn.layer.cornerRadius = 5;
    [btn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
}

- (void)commitAction {
    if (_oldpsd.text.length == 0) {
        [self showAlertViewCtrl:@"请输入原来的密码"];
        return;
    }
    if (_newpsd.text.length == 0) {
        [self showAlertViewCtrl:@"请输入新的密码"];
    }
    if (_reviewpsd.text.length == 0) {
        [self showAlertViewCtrl:@"请输入校验密码"];
        return;
    }
    if (![_oldpsd.text isEqualToString:self.user.password]) {
        [self showAlertViewCtrl:@"密码错误"];
        return;
    }
    if (![_newpsd.text isEqualToString:_reviewpsd.text]) {
        [self showAlertViewCtrl:@"两次密码输入不同"];
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url = kModifyUserURL;
    NSDictionary *parameters = @{@"userId":self.user.user_id,@"token":self.user.token,@"password":_newpsd.text};
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"result:%@",responseObject);
        [[NSUserDefaults standardUserDefaults] setObject:_newpsd.text forKey:USERPASSWORD];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
}

- (void)tapAction {
    [_oldpsd resignFirstResponder];
    [_newpsd resignFirstResponder];
    [_reviewpsd resignFirstResponder];
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

@end
