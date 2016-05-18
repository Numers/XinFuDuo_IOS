//
//  ZXLoginViewController.h
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/12.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZXLoginViewProtocol <NSObject>
-(void)loginSuccess;
@end
@interface ZXLoginViewController : UIViewController
@property(nonatomic, assign) id<ZXLoginViewProtocol> delegate;
@end
