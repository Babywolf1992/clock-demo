//
//  WFMeeting.h
//  zdnz
//
//  Created by babywolf on 15/12/31.
//  Copyright © 2015年 com.babywolf. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    MeetingRepeatTypeOnce = -1,
    MeetingRepeatTypeCustom = 0,
    MeetingRepeatTypeEveryday = 1,
    MeetingRepeatTypeWorkday = 2,
    MeetingRepeatTypeMonth = 3,
    MeetingRepeatTypeYear = 4
}MeetingRepeatType;

@interface WFMeeting : NSObject

@property (nonatomic, strong) NSString *meeting_id;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) MeetingRepeatType repeatType;
@property (nonatomic, copy) NSString *repeatRule;
@property (nonatomic, copy) NSString *preTime;
@property (nonatomic, copy) NSString *mute;     //静音模式
@property (nonatomic, copy) NSString *remindTime;

- (instancetype)initWithDate:(NSDate *)date;

@end
