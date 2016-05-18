//
//  ZXLoginScrollViewController.m
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/16.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import "ZXLoginScrollViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "ZXLoginViewController.h"
#import "ZXHomeViewController.h"
#import "UINavigationController+PHNavigationController.h"
#import "RFGeneralManager.h"

@interface ZXLoginScrollViewController ()<UIScrollViewDelegate,ZXLoginViewProtocol>
{
    TPKeyboardAvoidingScrollView *scrollView;
    ZXLoginViewController *zxLoginVC;
    UIStoryboard *storyboard;
}

@end

@implementation ZXLoginScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:0.0f/255 green:184.0f/255 blue:238.0f/255 alpha:1.0f]];
    scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    zxLoginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewIdentify"];
    zxLoginVC.delegate = self;
    [scrollView addSubview:zxLoginVC.view];
    
    [scrollView setContentSize:zxLoginVC.view.frame.size];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark ZXLoginViewProtocol
-(void)loginSuccess
{
    [[RFGeneralManager defaultManager] sendClientIdSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } Error:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } Failed:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    ZXHomeViewController *zxHomeVC = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewIdentify"];
    [self.navigationController pushViewController:zxHomeVC animated:YES];
}
@end
