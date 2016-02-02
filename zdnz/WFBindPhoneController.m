//
//  WFBindPhoneController.m
//  zdnz
//
//  Created by babywolf on 16/2/2.
//  Copyright © 2016年 com.babywolf. All rights reserved.
//

#import "WFBindPhoneController.h"
#import "Contants.h"
#import "WFUser.h"
#import "WFUtils.h"
#import "AFNetworking.h"
@interface WFBindPhoneController()
@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UITextField *verifyField;
@property (nonatomic, strong) UIButton *verifyBtn;

@end

@implementation WFBindPhoneController

// liftcycle method
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _phoneField = [[UITextField alloc] initWithFrame:CGRectMake(0, 20+64, self.view.width, 35)];
    _phoneField.placeholder = @"输入一个电话号码";
    [self leftView:_phoneField];
    [self.view addSubview:_phoneField];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _phoneField.bottom, self.view.width, 2)];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view];
    
    _verifyField = [[UITextField alloc] initWithFrame:CGRectMake(0, 10+_phoneField.bottom, self.view.width, 35)];
    _verifyField.placeholder = @"输入验证码";
    [self leftView:_verifyField];
    [self.view addSubview:_verifyField];
    
    _verifyBtn = [[UIButton alloc] initWithFrame:CGRectMake(_verifyField.right-90, 4, 80, _verifyField.height-8)];
    [_verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _verifyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_verifyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_verifyBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    _verifyBtn.enabled = NO;
    [_verifyBtn addTarget:self action:@selector(getVeridation) forControlEvents:UIControlEventTouchUpInside];
    [_verifyField addSubview:_verifyBtn];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, _verifyField.bottom, self.view.width, 2)];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view2];
    
    UIButton *commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, _verifyField.bottom+18, self.view.width-60, 30)];
    commitBtn.backgroundColor = [UIColor redColor];
    commitBtn.layer.cornerRadius = 7;
    [commitBtn setTitle:@"确认" forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:_phoneField];
}

- (void)textDidChange {
    BOOL flag = [WFUtils validateMobile:_phoneField.text];
    if (flag) {
        _verifyBtn.enabled = YES;
    }else {
        _verifyBtn.enabled = NO;
    }
}

- (void)leftView:(UITextField *)field {
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(field.left, field.top, 10, field.height)];
    field.leftView = leftView;
    field.leftViewMode = UITextFieldViewModeAlways;
}

- (void)getVeridation {
    NSLog(@"getVeridation");
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *parameters = @{@"phone":_phoneField.text};
    NSString *url = kSendMessage;
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //成功
        NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
}

- (void)commentAction:(UIButton *)sender {
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
