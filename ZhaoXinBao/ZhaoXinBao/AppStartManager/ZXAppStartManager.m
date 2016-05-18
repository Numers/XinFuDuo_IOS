//
//  ZXAppStartManager.m
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/12.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import "ZXAppStartManager.h"
#import "RFGeneralManager.h"
#import "AppDelegate.h"
#import "AppUtils.h"
#import "ZXGuidViewController.h"
#import "ZXLoginScrollViewController.h"
#define HostProfilePlist @"PersonProfile.plist"
static ZXAppStartManager *manager;
@implementation ZXAppStartManager
+(id)defaultManager
{
    if (manager == nil) {
        manager = [[ZXAppStartManager alloc] init];
    }
    return manager;
}

-(id)returnHomeViewController
{
    return zxHomeVC;
}

-(Member *)currentHost
{
    if (host == nil) {
        host = [self getProfileFromPlist];
    }
    return host;
}

-(void)setHostMember:(Member *)member
{
    if (member) {
        host = member;
        [self saveProfileToPlist];
    }
}

-(void)removeLocalHostMemberData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *selfInfoPath = [documentsPath stringByAppendingPathComponent:HostProfilePlist];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:selfInfoPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:selfInfoPath error:nil];
    }
    
    host = nil;
}

-(void)saveProfileToPlist
{
    NSDictionary *dic = [host dictionaryInfo];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *selfInfoPath = [documentsPath stringByAppendingPathComponent:HostProfilePlist];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:selfInfoPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:selfInfoPath error:nil];
    }
    
    [dic writeToFile:selfInfoPath atomically:YES];
}

-(Member *)getProfileFromPlist
{
    Member *member = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *selfInfoPath = [documentsPath stringByAppendingPathComponent:HostProfilePlist];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:selfInfoPath])
    {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:selfInfoPath];
        if (dic != nil) {
            member = [[Member alloc] initlizedWithDictionary:dic];
        }
    }
    return member;
}

-(void)startApp
{
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"NavBackIndicatorImage"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"NavBackIndicatorImage"]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    [[RFGeneralManager defaultManager] getGlovalVarWithVersion];
    [self currentHost];
    if (host) {
        NSString *autoLogin = [AppUtils localUserDefaultsForKey:KMY_AutoLogin];
        if ([autoLogin isEqualToString:@"1"]) {
            [self setHomeView];
        }else{
            [self setLoginView];
        }
    }else{
        [self setGuidView];
    }
}

-(void)setHomeView
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    zxHomeVC = [storyBoard instantiateViewControllerWithIdentifier:@"HomeViewIdentify"];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:zxHomeVC];
    [[(AppDelegate *)[UIApplication sharedApplication].delegate window] setRootViewController:_navigationController];
}

-(void)setGuidView
{
    ZXGuidViewController *zxGuidVC = [[ZXGuidViewController alloc] init];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:zxGuidVC];
    [[(AppDelegate *)[UIApplication sharedApplication].delegate window] setRootViewController:_navigationController];
}

-(void)setLoginView
{
    ZXLoginScrollViewController *zxLoginScrollVC = [[ZXLoginScrollViewController alloc] init];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:zxLoginScrollVC];
    [[(AppDelegate *)[UIApplication sharedApplication].delegate window] setRootViewController:_navigationController];
}

-(void)loginOut
{
    [_navigationController popToRootViewControllerAnimated:NO];
    _navigationController = nil;
    [self setLoginView];
    [AppUtils localUserDefaultsValue:@"0" forKey:KMY_AutoLogin];
}
@end
