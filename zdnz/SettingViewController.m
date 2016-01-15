//
//  SettingViewController.m
//  zdnz
//
//  Created by babywolf on 16/1/8.
//  Copyright © 2016年 com.babywolf. All rights reserved.
//

#import "SettingViewController.h"
#import "Contants.h"
#import "AFHTTPRequestOperationManager.h"

@interface SettingViewController()
@property (nonatomic, strong) UITextField *field;
@end

@implementation SettingViewController

- (instancetype)initWithMessage:(NSString *)message {
    if (self = [super init]) {
        self.title = @"设置";
        self.message = message;
    }
    return self;
}

-(WFUser *)user {
    if (!_user) {
        _user = [WFUser sharedUser];
    }
    return _user;
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    _field = [[UITextField alloc] initWithFrame:CGRectMake(10, 64, self.view.width-20, 40)];
    _field.textAlignment = NSTextAlignmentRight;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    _field.leftViewMode = UITextFieldViewModeAlways;
    _field.leftView = label;
    [self.view addSubview:_field];
    if ([_message  isEqualToString:@"username"]) {
        label.text = @"用户名:";
        _field.text = self.user.username;
    }else if ([_message isEqualToString:@"email"]) {
        label.text = @"电子邮箱:";
        _field.text = self.user.email;
    }
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.height-50, self.view.width-40, 30)];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    btn.layer.cornerRadius = 5;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapAction {
    [_field resignFirstResponder];
    
}

- (void)commitAction {
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url = kModifyUserURL;
    NSString *key = @"";
    if ([_message  isEqualToString:@"username"]) {
        key = @"username";
    }else if ([_message isEqualToString:@"email"]) {
        key = @"email";
    }
    NSDictionary *parameters = @{@"userId":self.user.user_id,@"token":self.user.token,key:_field.text};
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"result:%@",responseObject);
        if ([_message  isEqualToString:@"username"]) {
            self.user.username = _field.text;
        }else if ([_message isEqualToString:@"email"]) {
            self.user.email = _field.text;
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
}

@end
