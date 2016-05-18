//
//  ZXGuidViewController.m
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/12.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import "ZXGuidViewController.h"
#import "PHMyGuidView.h"
#import "ZXLoginScrollViewController.h"

@interface ZXGuidViewController ()<PHMyGuidViewDelegate>

@end

@implementation ZXGuidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self buildIntro];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buildIntro{
    //Add panels to an array
    UIImage *image1 = [UIImage imageNamed:@"FirstGuidPicture"];
    UIImage *image2 = [UIImage imageNamed:@"SecondGuidPicture"];
    UIImage *image3 = [UIImage imageNamed:@"ThirdGuidPicture"];
    NSArray *panels = [NSArray arrayWithObjects:image1,image2,image3, nil];
    PHMyGuidView *phMyGuidView = [[PHMyGuidView alloc] initWithFrame:self.view.frame];
    phMyGuidView.delegate = self;
    [phMyGuidView setPanelList:panels];
    [self.view addSubview:phMyGuidView];
}

#pragma mark - MYIntroduction Delegate
-(void)skipGuidView
{
    ZXLoginScrollViewController *zxLoginScrollVC = [[ZXLoginScrollViewController alloc] init];
    [self.navigationController pushViewController:zxLoginScrollVC animated:YES];
}
@end
