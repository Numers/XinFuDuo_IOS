//
//  ZXSalaryViewManager.m
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/18.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import "ZXSalaryViewManager.h"
static ZXSalaryViewManager *salaryManager;
@implementation ZXSalaryViewManager
+(id)defaultManager
{
    if (salaryManager == nil) {
        salaryManager = [[ZXSalaryViewManager alloc] init];
    }
    return salaryManager;
}

-(void)requestSalaryListWithUid:(NSString *)uid WithToken:(NSString *)token WithPageNum:(NSInteger)pageNum Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed
{
    NSString *url = [NSString stringWithFormat:@"%@%@",API_BASE,ZX_SalaryList_API];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",[NSNumber numberWithInteger:pageNum],@"page",@"10",@"num", nil];
    [[RFNetWorkManager defaultManager] post:url parameters:para success:success error:error failed:failed];
}

-(void)requestLatestSalaryWithUid:(NSString *)uid WithToken:(NSString *)token Success:(ApiSuccessCallback)success Error:(ApiErrorCallback)error Failed:(ApiFailedCallback)failed
{
    NSString *url = [NSString stringWithFormat:@"%@%@",API_BASE,ZX_LatestSalary_API];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token", nil];
    [[RFNetWorkManager defaultManager] post:url parameters:para success:success error:error failed:failed];
}
@end
