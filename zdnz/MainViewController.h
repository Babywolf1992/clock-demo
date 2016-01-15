//
//  MainViewController.h
//  zdnz
//
//  Created by babywolf on 15/12/23.
//  Copyright © 2015年 com.babywolf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
#import "WFUser.h"

@interface MainViewController : UIViewController<FSCalendarDataSource, FSCalendarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSDate *selectDay;

@property (strong, nonatomic) FSCalendar *calendar;
@property (strong, nonatomic) WFUser *user;

@property (nonatomic, strong) NSArray *alarms;
@property (nonatomic, strong) NSArray *meetings;
@property (nonatomic, strong) NSArray *anns;

@end
