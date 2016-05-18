//
//  UINavigationController+PHNavigationController.m
//  PocketHealth
//
//  Created by macmini on 15-1-24.
//  Copyright (c) 2015年 YiLiao. All rights reserved.
//

#import "UINavigationController+PHNavigationController.h"

@implementation UINavigationController (PHNavigationController)
-(void)setHomeNavigationView
{
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavgationBackGroundImage"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:0.078 green:0.741 blue:0.937 alpha:1.0f]] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.translucent = NO;
    [self setNavigationBarHidden:NO];
    self.navigationBar.hidden = NO;
    [self setStatusBarStyle:UIStatusBarStyleLightContent];
    iPhoneModel model = [UIDevice iPhonesModel];
    UIFont *font;
    if (model == iPhone6Plus) {
        font = [UIFont systemFontOfSize:22.0f];
    }else{
        font = [UIFont systemFontOfSize:18.0f];
    }
    [self setTitleTextColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.f] WithFont:font];
}

-(UIImage*) imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)setTranslucentView
{
    [self.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;
    [self setTitleTextColor:[UIColor whiteColor] WithFont:[UIFont systemFontOfSize:18.0f]];
    self.navigationBar.tintColor = [UIColor whiteColor];
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

-(void)setTitleTextColor:(UIColor *)color WithFont:(UIFont *)font
{
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :color,NSFontAttributeName:font}];
}

-(void)setStatusBarStyle:(UIStatusBarStyle)style
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarStyle:style animated:NO];
}
@end
