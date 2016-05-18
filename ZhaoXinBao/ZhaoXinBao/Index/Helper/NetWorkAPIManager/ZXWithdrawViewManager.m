//
//  ZXWithdrawViewManager.m
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/17.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import "ZXWithdrawViewManager.h"
static ZXWithdrawViewManager *withdrawManager;
@implementation ZXWithdrawViewManager
+(id)defaultManager
{
    if (withdrawManager == nil) {
        withdrawManager = [[ZXWithdrawViewManager alloc] init];
    }
    return withdrawManager;
}

-(void)withdrawMoneyWithUid:(NSString *)uid WithToken:(NSString *)token Amount:(NSNumber *)amount Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed
{
    NSString *url = [NSString stringWithFormat:@"%@%@",API_BASE,ZX_Withdraw_API];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",amount,@"amount", nil];
    [[RFNetWorkManager defaultManager] post:url parameters:para success:success error:error failed:failed];
}

-(void)withdrawInfoWithUid:(NSString *)uid WithToken:(NSString *)token Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed
{
    NSString *url = [NSString stringWithFormat:@"%@%@",API_BASE,ZX_WithdrawInfo_API];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token", nil];
    [[RFNetWorkManager defaultManager] post:url parameters:para success:success error:error failed:failed];
}
@end
