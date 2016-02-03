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
#import "WFBindingViewController.h"
#import "WFUser.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"

#define kButtonWH 60

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

// lifecycle method
- (void)loadView {
    [super loadView];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USEROPENID] && [[NSUserDefaults standardUserDefaults] objectForKey:USERPLATFORM]) {
        NSDictionary *dic = @{@"platform":[[NSUserDefaults standardUserDefaults] objectForKey:USERPLATFORM],@"openId":[[NSUserDefaults standardUserDefaults] objectForKey:USEROPENID]};
        [self thirdLogin:dic];
    }else if ([[NSUserDefaults standardUserDefaults] objectForKey:USERPHONE] && [[NSUserDefaults standardUserDefaults] objectForKey:USERPASSWORD]) {
        NSDictionary *dic = @{@"phone":[[NSUserDefaults standardUserDefaults] objectForKey:USERPHONE],@"password":[[NSUserDefaults standardUserDefaults] objectForKey:USERPASSWORD]};
        [self doLogin:dic];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
//    NSLog(@"bundleID:%@",identifier);
    self.view.backgroundColor = [UIColor whiteColor];
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
    
    /** 新浪 */
    UIButton *sinaBtn = [[UIButton alloc] initWithFrame:CGRectMake(distance, 10, kButtonWH, kButtonWH)];
    [sinaBtn setBackgroundImage:[UIImage imageNamed:@"sina"] forState:UIControlStateHighlighted];
    [sinaBtn setBackgroundImage:[UIImage imageNamed:@"sina"] forState:UIControlStateNormal];
    [openApiView addSubview:sinaBtn];
    [sinaBtn addTarget:self action:@selector(sinaLogin) forControlEvents:UIControlEventTouchUpInside];
    
    /** qq */
    UIButton *tenectBtn = [[UIButton alloc] initWithFrame:CGRectMake(sinaBtn.right+distance, 10, kButtonWH, kButtonWH)];
    [tenectBtn setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateHighlighted];
    [tenectBtn setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    [openApiView addSubview:tenectBtn];
    [tenectBtn addTarget:self action:@selector(tencentLogin) forControlEvents:UIControlEventTouchUpInside];
    
    /** 微信 */
    UIButton *wechatBtn = [[UIButton alloc] initWithFrame:CGRectMake(tenectBtn.right+distance, 10, kButtonWH, kButtonWH)];
    [wechatBtn setBackgroundImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateHighlighted];
    [wechatBtn setBackgroundImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
    [openApiView addSubview:wechatBtn];
    [wechatBtn addTarget:self action:@selector(wechatLogin) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    
    //设置微博登陆代理
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.delegate = self;
}

// tap Action
- (void)tapAction {
    [_phone resignFirstResponder];
    [_password resignFirstResponder];
}

// loginAction
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
        NSDictionary *parameters = @{@"phone":_phone.text, @"password":_password.text};
        [self doLogin:parameters];
    }
}

- (void)doLogin:(NSDictionary *)dic {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *url = kLoginURL;
    //        NSLog(@"%@",parameters);
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"result:%@",responseObject);
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
        NSLog(@"error:%@",error);
    }];
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
//    WFBindingViewController *bindingCtrl = [[WFBindingViewController alloc] initWithDictionary:nil];
//    [self.navigationController pushViewController:bindingCtrl animated:YES];
//    return;
    [_tencentOAuth getUserInfo];
}

#pragma mark - 设置绑定界面
- (void)setupBinding:(NSMutableDictionary *)dict {
    WFBindingViewController *bindingCtrl = [[WFBindingViewController alloc] initWithDictionary:dict];
    [self.navigationController pushViewController:bindingCtrl animated:YES];
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

/**
 * 新浪登陆
 */
- (void)sinaLogin {
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kSINA_RedirectURI;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}

/**
 * 微信登陆
 */
- (void)wechatLogin {
    
}

/**
 * qq登陆
 */
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
    
//    [_tencentOAuth authorize:permissions localAppId:@"1105081035" inSafari:NO];
    [_tencentOAuth authorize:permissions inSafari:NO];
}

/** qq获取用户资料 */
- (void)getUserInfoResponse:(APIResponse*) response {
    if (URLREQUEST_SUCCEED == response.retCode
        && kOpenSDKErrorSuccess == response.detailRetCode) {
//        NSLog(@"%@",response);
        NSDictionary *dic = response.jsonResponse;

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        NSDictionary *parameters = @{@"platform":@"qq",@"openId":_tencentOAuth.openId};
        NSString *url = kThirdLoginURL;
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"result:%@",responseObject);
            if ([[responseObject objectForKey:@"resultCode"] intValue] == 101) {
                //绑定
                NSMutableDictionary *mdic = [[NSMutableDictionary alloc] initWithDictionary:parameters];
                [mdic setObject:[dic objectForKey:@"figureurl_qq_1"] forKey:@"imageUrl"];
                [self setupBinding:mdic];
            }else if ([[responseObject objectForKey:@"resultCode"] intValue] == 0){
                //登陆成功
                WFUser *user = [WFUser sharedUser];
                [user setKeyValues:[responseObject objectForKey:@"user"]];
                user.token = [responseObject objectForKey:@"token"];
//                NSLog(@"user:%@",user);
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERPHONE];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERPASSWORD];
                [[NSUserDefaults standardUserDefaults] setObject:user.platform forKey:USERPLATFORM];
                [[NSUserDefaults standardUserDefaults] setObject:user.openId forKey:USEROPENID];
                MainViewController *mainViewController = [[MainViewController alloc] init];
                MainNavController *nav = [[MainNavController alloc] initWithRootViewController:mainViewController];
                self.view.window.rootViewController = nav;
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error:%@",error);
        }];

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

/** 新浪微博获取用户资料 */
- (void)getUserInfo:(NSDictionary *)dic {
//    NSLog(@"sina getuserinfo");
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *parameters = dic;
    NSString *url = @"https://api.weibo.com/2/users/show.json";
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"result:%@",responseObject);
        //登陆zdnz接口
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        NSString *imageUrl = [responseObject objectForKey:@"profile_image_url"];
        NSDictionary *dicts = @{@"platform":@"sina",@"openId":[dic objectForKey:@"uid"]};
        NSString *url = kThirdLoginURL;
        [manager POST:url parameters:dicts success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //success
            //            NSLog(@"result:%@",responseObject);
            if ([[responseObject objectForKey:@"resultCode"] intValue] == 101) {
                //绑定
                NSMutableDictionary *mdic = [[NSMutableDictionary alloc] initWithDictionary:dicts];
                [mdic setObject:imageUrl forKey:@"imageUrl"];
                //                NSLog(@"%@",mdic);
                [self setupBinding:mdic];
            }else if ([[responseObject objectForKey:@"resultCode"] intValue] == 0){
                //登陆成功
                WFUser *user = [WFUser sharedUser];
                [user setKeyValues:[responseObject objectForKey:@"user"]];
                user.token = [responseObject objectForKey:@"token"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERPHONE];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERPASSWORD];
                [[NSUserDefaults standardUserDefaults] setObject:user.platform forKey:USERPLATFORM];
                [[NSUserDefaults standardUserDefaults] setObject:user.openId forKey:USEROPENID];
                MainViewController *mainViewController = [[MainViewController alloc] init];
                MainNavController *nav = [[MainNavController alloc] initWithRootViewController:mainViewController];
                self.view.window.rootViewController = nav;
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error:%@",error);
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
}

- (void)thirdLogin:(NSDictionary *)dic {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *url = kThirdLoginURL;
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success
//        NSLog(@"result:%@",responseObject);
        if ([[responseObject objectForKey:@"resultCode"] intValue] == 0){
            //登陆成功
            WFUser *user = [WFUser sharedUser];
            [user setKeyValues:[responseObject objectForKey:@"user"]];
            user.token = [responseObject objectForKey:@"token"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERPHONE];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERPASSWORD];
            [[NSUserDefaults standardUserDefaults] setObject:user.platform forKey:USERPLATFORM];
            [[NSUserDefaults standardUserDefaults] setObject:user.openId forKey:USEROPENID];
            MainViewController *mainViewController = [[MainViewController alloc] init];
            MainNavController *nav = [[MainNavController alloc] initWithRootViewController:mainViewController];
            self.view.window.rootViewController = nav;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
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
