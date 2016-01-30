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

#define kButtonWH 60

#define USERPHONE @"phone"
#define USERPASSWORD @"password"

@interface LoginViewController ()

@property (nonatomic, strong) UIAlertController *alertViewCtrl;

@property (nonatomic, weak) UITextField *bindingField;
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
    
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:PreDefM_APPID andDelegate:self];

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
    
    //第三方登陆
    UIView *openApiView = [[UIView alloc] initWithFrame:CGRectMake(0, _loginBtn.bottom+50, self.view.width, 100)];
    [self.view addSubview:openApiView];
    
    CGFloat distance = (self.view.width-kButtonWH*3)/4;
    
    UIButton *sinaBtn = [[UIButton alloc] initWithFrame:CGRectMake(distance, 10, kButtonWH, kButtonWH)];

    sinaBtn.highlighted = NO;
    [sinaBtn setBackgroundImage:[UIImage imageNamed:@"sina"] forState:UIControlStateNormal];
    [openApiView addSubview:sinaBtn];
    
    UIButton *tencentBtn = [[UIButton alloc] initWithFrame:CGRectMake(sinaBtn.right+distance, 10, kButtonWH, kButtonWH)];
    tencentBtn.highlighted = NO;
    [tencentBtn setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    [openApiView addSubview:tencentBtn];
//    [tencentBtn addTarget:self action:@selector(tencentLogin) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *wechatBtn = [[UIButton alloc] initWithFrame:CGRectMake(tencentBtn.right+distance, 10, kButtonWH, kButtonWH)];
    sinaBtn.highlighted = NO;
    [wechatBtn setBackgroundImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
    [openApiView addSubview:wechatBtn];
    [wechatBtn addTarget:self action:@selector(tencentLogin) forControlEvents:UIControlEventTouchUpInside];
    
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

#pragma mark - TencentLoginDelegate Method
/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin {
    [_tencentOAuth getUserInfo];
//    NSLog(@"accessToken:%@",_tencentOAuth.accessToken);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *parameters = @{@"qq_openId":_tencentOAuth.openId};
    NSString *url = kLoginURL;
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"result:%@",responseObject);
        if ([[responseObject objectForKey:@"resultCode"] intValue] == 101) {
            //绑定手机号
            [self setupBinding];
        }else {
            //登陆成功
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
}

#pragma mark - 设置绑定界面
- (void)setupBinding {
    NSString *title = NSLocalizedString(@"绑定手机号", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"绑定", nil);

    _alertViewCtrl = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];

    [_alertViewCtrl addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        _bindingField = textField;
    }];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:_alertViewCtrl completion:nil];
    }];
    
    UIAlertAction *bindingAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"%@",_bindingField.text);
        
        if (_bindingField.text.length == 0) {
            return;
        }else if ([WFUtils validateMobile:_bindingField.text]) {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            NSDictionary *parameters = @{@"qq_openId":_tencentOAuth.openId, @"phone":_bindingField.text};
            NSLog(@"%@",parameters);
            NSString *url = kLoginURL;
            [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"result:%@",responseObject);
//                if ([[responseObject objectForKey:@"resultCode"] intValue] == 102) {
//                    //绑定成功
//                }else {
//                    //登陆失败
//                    
//                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error:%@",error);
            }];
        }
    }];
    
    // Add the actions.
    [_alertViewCtrl addAction:cancelAction];
    [_alertViewCtrl addAction:bindingAction];
    
    [self presentViewController:_alertViewCtrl animated:YES completion:nil];
}

- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)notification {
    
}

- (void)bindingAction:(UIButton *)sender {
    
}

- (void)cancelAction:(UIButton *)sender {
    
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled {
    NSLog(@"登陆失败");
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork {
    NSLog(@"没有网络");
}

- (void)tencentLogin {
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_ALBUM,
                            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            kOPEN_PERMISSION_LIST_ALBUM,
                            kOPEN_PERMISSION_UPLOAD_PIC,
                            kOPEN_PERMISSION_GET_VIP_INFO,
                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            nil];
    
    [_tencentOAuth authorize:permissions inSafari:NO];
}

- (void)getUserInfoResponse:(APIResponse*) response {
    if (URLREQUEST_SUCCEED == response.retCode
        && kOpenSDKErrorSuccess == response.detailRetCode) {
        NSLog(@"%@",response);
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功"
//                                                        message: [NSString stringWithFormat:@"%@",str]
//                                                       delegate:self
//                                              cancelButtonTitle:@"我知道啦"
//                                              otherButtonTitles: nil];
//        [alert show];
    } else {
        NSString *errMsg = [NSString stringWithFormat:@"errorMsg:%@\n%@",
                            response.errorMsg, [response.jsonResponse objectForKey:@"msg"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败"
                                                        message:errMsg
                                                       delegate:self
                                              cancelButtonTitle:@"我知道啦"
                                              otherButtonTitles: nil];
        [alert show];
    }
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
