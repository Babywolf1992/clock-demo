//
//  WFUser.h
//  zdnz
//
//  Created by babywolf on 15/12/30.
//  Copyright © 2015年 com.babywolf. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USERPHONE @"phone"
#define USERPASSWORD @"password"

@interface WFUser : NSObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *imageToken;

// 第三方登陆相关
@property (nonatomic, copy) NSString *platform;
@property (nonatomic, copy) NSString *openId;

+ (instancetype)sharedUser;

@end
