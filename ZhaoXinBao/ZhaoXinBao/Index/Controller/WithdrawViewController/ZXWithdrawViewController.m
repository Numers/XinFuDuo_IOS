//
//  ZXWithdrawViewController.m
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/13.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import "ZXWithdrawViewController.h"
#import "ZXLoginErrorAlertViewController.h"
#import "ZXAppStartManager.h"
#import "ZXWithdrawViewManager.h"
#import "UIImageView+WebCache.h"

@interface ZXWithdrawViewController ()<UITextFieldDelegate,ZXLoginErrorAlertProtocol>
{
    NSString *withdrawStatus;
    NSString *bankName;
    NSString *cardTail;
    NSString *restAmount;
    NSString *restTimes;
    NSString *bankImage;
    
    ZXLoginErrorAlertViewController *zxLoginErrorAlertVC;
}
@property(nonatomic, strong) IBOutlet UIImageView *bankHeadImageView;
@property(nonatomic, strong) IBOutlet UILabel *lblBankName;
@property(nonatomic, strong) IBOutlet UILabel *lblBankCard;
@property(nonatomic, strong) IBOutlet UILabel *lblNotify;

@property(nonatomic, strong) IBOutlet UITextField *txtWithdrawMoney;
@property(nonatomic, strong) IBOutlet UIButton *btnConfirm;
@end

@implementation ZXWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_bankHeadImageView.layer setCornerRadius:_bankHeadImageView.frame.size.width / 2];
    [_bankHeadImageView.layer setMasksToBounds:YES];
    withdrawStatus = @"0";
    [self requestWithdrawInfo];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [self.navigationItem setTitle:@"提现"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidChanged:(NSNotification *)notify
{
    UITextField *textField = [notify object];
    
    if ([withdrawStatus isEqualToString:@"0"]){
        [self.btnConfirm setEnabled:NO];
        [self.btnConfirm setBackgroundColor:[UIColor colorWithWhite:0.918 alpha:1.000]];
        [self.btnConfirm setTitleColor:[UIColor colorWithWhite:0.690 alpha:1.000] forState:UIControlStateNormal];
        return ;
    }
    
    if (![AppUtils isNullStr:textField.text]) {
        if ([AppUtils isValidateNumericalValue:restAmount] && [AppUtils isValidateNumericalValue:textField.text]) {
            CGFloat tempRestAmount = [restAmount floatValue];
            CGFloat inputAmount = [textField.text floatValue];
            if (tempRestAmount < inputAmount) {
                [self.btnConfirm setEnabled:NO];
                [self.btnConfirm setBackgroundColor:[UIColor colorWithWhite:0.918 alpha:1.000]];
                [self.btnConfirm setTitleColor:[UIColor colorWithWhite:0.690 alpha:1.000] forState:UIControlStateNormal];
                return;
            }else{
                [self.btnConfirm setEnabled:YES];
                [self.btnConfirm setBackgroundColor:[UIColor colorWithRed:0.992 green:0.816 blue:0.200 alpha:1.000]];
                [self.btnConfirm setTitleColor:[UIColor colorWithRed:0.031 green:0.169 blue:0.290 alpha:1.000] forState:UIControlStateNormal];
            }
        }else{
            [self.btnConfirm setEnabled:NO];
            [self.btnConfirm setBackgroundColor:[UIColor colorWithWhite:0.918 alpha:1.000]];
            [self.btnConfirm setTitleColor:[UIColor colorWithWhite:0.690 alpha:1.000] forState:UIControlStateNormal];
        }
    }else{
        [self.btnConfirm setEnabled:NO];
        [self.btnConfirm setBackgroundColor:[UIColor colorWithWhite:0.918 alpha:1.000]];
        [self.btnConfirm setTitleColor:[UIColor colorWithWhite:0.690 alpha:1.000] forState:UIControlStateNormal];
    }
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual: self.txtWithdrawMoney]) {
        NSScanner  *scanner  = [NSScanner scannerWithString:string];
        NSCharacterSet *numbers;
        NSRange  pointRange = [textField.text rangeOfString:@"."];
        
        if ( (pointRange.length > 0) && (pointRange.location < range.location  || pointRange.location > range.location + range.length) )
        {
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        }
        else
        {
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        }
        
        if ( [textField.text isEqualToString:@""] && [string isEqualToString:@"."] )
        {
            return NO;
        }
        
        short remain = 2; //默认保留2位小数
        
        NSString *tempStr = [textField.text stringByAppendingString:string];
        NSUInteger strlen = [tempStr length];
        if(pointRange.length > 0 && pointRange.location > 0){ //判断输入框内是否含有“.”。
            if([string isEqualToString:@"."]){ //当输入框内已经含有“.”时，如果再输入“.”则被视为无效。
                return NO;
            }
            if(strlen > 0 && (strlen - pointRange.location) > remain+1){ //当输入框内已经含有“.”，当字符串长度减去小数点前面的字符串长度大于需要要保留的小数点位数，则视当次输入无效。
                return NO;
            }
        }
        
        NSRange zeroRange = [textField.text rangeOfString:@"0"];
        if(zeroRange.length == 1 && zeroRange.location == 0){ //判断输入框第一个字符是否为“0”
            if(![string isEqualToString:@"0"] && ![string isEqualToString:@"."] && [textField.text length] == 1){ //当输入框只有一个字符并且字符为“0”时，再输入不为“0”或者“.”的字符时，则将此输入替换输入框的这唯一字符。
                textField.text = string;
                return NO;
            }else{
                if(pointRange.length == 0 && pointRange.location > 0){ //当输入框第一个字符为“0”时，并且没有“.”字符时，如果当此输入的字符为“0”，则视当此输入无效。
                    if([string isEqualToString:@"0"]){
                        return NO;
                    }
                }
            }
        }
        
        NSString *buffer;
        if ( ![scanner scanCharactersFromSet:numbers intoString:&buffer] && ([string length] != 0) )
        {
            return NO;
        }
        
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.txtWithdrawMoney isFirstResponder]) {
        [self.txtWithdrawMoney resignFirstResponder];
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

-(void)requestWithdrawInfo
{
    Member *host = [[ZXAppStartManager defaultManager] currentHost];
    if (host) {
        [[ZXWithdrawViewManager defaultManager] withdrawInfoWithUid:host.memberId WithToken:host.token Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *resultDic = (NSDictionary *)responseObject;
            if (resultDic) {
                NSDictionary *dataDic = [resultDic objectForKey:@"data"];
                if (dataDic) {
                    withdrawStatus = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"withdrawStatus"]];
                    bankName = [dataDic objectForKey:@"bankName"];
                    cardTail = [dataDic objectForKey:@"cardTail"];
                    restAmount = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"restAmount"]];
                    restTimes = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"restTimes"]];
                    bankImage = [dataDic objectForKey:@"bankIcon"];
                    
                    [self inilizedView];
                }
            }
        } Error:^(AFHTTPRequestOperation *operation, id responseObject) {
            [AppUtils showInfo:[responseObject objectForKey:@"message"]];
        } Failed:^(AFHTTPRequestOperation *operation, NSError *error) {
            [AppUtils showInfo:@"网络连接失败"];
        }];
    }
}

-(void)withdrawMonyWithAmount:(NSNumber *)amount
{
    Member *host = [[ZXAppStartManager defaultManager] currentHost];
    if (host) {
        [AppUtils showProgressBarForView:self.view];
        [[ZXWithdrawViewManager defaultManager] withdrawMoneyWithUid:host.memberId WithToken:host.token Amount:amount Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [AppUtils showInfo:@"申请成功"];
            [AppUtils hideProgressBarForView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        } Error:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self showAlertViewWithTitle:nil WithDetails:[responseObject objectForKey:@"message"]];
            [AppUtils hideProgressBarForView:self.view];
        } Failed:^(AFHTTPRequestOperation *operation, NSError *error) {
            [AppUtils showInfo:@"网络连接失败"];
            [AppUtils hideProgressBarForView:self.view];
        }];
    }
}

-(NSMutableAttributedString *)generateAttriuteStringWithStr:(NSString *)str WithColor:(UIColor *)color WithFont:(UIFont *)font
{
    if (str == nil) {
        return nil;
    }
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range;
    range.location = 0;
    range.length = attrString.length;
    [attrString beginEditing];
    [attrString addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:color,NSForegroundColorAttributeName,font,NSFontAttributeName, nil] range:range];
    [attrString endEditing];
    return attrString;
}

-(void)inilizedView
{
    if (bankName) {
        [self.lblBankName setText:bankName];
    }
    
    if (cardTail) {
        [self.lblBankCard setText:[NSString stringWithFormat:@"尾号%@储蓄卡",cardTail]];
    }
    
    if (bankImage) {
        [self.bankHeadImageView sd_setImageWithURL:[NSURL URLWithString:bankImage] placeholderImage:[UIImage imageNamed:@"BankHeadImage_Withdraw"]];
    }
    
    if (restAmount && restTimes) {
        NSMutableAttributedString *str = [self generateAttriuteStringWithStr:@"本次最多可提取" WithColor:[UIColor colorWithWhite:0.600 alpha:1.000] WithFont:[UIFont systemFontOfSize:10.0f]];
        NSMutableAttributedString *amount = [self generateAttriuteStringWithStr:restAmount WithColor:[UIColor colorWithRed:1.000 green:0.400 blue:0.000 alpha:1.000] WithFont:[UIFont systemFontOfSize:10.0f]];
        NSMutableAttributedString *lastStr = [self generateAttriuteStringWithStr:[NSString stringWithFormat:@"元,今天还可转出%@次",restTimes] WithColor:[UIColor colorWithWhite:0.600 alpha:1.000]  WithFont:[UIFont systemFontOfSize:10.0f]];
        [str appendAttributedString:amount];
        [str appendAttributedString:lastStr];
        [self.lblNotify setAttributedText:str];
    }
}

-(IBAction)clickConfirmBtn:(id)sender
{
    if ([withdrawStatus isEqualToString:@"0"]) {
        [self showAlertViewWithTitle:nil WithDetails:@"今天您已不可提取，请明天再试"];
    }else{
        @try {
            if ([AppUtils isValidateNumericalValue:self.txtWithdrawMoney.text]) {
                NSNumber *amount = [NSNumber numberWithFloat:[self.txtWithdrawMoney.text floatValue]];
                if ([amount floatValue] > 0.0f) {
                    [self withdrawMonyWithAmount:amount];
                }else{
                    [self showAlertViewWithTitle:nil WithDetails:@"请输入大于0的金额"];
                }
            }else{
                [self showAlertViewWithTitle:nil WithDetails:@"请输入有效的金额数字"];
            }
        }
        @catch (NSException *exception) {
            [self showAlertViewWithTitle:nil WithDetails:@"您输入金额有误"];
        }
        @finally {
            
        }
    }
}

#pragma -mark ZXLoginErrorAlertProtocol
-(void)closeAlertView
{
    zxLoginErrorAlertVC = nil;
}
@end
