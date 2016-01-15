//
//  WFMeeting.m
//  zdnz
//
//  Created by babywolf on 15/12/31.
//  Copyright © 2015年 com.babywolf. All rights reserved.
//

#import "WFMeeting.h"

@implementation WFMeeting

- (instancetype)initWithDate:(NSDate *)date {
    if (self = [super init]) {
        self.date = date;
        self.title = @"我的会议";
        self.repeatType = 1;
        self.repeatRule = @"";
        self.preTime = @"3600000";
        self.mute = @"0";
    }
    return self;
}

- (NSString *)description {
    NSString *str = [NSString stringWithFormat:@"title:%@,repeatType:%d,pretime:%@,remindTime:%@",self.title,self.repeatType,self.preTime,self.remindTime];
    return str;
}

@end
