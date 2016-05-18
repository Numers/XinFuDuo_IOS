//
//  ZXLoginViewAPIManager.h
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/16.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFNetWorkManager.h"

@interface ZXLoginViewAPIManager : NSObject
+(id)defaultManager;
/**
 *  @author pangqingyao, 15-11-17 11:11:52
 *
 *  用户登录
 *
 *  @param phone   手机号
 *  @param code    验证码
 *  @param success 成功回调
 *  @param error   错误回调
 *  @param failed  失败回调
 */
-(void)loginWithPhone:(NSString *)phone WithCode:(NSString *)code Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed;

/**
 *  @author pangqingyao, 15-11-17 11:11:39
 *
 *  获取验证码
 *
 *  @param phone   手机号
 *  @param success 成功回调
 *  @param error   错误回调
 *  @param failed  失败回调
 */
-(void)requestValidateCodeWithPhone:(NSString *)phone Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed;
@end
