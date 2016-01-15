//
//  WFAnniversary.h
//  zdnz
//
//  Created by babywolf on 16/1/5.
//  Copyright © 2016年 com.babywolf. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    AnniversaryRepeatTypeOnce = -1,
    AnniversaryRepeatTypeCustom = 0,
    AnniversaryRepeatTypeEveryday = 1,
    AnniversaryRepeatTypeWorkday = 2,
    AnniversaryRepeatTypeMonth = 3,
    AnniversaryRepeatTypeYear = 4
}AnniversaryRepeatType;

@interface WFAnniversary : NSObject

@property (nonatomic, copy) NSString *anniversary_id;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *advanceDays;
@property (nonatomic, copy) NSString *mute;     //静音模式
@property (nonatomic, assign) AnniversaryRepeatType repeatType;
@property (nonatomic, copy) NSString *repeatRule;
@property (nonatomic, copy) NSString *remindTime;

- (instancetype)initWithDate:(NSDate *)date;
@end
