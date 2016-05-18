//
//  Salary.m
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/18.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import "Salary.h"

@implementation Salary
-(id)initWithDictionary:(NSDictionary *)dic
{
    Salary *salary = nil;
    if (dic) {
        salary = [[Salary alloc] init];
        salary.date = [NSString stringWithFormat:@"%@",[dic objectForKey:@"date"]];
        salary.salary = [NSString stringWithFormat:@"%@",[dic objectForKey:@"salary"]];
        salary.tax = [NSString stringWithFormat:@"%@",[dic objectForKey:@"tax"]];
        salary.actual = [NSString stringWithFormat:@"%@",[dic objectForKey:@"actual"]];
    }
    return salary;
}
@end
