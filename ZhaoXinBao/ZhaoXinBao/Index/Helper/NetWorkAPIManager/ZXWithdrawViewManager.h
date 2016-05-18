//
//  ZXWithdrawViewManager.h
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/17.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFNetWorkManager.h"
@interface ZXWithdrawViewManager : NSObject
+(id)defaultManager;
/**
 *  @author pangqingyao, 15-11-17 16:11:45
 *
 *  提现Api
 *
 *  @param uid     用户id
 *  @param token   token
 *  @param amount  提现金额
 *  @param success 成功回调
 *  @param error   错误回调
 *  @param failed  失败回调
 */
-(void)withdrawMoneyWithUid:(NSString *)uid WithToken:(NSString *)token Amount:(NSNumber *)amount Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed;
/**
 *  @author pangqingyao, 15-11-17 16:11:35
 *
 *  提现信息
 *
 *  @param uid     用户id
 *  @param token   token
 *  @param success 成功回调
 *  @param error   错误回调
 *  @param failed  失败回调
 */
-(void)withdrawInfoWithUid:(NSString *)uid WithToken:(NSString *)token Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed;
@end
