//
//  ZXHomeViewManager.m
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/17.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import "ZXHomeViewManager.h"
static ZXHomeViewManager *homeManager;
@implementation ZXHomeViewManager
+(id)defaultManager
{
    if (homeManager == nil) {
        homeManager = [[ZXHomeViewManager alloc] init];
    }
    return homeManager;
}

-(void)requestAccountAndRateWithUid:(NSString *)uid WithToken:(NSString *)token Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed
{
    NSString *url = [NSString stringWithFormat:@"%@%@",API_BASE,ZX_Index_API];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token", nil];
    [[RFNetWorkManager defaultManager] post:url parameters:para success:success error:error failed:failed];
}
@end
