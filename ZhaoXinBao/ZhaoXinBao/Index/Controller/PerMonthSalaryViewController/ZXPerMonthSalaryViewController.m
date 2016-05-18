//
//  ZXPerMonthSalaryViewController.m
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/18.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import "ZXPerMonthSalaryViewController.h"
#import "ZXSalaryListViewController.h"
#import "Salary.h"
#import "ZXSalaryViewManager.h"
#import "ZXAppStartManager.h"

@interface ZXPerMonthSalaryViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *identifyArray;
    Salary *currentSalary;
    BOOL isLatest;
}
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) IBOutlet UIImageView *noRecordImageView;
@property(nonatomic, strong) IBOutlet UILabel *lblNoRecord;
@end

@implementation ZXPerMonthSalaryViewController
-(id)initWithSalary:(Salary *)salary IsLatest:(BOOL)latest
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:@"PerMonthSalaryViewIdentify"];
    if (self) {
        currentSalary = salary;
        isLatest = latest;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    identifyArray = @[@"HeadCellIdentify",@"PreTaxCellIdentify",@"PayableCellIdentify",@"AfterTaxCellIdentify"];
    
    [self.tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    [self.tableView setTableFooterView:[UIView new]];
    
    if (isLatest) {
        [self requestLatestSalary];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (isLatest) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"工资记录" style:UIBarButtonItemStylePlain target:self action:@selector(clickSalaryListItem)];
        [UIDevice adaptUIBarButtonItemTextFont:rightItem WithIphone5FontSize:15.0f];
        [self.navigationItem setRightBarButtonItem:rightItem];
    }
    [self.navigationItem setTitle:@"工资"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickSalaryListItem
{
    ZXSalaryListViewController *zxSalaryListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SalaryListViewIdentify"];
    [self.navigationController pushViewController:zxSalaryListVC animated:YES];
}

-(void)setSubViewHiddenStatus:(BOOL)status
{
    if (status) {
        [self.tableView setHidden:NO];
        [self.lblNoRecord setHidden:YES];
        [self.noRecordImageView setHidden:YES];
    }else{
        [self.tableView setHidden:YES];
        [self.lblNoRecord setHidden:NO];
        [self.noRecordImageView setHidden:NO];
    }
}

-(void)requestLatestSalary
{
    Member *host = [[ZXAppStartManager defaultManager] currentHost];
    if (host) {
        [AppUtils showProgressBarForView:self.view];
        [[ZXSalaryViewManager defaultManager] requestLatestSalaryWithUid:host.memberId WithToken:host.token Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [AppUtils hideProgressBarForView:self.view];
            NSDictionary *resultDic = (NSDictionary *)responseObject;
            if (resultDic) {
                NSDictionary *dataDic = [resultDic objectForKey:@"data"];
                if (dataDic) {
                    NSInteger hasLastSalary = [[dataDic objectForKey:@"hasLastSalary"] integerValue];
                    if (hasLastSalary == 0) {
                        [self setSubViewHiddenStatus:NO];
                    }else if (hasLastSalary == 1){
                        NSDictionary *salaryDetails = [dataDic objectForKey:@"salaryDetail"];
                        currentSalary = [[Salary alloc] initWithDictionary:salaryDetails];
                        [self setSubViewHiddenStatus:YES];
                        [self.tableView reloadData];
                    }
                }
            }
        } Error:^(AFHTTPRequestOperation *operation, id responseObject) {
            [AppUtils showInfo:[responseObject objectForKey:@"message"]];
            [AppUtils hideProgressBarForView:self.view];
        } Failed:^(AFHTTPRequestOperation *operation, NSError *error) {
            [AppUtils showInfo:@"网络连接失败"];
            [AppUtils hideProgressBarForView:self.view];
        }];
    }
}

#pragma -mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.1f;
    switch (indexPath.row) {
        case 0:
            height = 112.0f;
            break;
        case 1:
            height = 56.0f;
            break;
        case 2:
            height = 56.0f;
            break;
        case 3:
            height = 56.0f;
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
    if (!currentSalary) {
        return 0;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentify = [identifyArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
        {
            UILabel *lblLatestNotify = (UILabel *)[cell viewWithTag:1];
            UILabel *lblSalary = (UILabel *)[cell viewWithTag:2];
            UILabel *lblDate = (UILabel *)[cell viewWithTag:3];
            [lblDate.layer setCornerRadius:8.0f];
            [lblDate.layer setMasksToBounds:YES];
            if(currentSalary){
                if (isLatest) {
                    [lblLatestNotify setHidden:NO];
                }else{
                    [lblLatestNotify setHidden:YES];
                }
                [lblSalary setHidden:NO];
                [lblDate setHidden:NO];
                
                [lblSalary setText:currentSalary.actual];
                [lblDate setText:[NSString stringWithFormat:@"发放日:%@",currentSalary.date]];
            }else{
                [lblLatestNotify setHidden:YES];
                [lblSalary setHidden:YES];
                [lblDate setHidden:YES];
            }
        }
            break;
        case 1:
        {
            UILabel *lblPreTax = (UILabel *)[cell viewWithTag:2];
            [lblPreTax setText:currentSalary.salary];
        }
            break;
        case 2:
        {
            UILabel *lblTax = (UILabel *)[cell viewWithTag:2];
            [lblTax setText:currentSalary.tax];
        }
            break;
        case 3:
        {
            UILabel *lblActual = (UILabel *)[cell viewWithTag:2];
            [lblActual setText:currentSalary.actual];
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
