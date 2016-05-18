//
//  Member.m
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/12.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import "Member.h"

@implementation Member
-(Member *)initlizedWithDictionary:(NSDictionary *)dic
{
    Member *member = nil;
    if (dic) {
        member = [[Member alloc] init];
        member.memberId = [dic objectForKey:@"uid"];
        member.token = [dic objectForKey:@"token"];
        member.identifyCode = [dic objectForKey:@"identifyCode"];
        member.mobilePhone = [dic objectForKey:@"mobilePhone"];
    }
    return member;
} 

-(NSDictionary *)dictionaryInfo
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (_memberId) {
        [dic setObject:_memberId forKey:@"uid"];
    }
    
    if (_token) {
        [dic setObject:_token forKey:@"token"];
    }
    
    if (_name) {
        [dic setObject:_token forKey:@"name"];
    }
    
    if (_identifyCode) {
        [dic setObject:_identifyCode forKey:@"identifyCode"];
    }
    
    if (_mobilePhone) {
        [dic setObject:_mobilePhone forKey:@"mobilePhone"];
    }
    
    return [NSDictionary dictionaryWithDictionary:dic];
}
@end
