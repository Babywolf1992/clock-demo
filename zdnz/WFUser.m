//
//  WFUser.m
//  zdnz
//
//  Created by babywolf on 15/12/30.
//  Copyright © 2015年 com.babywolf. All rights reserved.
//

#import "WFUser.h"

@implementation WFUser
static WFUser *userInstance = nil;
+ (instancetype)sharedUser
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        userInstance = [[self alloc] init];
    });
    return userInstance;
}

- (NSString *)description {
    NSString *str = [NSString stringWithFormat:@"username=%@,password=%@,phone=%@,email=%@,imageURL=%@",_username,_password,_phone,_email,_imageURL];
    return str;
}

@end
