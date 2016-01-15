//
//  LoginViewController.m
//  zdnz
//
//  Created by babywolf on 15/12/22.
//  Copyright © 2015年 com.babywolf. All rights reserved.
//

#import "LoginViewController.h"
#import "Contants.h"
#import "RegisterController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MainViewController.h"
#import "WFUtils.h"
#import "MainNavController.h"
#import "WFUser.h"

#define USERPHONE @"phone"
#define USERPASSWORD @"password"

@interface LoginViewController ()

@property (nonatomic, strong) UIAlertController *alertViewCtrl;

@end

@implementation LoginViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.title = @"登陆";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:USERPHONE];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:USERPASSWORD];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 100)];
    imageView.image = [UIImage imageNamed:@"login-pwd-blur"];
    [self.view addSubview:imageView];
    
    // Do any additional setup after loading the view.
    _phone = [[UITextField alloc] initWithFrame:CGRectMake(10, imageView.bottom, self.view.width-20, 40)];
    _phone.placeholder = @"请输入电话号码";
    _phone.text = phone;
    
    UIImageView *_phoneImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    _phoneImg.image = [UIImage imageNamed:@"icon-username"];
    _phoneImg.contentMode = UIViewContentModeScaleAspectFit;
    _phone.leftViewMode = UITextFieldViewModeAlways;
    _phone.leftView = _phoneImg;
    [self.view addSubview:_phone];
    
    //分隔线
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(_phone.left, _phone.bottom, _phone.width, 2)];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view];
    
    _password = [[UITextField alloc] initWithFrame:CGRectMake(view.left, view.bottom, view.width, _phone.height)];
    _password.secureTextEntry = YES;
    _password.placeholder = @"请输入密码";
    _password.text = password;
    
    UIImageView *_pwdImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    _pwdImg.image = [UIImage imageNamed:@"icon-password"];
    _pwdImg.contentMode = UIViewContentModeScaleAspectFit;
    _password.leftView = _pwdImg;
    _password.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_password];
    
    _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, _password.bottom+20, self.view.width-60, 30)];
    [_loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    _loginBtn.layer.cornerRadius = 5;
    [_loginBtn setBackgroundColor:[UIColor redColor]];
    [_loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapAction {
    [_phone resignFirstResponder];
    [_password resignFirstResponder];
}

- (void)loginAction:(UIButton *)sender {
//    MainViewController *mainViewController = [[MainViewController alloc] init];
//    MainNavController *nav = [[MainNavController alloc] initWithRootViewController:mainViewController];
//    WFUser *user = [WFUser sharedUser];
//    user.user_id = @"567a1c1759b9815b0596d345";
//    user.email = @"";
//    user.password = @"123456";
//    user.phone = @"13965185965";
//    user.username = @"Wolf";
//    self.view.window.rootViewController = nav;
    
    
    if (_phone.text.length == 0) {
        [self showAlertViewCtrl:@"请输入电话号码"];
    }else if (![WFUtils validateMobile:_phone.text]) {
        [self showAlertViewCtrl:@"请输入正确的电话号码"];
    }else if (_password.text.length == 0) {
        [self showAlertViewCtrl:@"请输入密码"];
    }else {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        NSDictionary *parameters = @{@"phone":_phone.text, @"password":_password.text};
        NSString *url = kLoginURL;
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"result:%@",responseObject);
            if ([[responseObject objectForKey:@"resultCode"] integerValue] == 0) {
                WFUser *user = [WFUser sharedUser];
                user.token = [responseObject objectForKey:@"token"];
                user.user_id = [[responseObject objectForKey:@"user"] objectForKey:@"_id"];
                user.email = [[responseObject objectForKey:@"user"] objectForKey:@"email"];
                user.password = [[responseObject objectForKey:@"user"] objectForKey:@"password"];
                user.phone = [[responseObject objectForKey:@"user"] objectForKey:@"phone"];
                user.username = [[responseObject objectForKey:@"user"] objectForKey:@"username"];
                user.imageToken = [responseObject objectForKey:@"imageToken"];
                user.imageURL = [[responseObject objectForKey:@"user"] objectForKey:@"imageUrl"];
                [[NSUserDefaults standardUserDefaults] setObject:user.phone forKey:USERPHONE];
                [[NSUserDefaults standardUserDefaults] setObject:user.password forKey:USERPASSWORD];
                MainViewController *mainViewController = [[MainViewController alloc] init];
                MainNavController *nav = [[MainNavController alloc] initWithRootViewController:mainViewController];
                self.view.window.rootViewController = nav;
            }else {
                [self showAlertViewCtrl:[responseObject objectForKey:@"resultMessage"]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error:%@",error);
        }];
    }
}

- (IBAction)registerAction:(id)sender {
    RegisterController *registerController = [[RegisterController alloc] init];
    [self.navigationController pushViewController:registerController animated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
