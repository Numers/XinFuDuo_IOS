//
//  ZXHomeViewController.m
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/12.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import "ZXHomeViewController.h"
#import "UINavigationController+PHNavigationController.h"
#import "ZXSubHomeViewController.h"
#import "ZXPersonalViewController.h"
#import "ZXWithdrawViewController.h"
#import "ZXAccountDetailsViewController.h"
#import "ZXPerMonthSalaryViewController.h"

#import "Account.h"
#import "ZXHomeViewManager.h"
#import "ZXAppStartManager.h"
#import "MobClick.h"
#import "UMCheckUpdate.h"
#import "ThirdPartToolsMacros.h"
static NSString *xaxisYearRateKey = @"xaxisYearRateKey";
static NSString *yaxisYearRateKey = @"yaxisYearRateKey";
@interface ZXHomeViewController ()<UIScrollViewDelegate>
{
    ZXSubHomeViewController *zxSubHomeVC;
    
    NSDictionary *updateResult;
}
@property(nonatomic, strong)  UIScrollView *scrollView;

@property(nonatomic, strong) IBOutlet UILabel *lblAccountDetails;
@property(nonatomic, strong) IBOutlet UILabel *lblWithdraw;
@end

@implementation ZXHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 60 - 64 - 0.5)];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    zxSubHomeVC = [[ZXSubHomeViewController alloc] init];
    [zxSubHomeVC.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.scrollView.frame.size.height)];
    [self.scrollView addSubview:zxSubHomeVC.view];
    [self.scrollView setContentSize:zxSubHomeVC.view.frame.size];
    
    [self adaptFontSize];
    
    //更新App
    [MobClick updateOnlineConfig];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setHomeNavigationView];
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LeftNavBarItemImage_Home"] style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBarItem)];
    [self.navigationItem setLeftBarButtonItem:leftBarItem];
    
    UIBarButtonItem *rightBarItem1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"RigheNavBarItemImage_Home"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBarItem)];
    [rightBarItem1 setImageInsets:UIEdgeInsetsMake(3, 0, 0, 0)];
    UIBarButtonItem *rightBarItem2 = [[UIBarButtonItem alloc] initWithTitle:@"工资" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBarItem)];
    [UIDevice adaptUIBarButtonItemTextFont:rightBarItem2 WithIphone5FontSize:15.0f];
    [self.navigationItem setRightBarButtonItems:@[rightBarItem1,rightBarItem2]];
    
    [self requestAccountAndRates];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)adaptFontSize
{
    [UIDevice adaptUILabelTextFont:_lblAccountDetails WithIphone5FontSize:14.0f];
    [UIDevice adaptUILabelTextFont:_lblWithdraw WithIphone5FontSize:14.0f];
}

- (void)onlineConfigCallBack:(NSNotification *)notification {
    if ([[[MobClick getConfigParams:@"isForceUpdate"] uppercaseString] isEqualToString:@"YES"]) {
        [UMCheckUpdate checkUpdateWithDelegate:self selector:@selector(appUpdate:) appkey:UMENG_KEY channel:nil];
    }
    else
    {
        [UMCheckUpdate checkUpdateWithAppkey:UMENG_KEY channel:nil];
    }
}

- (void)appUpdate:(NSDictionary *)result
{
    updateResult = result;
    if ([[result objectForKey:@"update"] isEqualToString:@"YES"]) {
        NSString* verTitle = [NSString stringWithFormat:@"有可用的新版本%@", [result objectForKey:@"version"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:verTitle message:[result objectForKey:@"update_log"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"去AppStore升级",nil];
        [alert show];
    }
}

-(void)requestAccountAndRates
{
    Member *host = [[ZXAppStartManager defaultManager] currentHost];
    if (host != nil) {
        [[ZXHomeViewManager defaultManager] requestAccountAndRateWithUid:host.memberId WithToken:host.token Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *resultDic = (NSDictionary *)responseObject;
            if (resultDic) {
                NSDictionary *dataDic = [resultDic objectForKey:@"data"];
                if (dataDic) {
                    Account *account = [[Account alloc] init];
                    account.balance = [[dataDic objectForKey:@"accountBalance"] floatValue];
                    account.lastProfit = [[dataDic objectForKey:@"yesterdayIncome"] floatValue];
                    account.allProfit = [[dataDic objectForKey:@"accumulatedIncome"] floatValue];
                    [zxSubHomeVC setAccout:account];
                    [account saveAccountInfoWithMemberId:host.memberId];
                    
                    NSMutableArray *xAxisData = [NSMutableArray array];
                    NSMutableArray *yXisValue = [NSMutableArray array];
                    NSArray *rateArr = [dataDic objectForKey:@"yieldRate"];
                    for (NSDictionary *dic in rateArr) {
                        NSString *date = [dic objectForKey:@"time"];
                        [xAxisData addObject:date];
                        NSString *value = [dic objectForKey:@"value"];
                        [yXisValue addObject:value];
                    }
                    [zxSubHomeVC performSelector:@selector(setLastestRatesWithXAxisData:WithYAxisValue:) withObject:xAxisData withObject:yXisValue];
//                    [zxSubHomeVC setLastestRatesWithXAxisData:xAxisData WithYAxisValue:yXisValue];
                    [AppUtils localUserDefaultsValue:xAxisData forKey:[NSString stringWithFormat:@"%@_%@",xaxisYearRateKey,host.memberId]];
                    [AppUtils localUserDefaultsValue:yXisValue forKey:[NSString stringWithFormat:@"%@_%@",yaxisYearRateKey,host.memberId]];
                }
            }
        } Error:^(AFHTTPRequestOperation *operation, id responseObject) {
            [AppUtils showInfo:[responseObject objectForKey:@"message"]];
            Account *account = [Account accountFromLocalDataWithMemberId:host.memberId];
            [zxSubHomeVC setAccout:account];
            
            NSArray *xAxisDataCache = [AppUtils localUserDefaultsForKey:[NSString stringWithFormat:@"%@_%@",xaxisYearRateKey,host.memberId]];
            NSArray *yAxisDataCache = [AppUtils localUserDefaultsForKey:[NSString stringWithFormat:@"%@_%@",yaxisYearRateKey,host.memberId]];
            [zxSubHomeVC setLastestRatesWithXAxisData:xAxisDataCache WithYAxisValue:yAxisDataCache];
        } Failed:^(AFHTTPRequestOperation *operation, NSError *error) {
            [AppUtils showInfo:@"网络连接失败"];
            Account *account = [Account accountFromLocalDataWithMemberId:host.memberId];
            [zxSubHomeVC setAccout:account];
            
            NSArray *xAxisDataCache = [AppUtils localUserDefaultsForKey:[NSString stringWithFormat:@"%@_%@",xaxisYearRateKey,host.memberId]];
            NSArray *yAxisDataCache = [AppUtils localUserDefaultsForKey:[NSString stringWithFormat:@"%@_%@",yaxisYearRateKey,host.memberId]];
            [zxSubHomeVC setLastestRatesWithXAxisData:xAxisDataCache WithYAxisValue:yAxisDataCache];
        }];
    }
}

-(void)clickLeftBarItem
{
    ZXPersonalViewController *zxPersonalVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonalViewIdentify"];
    [self.navigationController pushViewController:zxPersonalVC animated:YES];
}

-(void)clickRightBarItem
{
    ZXPerMonthSalaryViewController *zxPerMonthSalaryVC = [[ZXPerMonthSalaryViewController alloc] initWithSalary:nil IsLatest:YES];
    [self.navigationController pushViewController:zxPerMonthSalaryVC animated:YES];
}

-(IBAction)clickBillDetailBtn:(id)sender
{
    ZXAccountDetailsViewController *zxAccountDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountDetailsViewIdentify"];
    [self.navigationController pushViewController:zxAccountDetailsVC animated:YES];
}

-(IBAction)clickWithdrawBtn:(id)sender
{
    ZXWithdrawViewController *zxWithdrawVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WithdrawViewIdentify"];
    [self.navigationController pushViewController:zxWithdrawVC animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    [UMCheckUpdate checkUpdateWithDelegate:self selector:@selector(appUpdate:) appkey:UMENG_KEY channel:nil];
    if (updateResult) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[updateResult objectForKey:@"path"]]];
    }
}
@end
