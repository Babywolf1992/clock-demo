//
//  UserViewController.m
//  zdnz
//
//  Created by babywolf on 16/1/7.
//  Copyright © 2016年 com.babywolf. All rights reserved.
//

#import "UserViewController.h"
#import "Contants.h"
#import "SettingViewController.h"
#import "SettingPasswordViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "QiniuSDK.h"
#import "UIImageView+WebCache.h"
#import "WFBindPhoneController.h"
#import "LoginViewController.h"
#import "MBProgressHUD+MJ.h"

@interface UserViewController()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *emailLabel;

@end

@implementation UserViewController

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"个人中心";
        self.user = [WFUser sharedUser];
    }
    return self;
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
//    NSLog(@"%@",_user);
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
//    _tableView.separatorInset
    [self.view addSubview:_tableView];
    [self clearExtraLine:_tableView];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(30, self.view.height-50, self.view.width-60, 30)];
    [btn setTitle:@"注销" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _usernameLabel.text = _user.username;
    _emailLabel.text = _user.email;
}

- (void)logoutAction:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERPLATFORM];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERPASSWORD];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERPHONE];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USEROPENID];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navCtrl = [storyboard instantiateViewControllerWithIdentifier:@"BaseNav"];
    self.view.window.rootViewController = navCtrl;
}

#pragma mark - UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
        {
            //头像
            cell.textLabel.text = @"头像";
            _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width-40-20, 10, 40, 40)];
            [cell addSubview:_imageView];
            _imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage)];
            [_imageView addGestureRecognizer:tap];
            if ([_user.imageURL  isEqualToString: @""] || !_user.imageURL) {
                _imageView.image = [UIImage imageNamed:@"14"];
            }else {
//                NSLog(@"%@",_user.imageURL);
                NSURL *url = [NSURL URLWithString:_user.imageURL];
                [_imageView setImageWithURL:url];
            }
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"手机号";
            cell.detailTextLabel.text = _user.phone;
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"用户名";
//            cell.detailTextLabel.text = _user.username;
            _usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-110, 5, 80, 30)];
            _usernameLabel.text = _user.username;
            _usernameLabel.textAlignment = NSTextAlignmentRight;
            [cell addSubview:_usernameLabel];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 3:
        {
            cell.textLabel.text = @"电子邮箱";
//            cell.detailTextLabel.text = _user.email;
            _emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-110, 5, 80, 30)];
            _emailLabel.text = _user.email;
            _emailLabel.textAlignment = NSTextAlignmentRight;
            [cell addSubview:_emailLabel];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 4:
        {
            cell.textLabel.text = @"修改密码";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 5:
        {
            cell.textLabel.text = @"绑定手机号";
//            cell.accessoryType = _user.phone.length == 0 ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
            if (_user.phone.length == 0) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate Method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 60;
    }else {
        return 40;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        //修改用户名
        SettingViewController *settingCtrl = [[SettingViewController alloc] initWithMessage:@"username"];
        [self.navigationController pushViewController:settingCtrl animated:YES];
    }else if (indexPath.row == 3) {
        //修改邮箱
        SettingViewController *settingCtrl = [[SettingViewController alloc] initWithMessage:@"email"];
        [self.navigationController pushViewController:settingCtrl animated:YES];
    }else if (indexPath.row == 4) {
        //修改密码
        SettingPasswordViewController *setpadCtrl = [[SettingPasswordViewController alloc] init];
        [self.navigationController pushViewController:setpadCtrl animated:YES];
    }else if (indexPath.row == 5) {
        //绑定手机号
        if (_user.phone.length == 0) {
            WFBindPhoneController *bindingCtrl = [[WFBindPhoneController alloc] init];
            [self.navigationController pushViewController:bindingCtrl animated:YES];
        }
    }
}

#pragma mark - 去掉多余的线
- (void)clearExtraLine :(UITableView *)tableView{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

/**
 调用相册，相机
 */
- (void)changeImage {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:photoAction];
    [alertController addAction:cameraAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        //如果是 来自照相机的image，那么先保存
        UIImage* original_image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImageWriteToSavedPhotosAlbum(original_image, self,nil,nil);
    }
    
    //获得编辑过的图片
    UIImage* image = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    
    [self uploadImage:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 图片上传
 */
- (void)uploadImage:(UIImage *)image {
    __block NSString *imageToken = @"";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *pars = @{@"userId":self.user.user_id,@"token":self.user.token};
    [MBProgressHUD showMessage:@"加载中..."];
    [manager POST:kGetImageToken parameters:pars success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"getImageToken:%@",responseObject);
        imageToken = [responseObject objectForKey:@"imageToken"];
        //图片上传
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        NSData *data = [[NSData alloc] init];
        if (UIImagePNGRepresentation(image)) {
            data = UIImagePNGRepresentation(image);
        }else {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
//        NSLog(@"%@",timeSp);
        [upManager putData:data key:timeSp token:imageToken
                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      [MBProgressHUD hideHUD];
                      NSLog(@"info:%@", info);
                      NSLog(@"resp:%@", resp);
                      if (resp) {
                          NSString *imageUrl = [NSString stringWithFormat:@"%@%@",kBaseImageURL,key];
                          //                      NSLog(@"%@",imageUrl);
                          NSDictionary *parameters = @{@"userId":self.user.user_id,@"token":self.user.token,@"imageUrl":imageUrl};
                          [manager POST:kModifyUserURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
                              NSLog(@"result:%@",responseObject);
                              _imageView.image = image;
                              _user.imageURL = imageUrl;
                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              [MBProgressHUD hideHUD];
                              NSLog(@"error:%@",error);
                          }];
                      }
                      
                  } option:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"error:%@",error);
    }];
}

@end
