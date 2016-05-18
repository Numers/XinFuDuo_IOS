//
//  ZXAmountDetailsViewManager.h
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/17.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFNetWorkManager.h"
@interface ZXAmountDetailsViewManager : NSObject
+(id)defaultManager;
/**
 *  @author pangqingyao, 15-11-17 18:11:49
 *
 *  获取账单详情
 *
 *  @param uid     用户id
 *  @param token   token
 *  @param pageNum 分页数
 *  @param success 成功回调
 *  @param error   错误回调
 *  @param failed  失败回调
 */
-(void)requestAmountDetailsWithUid:(NSString *)uid WithToken:(NSString *)token WithPageNum:(NSInteger)pageNum Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed;
@end
