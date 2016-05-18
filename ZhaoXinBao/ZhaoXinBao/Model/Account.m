//
//  Account.m
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/16.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import "Account.h"
static NSString *accountInfoKey = @"AccountInfoKey";
@implementation Account
-(void)saveAccountInfoWithMemberId:(NSString *)memberId
{
    [AppUtils localUserDefaultsValue:[self dictionaryInfo] forKey:[NSString stringWithFormat:@"%@_%@",accountInfoKey,memberId]];
}

-(NSDictionary *)dictionaryInfo
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.balance],@"banlance",[NSNumber numberWithFloat:self.lastProfit],@"lastProfit",[NSNumber numberWithFloat:self.allProfit],@"allProfit", nil];
    return dic;
}

+(Account *)accountFromLocalDataWithMemberId:(NSString *)memberId
{
    Account *account = nil;
    NSDictionary *dic = [AppUtils localUserDefaultsForKey:[NSString stringWithFormat:@"%@_%@",accountInfoKey,memberId]];
    if (dic) {
        account = [[Account alloc] init];
        account.balance = [[dic objectForKey:@"banlance"] floatValue];
        account.lastProfit  = [[dic objectForKey:@"lastProfit"] floatValue];
        account.allProfit = [[dic objectForKey:@"allProfit"] floatValue];
    }
    return account;
}
@end
