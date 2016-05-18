//
//  ZXPersonalViewManager.h
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/17.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFNetWorkManager.h"
@interface ZXPersonalViewManager : NSObject
+(id)defaultManager;
/**
 *  @author pangqingyao, 15-11-17 16:11:04
 *
 *  获取个人信息
 *
 *  @param uid     用户id
 *  @param token   token
 *  @param success 成功回调
 *  @param error   错误回调
 *  @param failed  失败回调
 */
-(void)requestPersonalInfoWithUid:(NSString *)uid WithToken:(NSString *)token Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed;

/**
 *  @author pangqingyao, 15-11-17 16:11:07
 *
 *  退出登录
 *
 *  @param uid     用户id
 *  @param token   token
 *  @param success 成功回调
 *  @param error   错误回调
 *  @param failed  失败回调
 */
-(void)loginOutWithWithUid:(NSString *)uid WithToken:(NSString *)token Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed;
@end
