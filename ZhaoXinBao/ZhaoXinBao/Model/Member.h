//
//  Member.h
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/12.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Member : NSObject
@property(nonatomic, copy) NSString *memberId;
@property(nonatomic, copy) NSString *token;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *identifyCode;
@property(nonatomic, copy) NSString *mobilePhone;

-(Member *)initlizedWithDictionary:(NSDictionary *)dic;
-(NSDictionary *)dictionaryInfo;
@end
