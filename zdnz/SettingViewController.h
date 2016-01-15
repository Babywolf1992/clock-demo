//
//  SettingViewController.h
//  zdnz
//
//  Created by babywolf on 16/1/8.
//  Copyright © 2016年 com.babywolf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFUser.h"

@interface SettingViewController : UIViewController

@property (nonatomic, strong) WFUser *user;
@property (nonatomic, copy) NSString *message;

- (instancetype)initWithMessage:(NSString *)message;

@end
