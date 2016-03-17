//
//  AppDelegate.m
//  zdnz
//
//  Created by babywolf on 15/12/21.
//  Copyright © 2015年 com.babywolf. All rights reserved.
//

#import "AppDelegate.h"

#import "Contants.h"
#import "TencentOpenAPI.framework/Headers/TencentOAuth.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kSINA_AppKey];
//    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"]];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - tencentOpenAPI
- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options {
    NSLog(@"%@",url);
    NSString *sourceApplication = [options objectForKey:@"UIApplicationOpenURLOptionsSourceApplicationKey"];
    if ([sourceApplication isEqualToString:@"com.tencent.mqq"]) {
        //腾讯qq登陆
        return [TencentOAuth HandleOpenURL:url];
    }else if ([sourceApplication isEqualToString:@"com.sina.weibo"]) {
        //新浪微博登陆
        return [WeiboSDK handleOpenURL:url delegate:self];
    }else if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        //微信登陆
    }
    return NO;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"%@",url);
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if ([TencentOAuth HandleOpenURL:url]) {
        return [TencentOAuth HandleOpenURL:url];
    }else if ([WeiboSDK handleOpenURL:url delegate:self]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    return NO;
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
//        NSString *title = NSLocalizedString(@"认证结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        NSLog(@"%@",response.requestUserInfo);
        NSDictionary *dict;
        if (response.requestUserInfo) {
            dict = @{@"access_token":[response.requestUserInfo objectForKey:@"access_token"],@"uid":[response.requestUserInfo objectForKey:@"uid"]};
        }else {
            return;
        }
        if ([self.delegate respondsToSelector:@selector(getUserInfo:)]) {
            [self.delegate getUserInfo:dict];
        }
    }
}

@end
