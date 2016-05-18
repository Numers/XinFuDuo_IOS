//
//  ZXPerMonthSalaryViewController.h
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/18.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Salary;
@interface ZXPerMonthSalaryViewController : UIViewController
-(id)initWithSalary:(Salary *)salary IsLatest:(BOOL)latest;
@end
