//
//  ZXLoginErrorAlertViewController.h
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/24.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZXLoginErrorAlertProtocol <NSObject>
-(void)closeAlertView;
@end
@interface ZXLoginErrorAlertViewController : UIViewController
@property(nonatomic, assign) id<ZXLoginErrorAlertProtocol> delegate;
-(id)initWithTitle:(NSString *)title DetailDescription:(NSString *)description;
-(void)show;
-(BOOL)isShow;
@end
