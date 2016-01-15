//
//  WFAnniversary.m
//  zdnz
//
//  Created by babywolf on 16/1/5.
//  Copyright © 2016年 com.babywolf. All rights reserved.
//

#import "WFAnniversary.h"

@implementation WFAnniversary

- (instancetype)initWithDate:(NSDate *)date {
    if (self = [super init]) {
        self.date = date;
        self.title = @"我的纪念日";
        self.repeatType = 4;
        self.repeatRule = @"";
        self.advanceDays = @"3";
        self.mute = @"0";
    }
    return self;
}

- (NSString *)description {
    NSString *str = [NSString stringWithFormat:@"title:%@,repeatType:%d,advanceDays:%@",self.title,self.repeatType,self.advanceDays];
    return str;
}

@end
