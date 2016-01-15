//
//  WFClock.h
//  zdnz
//
//  Created by babywolf on 15/12/30.
//  Copyright © 2015年 com.babywolf. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    ClockRepeatTypeOnce = -1,
    ClockRepeatTypeCustom = 0,
    ClockRepeatTypeEveryday = 1,
    ClockRepeatTypeWorkday = 2,
    ClockRepeatTypeMonth = 3,
    ClockRepeatTypeYear = 4
}ClockRepeatType;

@interface WFClock : NSObject

@property (nonatomic, copy) NSString *clock_id;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) ClockRepeatType repeatType;
@property (nonatomic, copy) NSString *repeatRule;
@property (nonatomic, copy) NSString *remindTime;

- (instancetype)initWithDate:(NSDate *)date;

@end
