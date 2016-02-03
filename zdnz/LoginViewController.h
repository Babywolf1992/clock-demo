//
//  LoginViewController.h
//  zdnz
//
//  Created by babywolf on 15/12/22.
//  Copyright © 2015年 com.babywolf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TencentOpenAPI.framework/Headers/TencentOAuth.h"
#import "SinaOAuthDelegate.h"
@interface LoginViewController : UIViewController<TencentSessionDelegate,UIAlertViewDelegate,SinaOAuthDelegate>

@property (nonatomic, strong) UITextField *phone;
@property (nonatomic, strong) UITextField *password;
@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) TencentOAuth *tencentOAuth;

- (void)thirdLogin:(NSDictionary *)dic;

@end
