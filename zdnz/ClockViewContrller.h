//
//  ClockViewContrller.h
//  zdnz
//
//  Created by babywolf on 16/1/3.
//  Copyright © 2016年 com.babywolf. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    ShowModeClock = 0,
    ShowModeMeeting = 1,
    ShowModeAnniversary = 2
}ShowMode;


@interface ClockViewContrller : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) ShowMode mode;
@property (nonatomic, copy) NSArray *dataArr;

- (instancetype)initWithMode:(ShowMode)mode;

@end
