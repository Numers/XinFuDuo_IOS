//
//  ZXPersonalViewController.m
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/13.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import "ZXPersonalViewController.h"
#import "ZXPersonalViewManager.h"
#import "ZXAppStartManager.h"
static NSString *personalInfoKey = @"personalInfoKey";
@interface ZXPersonalViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *cellIdentifyArray;
    
    NSString *name;
    NSString *phone;
    NSString *identifyCode;
    NSString *bankCard;
    NSString *companyName;
    
    BOOL isRequestSuccess;
}
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@end

@implementation ZXPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    cellIdentifyArray = @[@"HeadCellIdentify",@"IdentifyCodeCellIdentify",@"BankCardNumberCellIdentify",@"CompanyCellIdentify"];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    [self.tableView setTableFooterView:[UIView new]];
    
    isRequestSuccess = NO;
    [self requestPersonalInfo];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"我的"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestPersonalInfo
{
    Member *host = [[ZXAppStartManager defaultManager] currentHost];
    if (host) {
        [AppUtils showProgressBarForView:self.view];
        [[ZXPersonalViewManager defaultManager] requestPersonalInfoWithUid:host.memberId WithToken:host.token Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [AppUtils hideProgressBarForView:self.view];
            NSDictionary *resultDic = (NSDictionary *)responseObject;
            if (resultDic) {
                NSDictionary *dataDic = [resultDic objectForKey:@"data"];
                if (dataDic) {
                    [self doWithPersonalInfoDic:dataDic];
                    [self savePersonalInfoDictionary:dataDic WithMemberId:host.memberId];
                }
            }
        } Error:^(AFHTTPRequestOperation *operation, id responseObject) {
            [AppUtils showInfo:[responseObject objectForKey:@"message"]];
            [AppUtils hideProgressBarForView:self.view];
            NSDictionary *dataDic = [AppUtils localUserDefaultsForKey:[NSString stringWithFormat:@"%@_%@",personalInfoKey,host.memberId]];
            [self doWithPersonalInfoDic:dataDic];
        } Failed:^(AFHTTPRequestOperation *operation, NSError *error) {
            [AppUtils showInfo:@"网络连接失败"];
            [AppUtils hideProgressBarForView:self.view];
            NSDictionary *dataDic = [AppUtils localUserDefaultsForKey:[NSString stringWithFormat:@"%@_%@",personalInfoKey,host.memberId]];
            [self doWithPersonalInfoDic:dataDic];
        }];
    }
}

-(void)doWithPersonalInfoDic:(NSDictionary *)dataDic
{
    if (!dataDic) {
        return;
    }
    isRequestSuccess = YES;
    name = [dataDic objectForKey:@"truename"];
    phone = [dataDic objectForKey:@"phone"];
    identifyCode = [dataDic objectForKey:@"identity"];
    bankCard = [dataDic objectForKey:@"card"];
    companyName = [dataDic objectForKey:@"company"];
    [self.tableView reloadData];
}

-(void)savePersonalInfoDictionary:(NSDictionary *)dataDic WithMemberId:(NSString *)memberId
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *key in [dataDic allKeys]) {
        NSString *tempValue = [dataDic objectForKey:key];
        if (![AppUtils isNullStr:tempValue]) {
            [dic setObject:tempValue forKey:key];
        }
    }
    [AppUtils localUserDefaultsValue:dic forKey:[NSString stringWithFormat:@"%@_%@",personalInfoKey,memberId]];
}

-(IBAction)clickLoginOutBtn:(id)sender
{
    Member *host = [[ZXAppStartManager defaultManager] currentHost];
    if (host) {
        [AppUtils showProgressBarForView:self.view];
        [[ZXPersonalViewManager defaultManager] loginOutWithWithUid:host.memberId WithToken:host.token Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [AppUtils hideProgressBarForView:self.view];
            [[ZXAppStartManager defaultManager] loginOut];
        } Error:^(AFHTTPRequestOperation *operation, id responseObject) {
            [AppUtils hideProgressBarForView:self.view];
            [AppUtils showInfo:[responseObject objectForKey:@"message"]];
            [[ZXAppStartManager defaultManager] loginOut];
        } Failed:^(AFHTTPRequestOperation *operation, NSError *error) {
            [AppUtils hideProgressBarForView:self.view];
            [AppUtils showInfo:@"网络连接失败"];
            [[ZXAppStartManager defaultManager] loginOut];
        }];
    }
}
#pragma -mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.1f;
    switch (indexPath.row) {
        case 0:
            height = 121.0f;
            break;
        case 1:
            height = 44.0f;
            break;
        case 2:
            height = 44.0f;
            break;
        case 3:
            height = 44.0f;
            break;
        default:
            break;
    }
    return height;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15.0f, 0, 15.0f)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15.0f, 0, 15.0f)];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowNumber = 0;
    if (isRequestSuccess) {
        rowNumber = 4;
    }
    return rowNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentify = [cellIdentifyArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
        {
            UILabel *lblName = (UILabel *)[cell viewWithTag:1];
            [lblName setText:name];
            
            UILabel *lblPhone = (UILabel *)[cell viewWithTag:2];
            [lblPhone setText:phone];
        }
            break;
        case 1:
        {
            UILabel *lblIdentifyCode = (UILabel *)[cell viewWithTag:1];
            [lblIdentifyCode setText:identifyCode];
        }
            break;
        case 2:
        {
            UILabel *lblBankCard = (UILabel *)[cell viewWithTag:1];
            [lblBankCard setText:bankCard];
        }
            break;
        case 3:
        {
            UILabel *lblCompany = (UILabel *)[cell viewWithTag:1];
            [lblCompany setText:companyName];
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end
