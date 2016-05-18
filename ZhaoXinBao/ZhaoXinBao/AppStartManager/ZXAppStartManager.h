//
//  ZXAppStartManager.h
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/12.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Member.h"
#import "ZXHomeViewController.h"

@interface ZXAppStartManager : NSObject
{
    Member *host;
    ZXHomeViewController *zxHomeVC;
}

@property(nonatomic, strong) UINavigationController *navigationController;

+(id)defaultManager;
-(id)returnHomeViewController;
-(Member *)currentHost;
-(void)setHostMember:(Member *)member;

-(void)startApp;
-(void)loginOut;
@end
