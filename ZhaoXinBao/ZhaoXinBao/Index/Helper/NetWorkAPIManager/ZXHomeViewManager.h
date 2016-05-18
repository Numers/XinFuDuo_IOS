//
//  ZXHomeViewManager.h
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/17.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFNetWorkManager.h"
@interface ZXHomeViewManager : NSObject
+(id)defaultManager;
/**
 *  @author pangqingyao, 15-11-17 14:11:39
 *
 *  获取首页账户信息和七日年化利率
 *
 *  @param uid     用户id
 *  @param token   token
 *  @param success 成功回调
 *  @param error   错误回调
 *  @param failed  失败回调
 */
-(void)requestAccountAndRateWithUid:(NSString *)uid WithToken:(NSString *)token Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed;
@end
