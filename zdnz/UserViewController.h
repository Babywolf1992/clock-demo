//
//  UserViewController.h
//  zdnz
//
//  Created by babywolf on 16/1/7.
//  Copyright © 2016年 com.babywolf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFUser.h"

@interface UserViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) WFUser *user;
@property (nonatomic, strong) UITableView *tableView;

@end
