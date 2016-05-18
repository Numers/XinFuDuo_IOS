//
//  ZXLoginViewAPIManager.m
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/16.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import "ZXLoginViewAPIManager.h"
static ZXLoginViewAPIManager *loginManager;
@implementation ZXLoginViewAPIManager
+(id)defaultManager
{
    if (loginManager == nil) {
        loginManager = [[ZXLoginViewAPIManager alloc] init];
    }
    return loginManager;
}

-(void)loginWithPhone:(NSString *)phone WithCode:(NSString *)code Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed
{
    NSString *url = [NSString stringWithFormat:@"%@%@",API_BASE,ZX_Login_API];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone",code,@"code", nil];
    [[RFNetWorkManager defaultManager] post:url parameters:para success:success error:error failed:failed];
}

-(void)requestValidateCodeWithPhone:(NSString *)phone Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed
{
    NSString *url = [NSString stringWithFormat:@"%@%@",API_BASE,ZX_ValidateCode_API];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone", nil];
    [[RFNetWorkManager defaultManager] get:url parameters:para success:success error:error failed:failed];
}
@end
