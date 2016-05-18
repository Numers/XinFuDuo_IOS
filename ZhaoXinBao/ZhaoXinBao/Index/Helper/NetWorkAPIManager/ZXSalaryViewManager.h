//
//  ZXSalaryViewManager.h
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/18.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFNetWorkManager.h"
@interface ZXSalaryViewManager : NSObject
+(id)defaultManager;
/**
 *  @author pangqingyao, 15-11-18 15:11:46
 *
 *  工资记录
 *
 *  @param uid     用户id
 *  @param token   token
 *  @param pageNum 分页数
 *  @param success 成功回调
 *  @param error   错误回调
 *  @param failed  失败回调
 */
-(void)requestSalaryListWithUid:(NSString *)uid WithToken:(NSString *)token WithPageNum:(NSInteger)pageNum Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed;
/**
 *  @author pangqingyao, 15-11-18 15:11:51
 *
 *  最近的工资记录
 *
 *  @param uid     用户id
 *  @param token   token
 *  @param success 成功回调
 *  @param error   错误回调
 *  @param failed  失败回调
 */
-(void)requestLatestSalaryWithUid:(NSString *)uid WithToken:(NSString *)token Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed;
@end
