//
//  ZXAccountDetailsViewController.m
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/17.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import "ZXAccountDetailsViewController.h"
#import "ZXAppStartManager.h"
#import "ZXAmountDetailsViewManager.h"
#import "MJRefresh.h"

@interface ZXAccountDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataArr;
    
    BOOL hasMore;
    NSInteger loadPage;
}
@property(nonatomic, strong) IBOutlet UIImageView *noRecordImageView;
@property(nonatomic, strong) IBOutlet UILabel *lblNoRecord;
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@end

@implementation ZXAccountDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    dataArr = [[NSMutableArray alloc] init];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    [self.tableView setTableFooterView:[UIView new]];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 25.0f)];
    [headView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.tableView setTableHeaderView:headView];
    
    [self tableViewAddHeader];
    [self tableViewAddFoot];
    
    [self setSubViewHiddenStatusWithGoodListCount:1];
    loadPage = 1;
    [self requestAmountDetailsWithPageNum:loadPage];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"账单明细"];
}

-(void)tableViewAddHeader
{
    __weak ZXAccountDetailsViewController *weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        [weakSelf refreshTableView];
    }];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"招薪宝玩命刷新中...";
}

-(void)tableViewAddFoot
{
    __weak ZXAccountDetailsViewController *weakSelf = self;
    [self.tableView addFooterWithCallback:^{
        [weakSelf insertRowAtBottom];
    }];
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"招薪宝玩命加载中...";
}

-(void)setHasMore:(BOOL)more
{
    hasMore = more;
    if (hasMore) {
//        [self tableViewFootViewInit];
    }else{
//        [self tableViewFootViewOver];
        [self.tableView footerEndRefreshing];
        [self.tableView removeFooter];
    }
}

-(void)tableViewFootViewInit
{
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 21)];
    [lable setTextAlignment:NSTextAlignmentCenter];
    [lable setFont:[UIFont systemFontOfSize:15.0f]];
    [lable setTextColor:[UIColor grayColor]];
    lable.text = @"还有更多...";
    [self.tableView setTableFooterView:lable];
}

-(void)tableViewFootViewOver
{
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 21)];
    [lable setTextAlignment:NSTextAlignmentCenter];
    [lable setFont:[UIFont systemFontOfSize:15.0f]];
    [lable setTextColor:[UIColor grayColor]];
    lable.text = @"已全部加载";
    [self.tableView setTableFooterView:lable];
}

-(void)refreshTableView
{
    loadPage = 1;
    [self setHasMore:YES];
    [self tableViewAddFoot];
    
    [self requestAmountDetailsWithPageNum:loadPage];
}

- (void)insertRowAtBottom {
    int64_t delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (hasMore) {
            loadPage = loadPage + 1;
            [self requestAmountDetailsWithPageNum:loadPage];
        }
    });
}

-(void)setSubViewHiddenStatusWithGoodListCount:(NSInteger)count
{
    if (count > 0) {
        [self.tableView setHidden:NO];
        [self.noRecordImageView setHidden:YES];
        [self.lblNoRecord setHidden:YES];
    }else{
        [self.tableView setHidden:YES];
        [self.noRecordImageView setHidden:NO];
        [self.lblNoRecord setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestAmountDetailsWithPageNum:(NSInteger)page
{
    Member *host = [[ZXAppStartManager defaultManager] currentHost];
    if (host) {
        if (page == 1) {
            [AppUtils showProgressBarForView:self.view];
        }
        [[ZXAmountDetailsViewManager defaultManager] requestAmountDetailsWithUid:host.memberId WithToken:host.token WithPageNum:page Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *resultDic = (NSDictionary *)responseObject;
            if (resultDic) {
                NSDictionary *dataDic = [resultDic objectForKey:@"data"];
                if (dataDic) {
                    NSInteger lastPage = [[dataDic objectForKey:@"last_page"] integerValue];
                    if (lastPage == page) {
                        [self setHasMore:NO];
                    }else if (page < lastPage){
                        [self setHasMore:YES];
                    }
                    NSArray *list = [dataDic objectForKey:@"list"];
                    if (list) {
                        NSMutableArray *arr = [[NSMutableArray alloc] init];
                        for (NSDictionary *dic in list) {
                            if (dic) {
                                [arr addObject:dic];
                            }
                        }
                        
                        if (arr.count > 0) {
                            if (page == 1) {
                                dataArr = [NSMutableArray arrayWithArray:arr];
                            }else{
                                [dataArr addObjectsFromArray:arr];
                            }
                        }
                        [self setSubViewHiddenStatusWithGoodListCount:dataArr.count];
                        [self.tableView reloadData];
                    }

                }
            }
            
            if (page == 1) {
                [AppUtils hideProgressBarForView:self.view];
                [self.tableView headerEndRefreshing];
            }else{
                [self.tableView footerEndRefreshing];
            }
        } Error:^(AFHTTPRequestOperation *operation, id responseObject) {
            [AppUtils showInfo:[responseObject objectForKey:@"message"]];
            if (page == 1) {
                [AppUtils hideProgressBarForView:self.view];
                [self.tableView headerEndRefreshing];
            }else{
                [self.tableView footerEndRefreshing];
            }
        } Failed:^(AFHTTPRequestOperation *operation, NSError *error) {
            [AppUtils showInfo:@"网络连接失败"];
            if (page == 1) {
                [AppUtils hideProgressBarForView:self.view];
                [self.tableView headerEndRefreshing];
            }else{
                [self.tableView footerEndRefreshing];
            }
        }];
    }
}

#pragma -mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.0f;
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
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AcountDetailsCellIdentify" forIndexPath:indexPath];
    if (dataArr.count > 0) {
        NSDictionary *dataDic = [dataArr objectAtIndex:indexPath.row];
        UILabel *lblDetailName = (UILabel *)[cell viewWithTag:1];
        [lblDetailName setText:[dataDic objectForKey:@"description"]];
        UILabel *lblDetailTime = (UILabel *)[cell viewWithTag:2];
        [lblDetailTime setText:[dataDic objectForKey:@"date"]];
        UILabel *lblDetailAmount = (UILabel *)[cell viewWithTag:3];
        NSInteger inOrOut = [[dataDic objectForKey:@"inout"] integerValue];
        NSString *amount = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"amount"]];
        if (inOrOut == 0) {
            [lblDetailAmount setTextColor:[UIColor colorWithRed:0.867 green:0.380 blue:0.384 alpha:1.000]];
        }else if (inOrOut == 1){
            [lblDetailAmount setTextColor:[UIColor colorWithRed:91.0f/255 green:24.0f/255 blue:24.0f/255 alpha:1.0f]];
        }else{
            [lblDetailAmount setTextColor:[UIColor colorWithRed:0.867 green:0.380 blue:0.384 alpha:1.000]];
        }
        [lblDetailAmount setText:amount];
        
        UIView *lineView = (UIView *)[cell viewWithTag:4];
        if ((indexPath.row + 1) == dataArr.count) {
            [lineView setHidden:YES];
        }else{
            [lineView setHidden:NO];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end
