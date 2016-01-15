//
//  WFClock.m
//  zdnz
//
//  Created by babywolf on 15/12/30.
//  Copyright © 2015年 com.babywolf. All rights reserved.
//

#import "WFClock.h"

@implementation WFClock

- (instancetype)initWithDate:(NSDate *)date {
    if (self = [super init]) {
        self.date = date;
        self.title = @"默认闹钟";
        self.repeatType = 1;
        self.repeatRule = @"";
    }
    return self;
}

- (NSString *)description {
    NSString *str = [NSString stringWithFormat:@"title:%@,repeatType:%d,repeatRule:%@",self.title,self.repeatType,self.repeatRule];
    return str;
}

@end
