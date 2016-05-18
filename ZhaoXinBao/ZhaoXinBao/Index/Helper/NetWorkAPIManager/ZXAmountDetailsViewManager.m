//
//  ZXAmountDetailsViewManager.m
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/17.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import "ZXAmountDetailsViewManager.h"
static ZXAmountDetailsViewManager *amountDetailsManager;
@implementation ZXAmountDetailsViewManager
+(id)defaultManager
{
    if (amountDetailsManager == nil) {
        amountDetailsManager = [[ZXAmountDetailsViewManager alloc] init];
    }
    return amountDetailsManager;
}

-(void)requestAmountDetailsWithUid:(NSString *)uid WithToken:(NSString *)token WithPageNum:(NSInteger)pageNum Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed
{
    NSString *url = [NSString stringWithFormat:@"%@%@",API_BASE,ZX_AmountDetails_API];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",[NSNumber numberWithInteger:pageNum],@"page",@"10",@"num", nil];
    [[RFNetWorkManager defaultManager] post:url parameters:para success:success error:error failed:failed];
}
@end
