//
//  RegisterController.m
//  zdnz
//
//  Created by babywolf on 15/12/23.
//  Copyright © 2015年 com.babywolf. All rights reserved.
//

#import "RegisterController.h"
#import "Contants.h"
#import "AFHTTPRequestOperationManager.h"
#import "MainViewController.h"
#import "WFUtils.h"
#import "MainNavController.h"
#import "WFUser.h"
#import "UIViewExt.h"
#import "MBProgressHUD+MJ.h"

@interface RegisterController()

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) UIAlertController *alertViewCtrl;
@property (nonatomic, strong) UITextField *verifyField;
@property (nonatomic, strong) UIButton *verifyBtn;

@end

@implementation RegisterController

// initMethod
- (instancetype)init {
    if (self = [super init]) {
        self.title = @"注册";
    }
    return self;
}

// lifecycle method
- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 100)];
    imageView.image = [UIImage imageNamed:@"login-pwd-blur"];
    [self.view addSubview:imageView];
    
    _username = [[UITextField alloc] initWithFrame:CGRectMake(10, imageView.bottom, self.view.width-20, 40)];
    _username.placeholder = @" 请输入用户名";
    UILabel *userLeftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    userLeftView.text = @"用户名:";
    _username.leftViewMode = UITextFieldViewModeAlways;
    _username.leftView = userLeftView;
    [self.view addSubview:_username];
    
    UIView *divideView = [[UIView alloc] initWithFrame:CGRectMake(_username.left, _username.bottom, _username.width, 2)];
    divideView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:divideView];
    
    _phone = [[UITextField alloc] initWithFrame:CGRectMake(divideView.left, divideView.bottom, divideView.width, _username.height)];
    _phone.placeholder = @" 请输入电话号码";
    UILabel *phoneLeftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    phoneLeftView.text = @"手机号:";
    _phone.leftView = phoneLeftView;
    _phone.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_phone];
    
    UIView *divideView2 = [[UIView alloc] initWithFrame:CGRectMake(_phone.left, _phone.bottom, _phone.width, 2)];
    divideView2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:divideView2];
    
    _password = [[UITextField alloc] initWithFrame:CGRectMake(divideView2.left, divideView2.bottom, divideView2.width, _phone.height)];
    _password.placeholder = @" 请输入密码";
    _password.secureTextEntry = YES;
    [self.view addSubview:_password];
    UILabel *psdLeftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    psdLeftView.text = @"密码:";
    _password.leftViewMode = UITextFieldViewModeAlways;
    _password.leftView = psdLeftView;
    
    UIView *divideView3 = [[UIView alloc] initWithFrame:CGRectMake(_password.left, _password.bottom, _password.width, 2)];
    divideView3.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:divideView3];
    
    _verifyField = [[UITextField alloc] initWithFrame:CGRectMake(divideView3.left, divideView3.bottom, self.view.width, _phone.height)];
    _verifyField.placeholder = @"输入验证码";
    UILabel *verLeftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    verLeftView.text = @"验证码:";
    _verifyField.leftViewMode = UITextFieldViewModeAlways;
    _verifyField.leftView = verLeftView;
    [self.view addSubview:_verifyField];
    
    _verifyBtn = [[UIButton alloc] initWithFrame:CGRectMake(_verifyField.right-100, 4, 70, _verifyField.height-8)];
    [_verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//    _verifyBtn.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.7];
    _verifyBtn.backgroundColor = [UIColor redColor];
    _verifyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _verifyBtn.layer.cornerRadius = 5;
    [_verifyBtn addTarget:self action:@selector(getVeridation) forControlEvents:UIControlEventTouchUpInside];
    [_verifyField addSubview:_verifyBtn];
    
    _registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, _verifyField.bottom+20, self.view.width-60, 30)];
    [_registerBtn setBackgroundColor:[UIColor redColor]];
    [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    _registerBtn.layer.cornerRadius = 5;
    [_registerBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
}

- (void)getVeridation {
//    // 多线程启动NSTimer
//    [self startTimer];
//    return;
    
    if (![WFUtils validateMobile:_phone.text]) {
        [self showAlertViewCtrl:@"手机号不正确"];
    }else {
        // 多线程启动NSTimer
        [self startTimer];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        NSDictionary *parameters = @{@"phone":_phone.text};
        NSString *url = kSendMessage;
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"resultCode"] intValue] == 0) {
                //成功
                
            }else {
                //失败
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error:%@",error);
        }];
    }
}

-(void)startTimer{
//    [_verifyBtn setTitle:@"59s" forState:UIControlStateNormal];
    __block int timeout=59; //倒计时时间
    _verifyBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                _verifyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                [_verifyBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                _verifyBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
//                NSLog(@"____%@",strTime);
                [_verifyBtn setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                _verifyBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

// regist Action
- (void)registerAction:(UIButton *)sender {
    if (_phone.text.length == 0) {
        [self showAlertViewCtrl:@"请输入手机号"];
    }else if (![WFUtils validateMobile:_phone.text]) {
        [self showAlertViewCtrl:@"请输入正确的手机号"];
    }else if (_username.text.length == 0) {
        [self showAlertViewCtrl:@"请输入用户名"];
    }else if (_password.text.length == 0) {
        [self showAlertViewCtrl:@"请输入密码"];
    }else {
        [MBProgressHUD showMessage:@"加载中..."];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        NSDictionary *parameters = @{@"phone":_phone.text, @"password":_password.text, @"username":_username.text,@"code":_verifyField.text};
        NSString *url = kRegisterURL;
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"JSON:%@",responseObject);
            [MBProgressHUD hideHUD];
            if ([[responseObject objectForKey:@"resultCode"]intValue] == 0) {
                // 注册成功
//                NSLog(@"%@",responseObject);
//                WFUser *user = [WFUser sharedUser];
//                [user setKeyValues:[responseObject objectForKey:@"user"]];
//                user.token = [responseObject objectForKey:@"token"];
                NSDictionary *parameters = @{@"phone":_phone.text, @"password":_password.text};
                [self doLogin:parameters];
//                MainViewController *mainViewCtroller = [[MainViewController alloc] init];
//                MainNavController *nav = [[MainNavController alloc] initWithRootViewController:mainViewCtroller];
//                self.view.window.rootViewController = nav;
            }else if ([[responseObject objectForKey:@"resultCode"]intValue] == 111){
                // 注册失败
                [self showAlertViewCtrl:@"验证码错误"];
            }else if ([[responseObject objectForKey:@"resultCode"]intValue] == 106){
                [self showAlertViewCtrl:@"该手机号已经被注册"];
            }else if ([[responseObject objectForKey:@"resultCode"]intValue] == 108) {
                [self showAlertViewCtrl:@"用户名已存在"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUD];
            NSLog(@"error:%@",error);
        }];
    }
}

- (void)tapAction {
    [_username resignFirstResponder];
    [_phone resignFirstResponder];
    [_password resignFirstResponder];
}

- (void)showAlertViewCtrl:(NSString *)message {
    _alertViewCtrl = [UIAlertController alertControllerWithTitle:nil
                                                         message:message
                                                  preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:_alertViewCtrl animated:YES completion:^{
        [self performSelector:@selector(removeAlertViewCtrl) withObject:nil afterDelay:1];
    }];
}

- (void)removeAlertViewCtrl {
    [_alertViewCtrl dismissViewControllerAnimated:YES completion:nil];
}

- (void)leftView:(UITextField *)field {
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(field.left, field.top, 10, field.height)];
    field.leftView = leftView;
    field.leftViewMode = UITextFieldViewModeAlways;
}

- (void)doLogin:(NSDictionary *)dic {
    [MBProgressHUD showMessage:@"加载中..."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *url = kLoginURL;
    //        NSLog(@"%@",parameters);
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"result:%@",responseObject);
        [MBProgressHUD hideHUD];
        if ([[responseObject objectForKey:@"resultCode"] integerValue] == 0) {
            WFUser *user = [WFUser sharedUser];
            [user setKeyValues:[responseObject objectForKey:@"user"]];
            user.token = [responseObject objectForKey:@"token"];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERPLATFORM];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:USEROPENID];
            [[NSUserDefaults standardUserDefaults] setObject:user.phone forKey:USERPHONE];
            [[NSUserDefaults standardUserDefaults] setObject:user.password forKey:USERPASSWORD];
            MainViewController *mainViewController = [[MainViewController alloc] init];
            MainNavController *nav = [[MainNavController alloc] initWithRootViewController:mainViewController];
            self.view.window.rootViewController = nav;
        }else {
            [self showAlertViewCtrl:[responseObject objectForKey:@"resultMessage"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"error:%@",error);
    }];
}

@end
