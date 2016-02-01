//
//  SinaOAuthDelegate.h
//  zdnz
//
//  Created by babywolf on 16/2/1.
//  Copyright © 2016年 com.babywolf. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SinaOAuthDelegate <NSObject>

- (void)getUserInfo:(NSDictionary *)dic;

@end
