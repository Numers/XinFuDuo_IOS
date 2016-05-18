//
//  ZXSubHomeViewController.m
//  ZhaoXinBao
//
//  Created by baolicheng on 15/11/12.
//  Copyright © 2015年 pangqingyao. All rights reserved.
//

#import "ZXSubHomeViewController.h"
#import "PYEchartsView.h"
#import "Account.h"
#import "PYOption.h"
#import "PYColor.h"

@interface ZXSubHomeViewController ()
{
    CGFloat currentBalance;
    CGFloat allBalance;
    NSTimer *timer;
}
@property(nonatomic, strong) IBOutlet UIImageView *backImageView;
@property(nonatomic, strong) IBOutlet UILabel *lblBalanceMark;
@property(nonatomic, strong) IBOutlet UILabel *lblBalance;
@property(nonatomic, strong) IBOutlet UILabel *lblLastProfitMark;
@property(nonatomic, strong) IBOutlet UILabel *lblLastProfit;
@property(nonatomic, strong) IBOutlet UILabel *lblAllProfitMark;
@property(nonatomic, strong) IBOutlet UILabel *lblAllProfit;
@property(strong, nonatomic) IBOutlet PYEchartsView *kEchartView;
@end

@implementation ZXSubHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self adaptFontSize];
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
    [UIDevice adaptUILabelTextFont:_lblBalance WithIphone5FontSize:45];
    [UIDevice adaptUILabelTextFont:_lblBalanceMark WithIphone5FontSize:15.0f];
    [UIDevice adaptUILabelTextFont:_lblLastProfitMark WithIphone5FontSize:15.0f];
    [UIDevice adaptUILabelTextFont:_lblAllProfitMark WithIphone5FontSize:15.0f];
    [UIDevice adaptUILabelTextFont:_lblLastProfit WithIphone5FontSize:24.0f];
    [UIDevice adaptUILabelTextFont:_lblAllProfit WithIphone5FontSize:24.0f];
}

-(void)setLastestRatesWithXAxisData:(NSArray *)xAxisData WithYAxisValue:(NSArray *)yAxisValue
{
//    NSArray *xAxisData = @[@"11-01",@"11-02",@"11-03",@"11-04",@"11-05",@"11-06",@"11-07"];
//    NSArray *yAxisValue = @[@(2.3),@(3.7),@(8.5),@(6.4),@(5.5),@(3.6),@(6.3)];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"MM-dd"];
    
    NSMutableArray *xAxisDateArr = [[NSMutableArray alloc] init];
    for (NSString *dateStr in xAxisData) {
        NSDate *date = [formatter1 dateFromString:dateStr];
        NSString *str = [formatter2 stringFromDate:date];
        [xAxisDateArr addObject:str];
    }
    [self showLatestRateWithXAxisData:xAxisDateArr WithYAxisValue:yAxisValue];
}

-(void)setAccout:(Account *)account
{
    [self.lblLastProfit setText:[NSString stringWithFormat:@"%.2f",account.lastProfit]];
    [self.lblAllProfit setText:[NSString stringWithFormat:@"%.2f",account.allProfit]];
    currentBalance = 0.f;
    allBalance = account.balance;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(animateAccountBalance) userInfo:nil repeats:YES];
}

-(void)animateAccountBalance
{
    if (currentBalance < allBalance) {
        [self.lblBalance setText:[NSString stringWithFormat:@"%.2f",currentBalance]];
        currentBalance += allBalance / 51.f;
    }else{
        [self.lblBalance setText:[NSString stringWithFormat:@"%.2f",allBalance]];
        if ([timer isValid]) {
            [timer invalidate];
            timer = nil;
        }
    }
}

-(void)showLatestRateWithXAxisData:(NSArray *)xAxisData WithYAxisValue:(NSArray *)yAxisValue{
    PYOption *option = [[PYOption alloc] init];
    option.title = [[PYTitle alloc] init];
    option.title.text = @"七日年化收益率（%）";
    PYTextStyle *style = [[PYTextStyle alloc] init];
    [style setColor:[[PYColor alloc] initWithColor:[UIColor colorWithRed:176.0f/255 green:176.0f/255 blue:176.0f/255 alpha:1.0f]]];
    [style setFontSize:@(15)];
    [option.title setTextStyle:style];
    option.tooltip = [[PYTooltip alloc] init];
    option.tooltip.trigger = @"axis";
    [option.tooltip.axisPointer.crossStyle setColor:@"#fa8511"];
    [option.tooltip.axisPointer.lineStyle setColor:@"#e79603"];
    [option.tooltip.axisPointer.lineStyle setType:@"dashed"];
    option.legend = [[PYLegend alloc] init];
    option.legend.show = NO;
    option.legend.data = @[@"利率"];
    
    PYGrid *grid = [[PYGrid alloc] init];
    grid.borderWidth = @(0);
    grid.x = @(40);
    grid.y = @(40);
    grid.x2 = @(35);
    grid.y2 = @(25);
    option.grid = grid;

    option.calculable = YES;
    PYLineStyle *lineStype = [[PYLineStyle alloc] init];
    [lineStype setColor:@"#B0B0B0"];
    PYAxis *xAxis = [[PYAxis alloc] init];
    [xAxis.splitLine setShow:NO];
    xAxis.type = @"category";
    xAxis.boundaryGap = @(NO);
    xAxis.data = xAxisData; //设置x轴的显示数据
    xAxis.axisLabel = [[PYAxisLabel alloc] init];
    PYTextStyle *xAxisTextStyle = [[PYTextStyle alloc] init];
    [xAxisTextStyle setColor:[[PYColor alloc] initWithColor:[UIColor colorWithRed:176.0f/255 green:176.0f/255 blue:176.0f/255 alpha:1.0f]]]; //设置x轴数据的字体颜色
    xAxis.axisLabel.textStyle = xAxisTextStyle;
    xAxis.axisLine.lineStyle = lineStype; //设置x轴轴线颜色
    
    option.xAxis = [[NSMutableArray alloc] initWithObjects:xAxis, nil];
    PYAxis *yAxis = [[PYAxis alloc] init];
    yAxis.type = @"value";
    yAxis.axisLabel = [[PYAxisLabel alloc] init];
    yAxis.axisLabel.formatter = @"{value} %";  //设置y轴数据的显示格式
    PYTextStyle *yAxisTextStyle = [[PYTextStyle alloc] init];
    [yAxisTextStyle setColor:[[PYColor alloc] initWithColor:[UIColor colorWithRed:0.557 green:0.557 blue:0.576 alpha:1.000]]]; //设置y轴数据的字体颜色
    yAxis.axisLabel.textStyle = yAxisTextStyle;
    yAxis.axisLine.lineStyle = lineStype; //设置y轴轴线颜色
    option.yAxis = [[NSMutableArray alloc] initWithObjects:yAxis, nil];
    NSMutableArray *serieses = [[NSMutableArray alloc] init];
    PYCartesianSeries *series1 = [[PYCartesianSeries alloc] init];
    series1.name = @"利率";
    series1.type = @"line";
    series1.smooth = YES;
    series1.showAllSymbol = YES;
    series1.itemStyle = [[PYItemStyle alloc] init];
    series1.itemStyle.normal = [[PYItemStyleProp alloc] init];
    series1.itemStyle.normal.areaStyle = [[PYAreaStyle alloc] init];
    series1.itemStyle.normal.areaStyle.type = @"default";
//    [series1.markPoint.effect setColor:[[PYColor alloc] initWithColor:[UIColor colorWithRed:0.980 green:0.522 blue:0.067 alpha:1.000]]];
    series1.itemStyle.normal.color = [[PYColor alloc] initWithColor:[UIColor colorWithRed:0.980 green:0.522 blue:0.067 alpha:1.000]]; //设置填充颜色
    series1.data = yAxisValue;
    [serieses addObject:series1];
    [option setSeries:serieses];
    [_kEchartView loadEcharts];
    [_kEchartView setOption:option];
}
@end
