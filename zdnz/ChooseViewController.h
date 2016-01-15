//
//  ChooseViewController.h
//  zdnz
//
//  Created by babywolf on 15/12/31.
//  Copyright © 2015年 com.babywolf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFClock.h"
#import "WFMeeting.h"
#import "WFAnniversary.h"
typedef enum{
    AddModeClock = 1,
    AddModeMeeting = 2,
    AddModeAnniversary = 3
}AddMode;

@interface ChooseViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) int repeatType;
@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic, strong) WFClock *clock;
@property (nonatomic, strong) WFMeeting *meeting;
@property (nonatomic, strong) WFAnniversary *ann;
@property (nonatomic, copy) NSString *repeatRule;

@property (nonatomic, assign) AddMode addMode;

@end
