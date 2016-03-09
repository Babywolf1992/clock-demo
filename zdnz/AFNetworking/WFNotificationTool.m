//
//  WFNotificationTool.m
//  zdnz
//
//  Created by babywolf on 16/3/9.
//  Copyright © 2016年 com.babywolf. All rights reserved.
//

#import "WFNotificationTool.h"
#import "WFMeeting.h"
#import "WFClock.h"
#import "WFAnniversary.h"

@implementation WFNotificationTool

+ (void)scheduleLocalNotificationWithDate:(NSDate *)date object:(id)object {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = date;
    if ([object isKindOfClass:[WFMeeting class]]) {
        WFMeeting *meeting = (WFMeeting *)object;
        notification.alertBody = meeting.title;
        notification.alertTitle = @"会议";
        notification.userInfo = @{@"meeting_id":meeting.meeting_id};
        switch (meeting.repeatType) {
            case -1:
                break;
            case 0:
                //自定义规则
                break;
            case 1:
                notification.repeatInterval = NSCalendarUnitDay;
                break;
            case 2:
                //工作日规则
                break;
            case 3:
                notification.repeatInterval = NSCalendarUnitMonth;
                break;
            case 4:
                notification.repeatInterval = NSCalendarUnitYear;
                break;
            default:
                break;
        }
    }else if ([object isKindOfClass:[WFClock class]]) {
        WFClock *clock = (WFClock *)object;
        notification.alertBody = clock.title;
        notification.alertTitle = @"闹钟";
        notification.userInfo = @{@"clock_id":clock.clock_id};
        switch (clock.repeatType) {
            case -1:
                break;
            case 0:
                //自定义规则
                break;
            case 1:
                notification.repeatInterval = NSCalendarUnitDay;
                break;
            case 2:
                //工作日规则
                break;
            case 3:
                notification.repeatInterval = NSCalendarUnitMonth;
                break;
            case 4:
                notification.repeatInterval = NSCalendarUnitYear;
                break;
            default:
                break;
        }
    }else if ([object isKindOfClass:[WFAnniversary class]]) {
        WFAnniversary *anni = (WFAnniversary *)object;
        notification.alertBody = anni.title;
        notification.alertTitle = @"纪念日";
        notification.userInfo = @{@"anniversary_id":anni.anniversary_id};
        switch (anni.repeatType) {
            case -1:
                break;
            case 0:
                //自定义规则
                break;
            case 1:
                notification.repeatInterval = NSCalendarUnitDay;
                break;
            case 2:
                //工作日规则
                break;
            case 3:
                notification.repeatInterval = NSCalendarUnitMonth;
                break;
            case 4:
                notification.repeatInterval = NSCalendarUnitYear;
                break;
            default:
                break;
        }
    }
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

@end
