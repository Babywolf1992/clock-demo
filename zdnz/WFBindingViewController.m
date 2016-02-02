//
//  WFBindingViewController.m
//  zdnz
//
//  Created by babywolf on 16/2/1.
//  Copyright © 2016年 com.babywolf. All rights reserved.
//

#import "WFBindingViewController.h"
#import "Contants.h"
#import "AFNetworking.h"
#import "WFUser.h"
#import "MainViewController.h"
#import "MainNavController.h"

@interface WFBindingViewController()

@property (nonatomic, strong) UIAlertController *alertViewCtrl;
@property (nonatomic, strong) UITextField *field;
@property (nonatomic, strong) NSMutableDictionary *mdict;

@end

@implementation WFBindingViewController
- (instancetype)initWithDictionary:(NSMutableDictionary *)dic {
    if (self = [super init]) {
        self.title = @"开通账号";
        _mdict = dic;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _field = [[UITextField alloc] initWithFrame:CGRectMake(0, 20+64, self.view.width, 35)];
    _field.placeholder = @"输入一个用户名";
    [self leftView:_field];
    [self.view addSubview:_field];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _field.bottom, self.view.width, 2)];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(30, _field.bottom+18, self.view.width-60, 30)];
    btn.backgroundColor = [UIColor redColor];
    btn.layer.cornerRadius = 7;
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(bindingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)bindingAction:(UIButton *)sender {
//    NSLog(@"binding");
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [_mdict setObject:_field.text forKey:@"username"];
    NSString *url = kThirdRegisterURL;
    [manager POST:url parameters:_mdict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"result:%@",responseObject);
        if ([[responseObject objectForKey:@"resultCode"] intValue] == 0) {
            WFUser *user = [WFUser sharedUser];
            user.token = [responseObject objectForKey:@"token"];
            user.user_id = [[responseObject objectForKey:@"user"] objectForKey:@"_id"];
            user.email = [[responseObject objectForKey:@"user"] objectForKey:@"email"];
            user.password = [[responseObject objectForKey:@"user"] objectForKey:@"password"];
            user.phone = [[responseObject objectForKey:@"user"] objectForKey:@"phone"];
            user.username = [[responseObject objectForKey:@"user"] objectForKey:@"username"];
            user.imageToken = [responseObject objectForKey:@"imageToken"];
            user.imageURL = [[responseObject objectForKey:@"user"] objectForKey:@"imageUrl"];
            user.platform = [[responseObject objectForKey:@"user"] objectForKey:@"platform"];
            user.openId = [[responseObject objectForKey:@"user"] objectForKey:@"openId"];
            [[NSUserDefaults standardUserDefaults] setObject:user.phone forKey:USERPHONE];
            [[NSUserDefaults standardUserDefaults] setObject:user.password forKey:USERPASSWORD];
            MainViewController *mainViewController = [[MainViewController alloc] init];
            MainNavController *nav = [[MainNavController alloc] initWithRootViewController:mainViewController];
            self.view.window.rootViewController = nav;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
}

- (void)leftView:(UITextField *)field {
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(field.left, field.top, 10, field.height)];
    field.leftView = leftView;
    field.leftViewMode = UITextFieldViewModeAlways;
}

@end
