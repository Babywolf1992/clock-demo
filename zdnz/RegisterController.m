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

@interface RegisterController()

@property (nonatomic, strong) UIAlertController *alertViewCtrl;

@end

@implementation RegisterController

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"注册";
    }
    return self;
}

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
    
    _registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, _password.bottom+20, self.view.width-60, 30)];
    [_registerBtn setBackgroundColor:[UIColor redColor]];
    [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    _registerBtn.layer.cornerRadius = 5;
    [_registerBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
}

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
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        NSDictionary *parameters = @{@"phone":_phone.text, @"password":_password.text, @"username":_username.text};

        NSString *url = kRegisterURL;
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON:%@",responseObject);
            if ([responseObject objectForKey:@"resultCode"] == 0) {
                // 注册成功
                WFUser *user = [WFUser sharedUser];
                user.user_id = [[responseObject objectForKey:@"user"] objectForKey:@"_id"];
                user.email = [[responseObject objectForKey:@"user"] objectForKey:@"email"];
                user.password = [[responseObject objectForKey:@"user"] objectForKey:@"password"];
                user.phone = [[responseObject objectForKey:@"user"] objectForKey:@"phone"];
                user.username = [[responseObject objectForKey:@"user"] objectForKey:@"username"];
                MainViewController *mainViewCtroller = [[MainViewController alloc] init];
                MainNavController *nav = [[MainNavController alloc] initWithRootViewController:mainViewCtroller];
                self.view.window.rootViewController = nav;
            }else {
                // 注册失败
                [self showAlertViewCtrl:@"该手机号已经被注册"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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

@end
