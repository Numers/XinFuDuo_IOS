//
//  Salary.h
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/18.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Salary : NSObject
@property(nonatomic, copy) NSString *date;
@property(nonatomic, copy) NSString *salary;
@property(nonatomic, copy) NSString *tax;
@property(nonatomic, copy) NSString *actual;

-(id)initWithDictionary:(NSDictionary *)dic;
@end
