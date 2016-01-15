//
//  WFUtils.h
//  zdnz
//
//  Created by babywolf on 15/12/23.
//  Copyright © 2015年 com.babywolf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WFUtils : NSObject

+ (BOOL)validateMobile:(NSString *)mobileNum;
+ (BOOL)validatePassword:(NSString *)password;

@end
