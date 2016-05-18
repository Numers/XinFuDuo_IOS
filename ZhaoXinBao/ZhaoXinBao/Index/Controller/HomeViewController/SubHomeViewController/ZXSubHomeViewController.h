//
//  ZXSubHomeViewController.h
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/12.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Account;
@interface ZXSubHomeViewController : UIViewController
-(void)setLastestRatesWithXAxisData:(NSArray *)xAxisData WithYAxisValue:(NSArray *)yAxisValue;
-(void)setAccout:(Account *)account;
@end
