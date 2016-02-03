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

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UITextField *verifyField;
@property (nonatomic, strong) UIButton *verifyBtn;

@end

@implementation WFBindPhoneController

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"绑定手机号";
    }
    return self;
}

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
    [_verifyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_verifyBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    _verifyBtn.layer.borderWidth = 1;
    _verifyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _verifyBtn.layer.cornerRadius = 5;
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
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
//    NSLog(@"getVeridation");
    // 多线程启动NSTimer
    [self startTimer];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *parameters = @{@"phone":_phoneField.text};
    NSString *url = kSendMessage;
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"resultCode"] intValue] == 0) {
            //成功
            
        }else {
            //失败
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
}

-(void)startTimer{
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
                [_verifyBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                _verifyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                _verifyField.userInteractionEnabled = YES;
                _verifyBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
//                NSLog(@"____%@",strTime);
                [_verifyBtn setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                _verifyField.userInteractionEnabled = NO;
                _verifyBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)commentAction:(UIButton *)sender {
    WFUser *user = [WFUser sharedUser];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url = kThirdBindUserURL;
    NSDictionary *parameters = @{@"openId":user.openId,@"platform":user.platform,@"phone":_phoneField.text,@"code":_verifyField.text};
    NSLog(@"%@",parameters);
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 成功
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"resultCode"] intValue] == 0) {
            WFUser *user = [WFUser sharedUser];
            [user setKeyValues:[responseObject objectForKey:@"user"]];
            user.token = [responseObject objectForKey:@"token"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 失败
        NSLog(@"%@",error);
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
