//
//  WFUtils.m
//  zdnz
//
//  Created by babywolf on 15/12/23.
//  Copyright © 2015年 com.babywolf. All rights reserved.
//

#import "WFUtils.h"

@implementation WFUtils

#pragma mark 验证手机号码的格式
+ (BOOL)validateMobile:(NSString *)mobileNum
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^[1][3-578]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobileNum];
}

#pragma mark 验证密码的格式
+ (BOOL)validatePassword:(NSString *)password
{
    //密码为8～16位的数字，小写字母和大写字母
    NSString *passwordRegex = @"^[a-zA-Z0-9]{8,16}$";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passwordRegex];
    return [passwordTest evaluateWithObject:password];
}

@end
