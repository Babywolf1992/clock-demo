//
//  WFNotificationTool.h
//  zdnz
//
//  Created by babywolf on 16/3/9.
//  Copyright © 2016年 com.babywolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WFNotificationTool : NSObject

+ (void)scheduleLocalNotificationWithDate:(NSDate *)date object:(id)object;

@end
