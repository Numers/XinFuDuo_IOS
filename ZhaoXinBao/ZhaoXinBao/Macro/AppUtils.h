//
//  AppUtils.h
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/11.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define API_BASE  [AppUtils returnBaseUrl]
@interface AppUtils : NSObject
+ (NSString*) appVersion;
+(void)setUrlWithState:(BOOL)state;
+(NSString *)returnBaseUrl;
+ (BOOL)isMobileNumber:(NSString *)mobileNumString;
+ (BOOL)isIDCardNumber:(NSString *)value;
+ (BOOL)isEmailValid:(NSString *)email;
+ (BOOL)isPureInt:(NSString*)string;
+ (BOOL)isPureFloat:(NSString*)string;
+(BOOL)isValidateNumericalValue:(NSString *)string;
+ (BOOL)isNullStr:(NSString *)str;
+ (BOOL)isLogined:(NSString *)uid;

+ (void)showInfo:(NSString*)str;

/**
 *  显示在指定VIEW中心
 */
+ (void)showProgressBarForView:(UIView *)view;
+ (void)hideProgressBarForView:(UIView *)view;

/**
 存取缓存数据方法
 */
+(id)localUserDefaultsForKey:(NSString *)key;
+(void)localUserDefaultsValue:(id)value forKey:(NSString *)key;
@end
