//
//  ZXLoginErrorAlertViewController.m
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/24.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import "ZXLoginErrorAlertViewController.h"

@interface ZXLoginErrorAlertViewController ()
{
    NSString *titleText;
    NSString *detailText;
    
    BOOL isShow;
}
@property(nonatomic, strong) IBOutlet UIView *backGroundView;
@property(nonatomic, strong) IBOutlet UILabel *lblTitle;
@property(nonatomic, strong) IBOutlet UILabel *lblDetails;
@property(nonatomic, strong) IBOutlet UIButton *btnComfirm;
@end

@implementation ZXLoginErrorAlertViewController
-(id)initWithTitle:(NSString *)title DetailDescription:(NSString *)description
{
    self = [super init];
    if (self) {
        titleText = title;
        detailText = description;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.backGroundView.layer setCornerRadius:5.0f];
    [self.backGroundView.layer setMasksToBounds:YES];
    
    [self.btnComfirm.layer setCornerRadius:19.0f];
    [self.btnComfirm.layer setMasksToBounds:YES];
    
    if (titleText) {
        [self.lblTitle setText:titleText];
    }else{
        [self.lblTitle setText:@"提示"];
    }
    
    if (detailText) {
        [self.lblDetails setText:detailText];
    }else{
        [self.lblDetails setText:@""];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)isShow
{
    return isShow;
}

-(void)show
{
    isShow = YES;
    self.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    [self.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
//    self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.view.layer addAnimation:popAnimation forKey:nil];
}

-(void)hidden
{
    CAKeyframeAnimation *hideAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    hideAnimation.duration = 0.4;
    hideAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.00f, 0.00f, 1.0f)]];
    hideAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f];
    hideAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.view.layer addAnimation:hideAnimation forKey:nil];
    [self performSelector:@selector(animationDidStop:finished:) withObject:nil afterDelay:0.3];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.view setHidden:YES];
    if([self.delegate respondsToSelector:@selector(closeAlertView)])
    {
        [self.delegate closeAlertView];
    }
    [self.view removeFromSuperview];
    isShow = NO;
}


-(IBAction)clickCloseBtn:(id)sender
{
    [self hidden];
}

-(IBAction)clickComfirmBtn:(id)sender
{
    [self hidden];
}
@end
