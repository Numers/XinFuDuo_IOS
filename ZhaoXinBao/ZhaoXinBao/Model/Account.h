//
//  Account.h
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/16.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject
@property(nonatomic) CGFloat balance;
@property(nonatomic) CGFloat lastProfit;
@property(nonatomic) CGFloat allProfit;

-(void)saveAccountInfoWithMemberId:(NSString *)memberId;
+(Account *)accountFromLocalDataWithMemberId:(NSString *)memberId;
@end
