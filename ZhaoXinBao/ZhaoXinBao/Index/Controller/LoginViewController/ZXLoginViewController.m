//
//  ZXLoginViewController.m
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/12.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import "ZXLoginViewController.h"
#import "ZXLoginErrorAlertViewController.h"
#import "ZXLoginViewAPIManager.h"
#import "Member.h"
#import "ZXAppStartManager.h"

@interface ZXLoginViewController ()<UITextFieldDelegate,ZXLoginErrorAlertProtocol>
{
    NSTimer *timer;
    NSInteger seconds;
    ZXLoginErrorAlertViewController *zxLoginErrorAlertVC;
}
@property (strong, nonatomic) IBOutlet UITextField *txtMobile;
@property (strong, nonatomic) IBOutlet UITextField *txtValidateCode;
@property (strong, nonatomic) IBOutlet UIButton *btnValidateCode;
@end

@implementation ZXLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_btnValidateCode.layer setCornerRadius:10.0f];
    [_btnValidateCode.layer setMasksToBounds:YES];
    
    NSAttributedString *mobilePlaceholder = [[NSAttributedString alloc] initWithString:@"输入手机号" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    [_txtMobile setAttributedPlaceholder:mobilePlaceholder];
    
    NSAttributedString *validateCodePlaceholder = [[NSAttributedString alloc] initWithString:@"输入验证码" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    [_txtValidateCode setAttributedPlaceholder:validateCodePlaceholder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([_txtMobile isFirstResponder]) {
        [_txtMobile resignFirstResponder];
    }
    
    if ([_txtValidateCode isFirstResponder]) {
        [_txtValidateCode resignFirstResponder];
    }
}

-(void)showAlertViewWithTitle:(NSString *)title WithDetails:(NSString *)details
{
    if (zxLoginErrorAlertVC) {
        if ([zxLoginErrorAlertVC isShow]) {
            return;
        }
        [zxLoginErrorAlertVC.view removeFromSuperview];
        zxLoginErrorAlertVC = nil;
    }
    
    zxLoginErrorAlertVC = [[ZXLoginErrorAlertViewController alloc] initWithTitle:title DetailDescription:details];
    zxLoginErrorAlertVC.delegate = self;
    [zxLoginErrorAlertVC show];
}

-(BOOL)isValidateInput
{
    if ([AppUtils isNullStr:_txtMobile.text]) {
        [self showAlertViewWithTitle:nil WithDetails:@"手机号不能为空"];
        return NO;
    }
    
    if (![AppUtils isMobileNumber:_txtMobile.text]) {
        [self showAlertViewWithTitle:nil WithDetails:@"手机号不合法"];
        return NO;
    }
    
    if ([AppUtils isNullStr:_txtValidateCode.text]) {
        [self showAlertViewWithTitle:nil WithDetails:@"验证码不能为空"];
        return NO;
    }
    
    return YES;
}

-(void)loginWithPhone:(NSString *)phone WithCode:(NSString *)code
{
    [[ZXLoginViewAPIManager defaultManager] loginWithPhone:phone WithCode:code Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if (resultDic) {
            NSDictionary *dataDic = [resultDic objectForKey:@"data"];
            if (dataDic) {
                Member *member = [[Member alloc] init];
                member.memberId = [dataDic objectForKey:@"uid"];
                member.token = [dataDic objectForKey:@"token"];
                member.name = [dataDic objectForKey:@"name"];
                member.identifyCode = nil;
                member.mobilePhone = phone;
                
                [[ZXAppStartManager defaultManager] setHostMember:member];
                [AppUtils localUserDefaultsValue:@"1" forKey:KMY_AutoLogin];
                if([self.delegate respondsToSelector:@selector(loginSuccess)])
                {
                    [self.delegate loginSuccess];
                }
            }
        }
    } Error:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self showAlertViewWithTitle:nil WithDetails:[responseObject objectForKey:@"message"]];
    } Failed:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showInfo:@"网络连接失败"];
    }];
}

-(void)sendPhoneCodeWithTel:(NSString *)tel
{
    [_btnValidateCode setEnabled:NO];
    [[ZXLoginViewAPIManager defaultManager] requestValidateCodeWithPhone:tel Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        seconds = 60;
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(validateBtnSetting) userInfo:nil repeats:YES];
        [timer fire];
    } Error:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self showAlertViewWithTitle:nil WithDetails:[responseObject objectForKey:@"message"]];
        [_btnValidateCode setEnabled:YES];
    } Failed:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showInfo:@"网络连接失败"];
        [_btnValidateCode setEnabled:YES];
    }];
}

-(void)validateBtnSetting
{
    --seconds;
    if (seconds>0) {
        [_btnValidateCode setTitle:[NSString stringWithFormat:@"还剩(%ld)秒",(long)seconds] forState:UIControlStateNormal];
        [_btnValidateCode setEnabled:NO];
    }else{
        [timer invalidate];
        timer = nil;
        [_btnValidateCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_btnValidateCode setEnabled:YES];
    }
}

- (IBAction)clickValidateCodeBtn:(id)sender {
    if([AppUtils isNullStr:_txtMobile.text]){
        [self showAlertViewWithTitle:nil WithDetails:@"手机号不能为空"];
    }else{
        if ([AppUtils isMobileNumber:_txtMobile.text]) {
            [self sendPhoneCodeWithTel:_txtMobile.text];
        }else{
            [self showAlertViewWithTitle:nil WithDetails:@"手机号不合法"];
        }
    }
}

-(IBAction)clickLoginBtn:(id)sender
{
    if ([self isValidateInput]) {
        [self loginWithPhone:_txtMobile.text WithCode:_txtValidateCode.text];
    }
}

#pragma -mark ZXLoginErrorAlertProtocol
-(void)closeAlertView
{
    zxLoginErrorAlertVC = nil;
}
@end
