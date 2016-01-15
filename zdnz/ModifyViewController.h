//
//  ModifyViewController.h
//  zdnz
//
//  Created by babywolf on 16/1/5.
//  Copyright © 2016年 com.babywolf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFClock.h"
#import "WFMeeting.h"
#import "WFAnniversary.h"
#import "WFUser.h"
typedef enum {
    ModifyModeClock = 0,
    ModifyModeMeeting = 1,
    ModifyModeAnniversary = 2
}ModifyMode;

@interface ModifyViewController : UIViewController

@property (nonatomic, assign) ModifyMode mode;
@property (nonatomic, strong) WFClock *clock;
@property (nonatomic, strong) WFMeeting *meeting;
@property (nonatomic, strong) WFAnniversary *ann;
@property (nonatomic, strong) WFUser *user;

- (instancetype)initWithMode:(ModifyMode)mode;

@end
