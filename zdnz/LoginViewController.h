//
//  LoginViewController.h
//  zdnz
//
//  Created by babywolf on 15/12/22.
//  Copyright © 2015年 com.babywolf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TencentOpenAPI.framework/Headers/TencentOAuth.h"

@interface LoginViewController : UIViewController<TencentSessionDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITextField *phone;
@property (nonatomic, strong) UITextField *password;
@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@end
