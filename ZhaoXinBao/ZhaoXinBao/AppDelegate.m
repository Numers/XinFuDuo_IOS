//
//  AppDelegate.m
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/11.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import "AppDelegate.h"
#import "ZXAppStartManager.h"
#import "APService.h"
#import "MobClick.h"
#import "ThirdPartToolsMacros.h"
#import "RFGeneralManager.h"
#import "ZXPerMonthSalaryViewController.h"
#import "ZXLoginErrorAlertViewController.h"

@interface AppDelegate ()
{
    ZXLoginErrorAlertViewController *zxLocalNotificationAlertView;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[ZXAppStartManager defaultManager] startApp];
    //注册推送
    [self pushSettingWithOptions:launchOptions];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushDidLogin:) name:kJPFNetworkDidLoginNotification object:nil];
    
    /**
     *  @author pangqingyao, 15-11-23 14:11:06
     *
     *  友盟统计
     */
    [MobClick startWithAppkey:UMENG_KEY reportPolicy:BATCH channelId:nil];
    [MobClick setAppVersion:XcodeAppVersion];
    [MobClick setCrashReportEnabled:YES];
    
    return YES;
}

-(void)pushDidLogin:(NSNotification *)notification
{
    [APService setBadge:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // 取消本地通知
    [APService clearAllLocalNotifications];
    _registerID = [APService registrationID];
    [APService setTags:[NSSet setWithObject:_registerID] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    [[RFGeneralManager defaultManager] sendClientIdSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } Error:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } Failed:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

-(void)pushSettingWithOptions:(NSDictionary *)launchOptions
{
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [APService handleRemoteNotification:userInfo];
    Member *host = [[ZXAppStartManager defaultManager] currentHost];
    if (!host) {
        return;
    }else{
        NSString *autoLogin = [AppUtils localUserDefaultsForKey:KMY_AutoLogin];
        if ([autoLogin isEqualToString:@"0"]) {
            return;
        }
    }
    UINavigationController *rootNavViewController = (UINavigationController *)self.window.rootViewController;
    NSInteger type = [[userInfo objectForKey:@"type"] integerValue];
    if (type == 1) {
        ZXPerMonthSalaryViewController *zxPerMonthSalaryVC = [[ZXPerMonthSalaryViewController alloc] initWithSalary:nil IsLatest:YES];
        [rootNavViewController pushViewController:zxPerMonthSalaryVC animated:YES];
    }else{
        NSString *msg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        [APService setLocalNotification:[NSDate dateWithTimeIntervalSinceNow:1.0f]
                              alertBody:msg
                                  badge:0
                            alertAction:@"取消"
                          identifierKey:@"kLocalNotificationID"
                               userInfo:userInfo
                              soundName:UILocalNotificationDefaultSoundName
                                 region:nil
                     regionTriggersOnce:YES
                               category:nil];
    }
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"Application did receive local notifications");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    Member *host = [[ZXAppStartManager defaultManager] currentHost];
    if (!host) {
        return;
    }else{
        NSString *autoLogin = [AppUtils localUserDefaultsForKey:KMY_AutoLogin];
        if ([autoLogin isEqualToString:@"0"]) {
            return;
        }
    }
    UINavigationController *rootNavViewController = (UINavigationController *)self.window.rootViewController;
    NSInteger type = [[userInfo objectForKey:@"type"] integerValue];
    if (type == 1) {
        ZXPerMonthSalaryViewController *zxPerMonthSalaryVC = [[ZXPerMonthSalaryViewController alloc] initWithSalary:nil IsLatest:YES];
        [rootNavViewController pushViewController:zxPerMonthSalaryVC animated:YES];
    }
    else{
        NSString *msg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        [APService setLocalNotification:[NSDate dateWithTimeIntervalSinceNow:1.0f]
                              alertBody:msg
                                  badge:0
                            alertAction:@"取消"
                          identifierKey:@"kLocalNotificationID"
                               userInfo:userInfo
                              soundName:UILocalNotificationDefaultSoundName
                                 region:nil
                     regionTriggersOnce:YES
                               category:nil];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [APService setBadge:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
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

@end
