//
//  AddViewController.h
//  zdnz
//
//  Created by babywolf on 15/12/30.
//  Copyright © 2015年 com.babywolf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFClock.h"
#import "WFUser.h"
#import "WFMeeting.h"
#import "WFAnniversary.h"

@interface AddViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong) NSDate *selectDay;
@property (nonatomic, strong) WFClock *clock;
@property (nonatomic, strong) WFMeeting *meeting;
@property (nonatomic, strong) WFAnniversary *ann;
@property (nonatomic, strong) WFUser *user;
- (instancetype)initWithDate:(NSDate *)date;

@end
