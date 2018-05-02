//
//  GraphTableViewController.m
//  CareKitDemo
//
//  Created by Realank on 2018/1/31.
//  Copyright © 2018年 iMooc. All rights reserved.
//

#import "GraphTableViewController.h"
#import "ChartTableViewCell.h"
#import "ChartDataSources.h"
@interface GraphTableViewController ()<InsightBuilderUpdateInsightsDelegate>
@property (nonatomic, strong) PieChartTableViewCell* pieChartTableViewCell;
@property (nonatomic, strong) LineGraphChartTableViewCell* bgChartTableViewCell;
@property (nonatomic, strong) LineGraphChartTableViewCell* temperatureChartTableViewCell;
@property (nonatomic, strong) DiscreteGraphChartTableViewCell* bpChartTableViewCell;
@property (nonatomic, strong) BarGraphChartTableViewCell* completionChartTableViewCell;

@end

@implementation GraphTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [InsightsBuilder sharedInstance].delegate = self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[InsightsBuilder sharedInstance] updateInsights];
}

- (PieChartTableViewCell *)pieChartTableViewCell{
    if (!_pieChartTableViewCell) {
        PieChartTableViewCell* pieCell = [[PieChartTableViewCell alloc] init];
        pieCell.titleLabel.text = @"Practice Proportion";
        ORKPieChartView* pieView = (ORKPieChartView*)pieCell.chartView;
        pieView.title = @"";
        pieView.text = @"";
        pieView.lineWidth = 14;
        pieView.radiusScaleFactor = 0.4;
        _pieChartTableViewCell = pieCell;
    }
    ((ORKPieChartView*)(_pieChartTableViewCell.chartView)).dataSource = [PieChartDataSource sharedInstance];
    return _pieChartTableViewCell;
}
- (LineGraphChartTableViewCell *)bgChartTableViewCell{
    if (!_bgChartTableViewCell) {
        LineGraphChartTableViewCell* cell = [[LineGraphChartTableViewCell alloc] init];
        cell.titleLabel.text = @"Glucose(mg/dL)";
        ORKGraphChartView* lineGraphView = (ORKGraphChartView*)cell.chartView;
        lineGraphView.tintColor = kBGTintColor;
        _bgChartTableViewCell = cell;
    }
    
    ((ORKLineGraphChartView*)_bgChartTableViewCell.chartView).dataSource = [BGChartDataSource sharedInstance];
    return _bgChartTableViewCell;
}

- (LineGraphChartTableViewCell *)temperatureChartTableViewCell{
    if (!_temperatureChartTableViewCell) {
        LineGraphChartTableViewCell* cell = [[LineGraphChartTableViewCell alloc] init];
        cell.titleLabel.text = @"Temperature(℃)";
        ORKGraphChartView* lineGraphView = (ORKGraphChartView*)cell.chartView;
        lineGraphView.tintColor = kTHTintColor;
        lineGraphView.decimalPlaces = 1;
        _temperatureChartTableViewCell = cell;
    }
    
    ((ORKLineGraphChartView*)_temperatureChartTableViewCell.chartView).dataSource = [TemperatureChartDataSource sharedInstance];
    return _temperatureChartTableViewCell;
}


- (DiscreteGraphChartTableViewCell *)bpChartTableViewCell{
    if (!_bpChartTableViewCell) {
        DiscreteGraphChartTableViewCell* discreteCell = [[DiscreteGraphChartTableViewCell alloc] init];
        discreteCell.titleLabel.text = @"Blood Pressure(mmHg)";
        ORKGraphChartView* discreteGraphView = (ORKGraphChartView*)discreteCell.chartView;
        discreteGraphView.tintColor = kBPTintColor;
        _bpChartTableViewCell = discreteCell;
    }
    ((ORKDiscreteGraphChartView*)_bpChartTableViewCell.chartView).dataSource = [BPChartDataSource sharedInstance];
    return _bpChartTableViewCell;
}
- (BarGraphChartTableViewCell *)completionChartTableViewCell{
    if (!_completionChartTableViewCell) {
        BarGraphChartTableViewCell* barCell = [[BarGraphChartTableViewCell alloc] init];
        barCell.titleLabel.text = @"Practice Completion(%)";
        ORKGraphChartView* barGraphView = (ORKGraphChartView*)barCell.chartView;
        barGraphView.tintColor = UIColorFromRGB(0x69d28e);
        _completionChartTableViewCell = barCell;
    }
    ((ORKBarGraphChartView*)_completionChartTableViewCell.chartView).dataSource = [CompletionChartDataSource sharedInstance];
    return _completionChartTableViewCell;
}


- (void)insightBuilderDidUpdatedInsights{
    NSArray* pieTitles = [InsightsBuilder sharedInstance].practiceProportionM.allKeys;
    NSMutableArray* pieValues = [NSMutableArray array];
    for (NSString* title in pieTitles) {
        [pieValues addObject:[[InsightsBuilder sharedInstance].practiceProportionM objectForKey:title]];
    }
    [PieChartDataSource sharedInstance].titles = pieTitles;
    [PieChartDataSource sharedInstance].colors = @[UIColorFromRGB(0x9d6dff),UIColorFromRGB(0xf596ed),UIColorFromRGB(0xd03d59)];
    [PieChartDataSource sharedInstance].values = pieValues;
    
    NSMutableArray* completionPointsM = [NSMutableArray array];
    for (NSNumber* completion in [InsightsBuilder sharedInstance].completionsM) {
        [completionPointsM addObject:[[ORKValueStack alloc] initWithStackedValues:@[completion]]];
    }
    [CompletionChartDataSource sharedInstance].plotPoints = @[[completionPointsM copy]];
    [CompletionChartDataSource sharedInstance].valueRange = @[@0,@100];
    [CompletionChartDataSource sharedInstance].xTitle = [InsightsBuilder sharedInstance].dateStrings;
    
    NSMutableArray* bpPoints = [NSMutableArray array];
    double maxValue = 0;
    double minValue = 10000;
    for (int i = 0; i < [InsightsBuilder sharedInstance].bpSysValues.count; i++) {
        double sys = [[InsightsBuilder sharedInstance].bpSysValues[i] doubleValue];
        double dia = [[InsightsBuilder sharedInstance].bpDiaValues[i] doubleValue];
        if (sys >= dia && dia > 0) {
            maxValue = maxValue > sys ? maxValue : sys;
            minValue = minValue < dia ? minValue : dia;
            [bpPoints addObject:[[ORKValueRange alloc]initWithMinimumValue:dia maximumValue:sys]];
        }else{
            [bpPoints addObject:[[ORKValueRange alloc]init]];
        }
        
    }
    [BPChartDataSource sharedInstance].plotPoints = @[[bpPoints copy]];
    [BPChartDataSource sharedInstance].valueRange = @[@(minValue),@(maxValue)];
    [BPChartDataSource sharedInstance].xTitle = [InsightsBuilder sharedInstance].dateStrings;
    
    
    NSMutableArray* bgPointsM = [NSMutableArray array];
    for (NSNumber* value in [InsightsBuilder sharedInstance].bgValues) {
        if (value.doubleValue > 0) {
            [bgPointsM addObject:[[ORKValueRange alloc] initWithValue:value.doubleValue]];
        }else{
            [bgPointsM addObject:[[ORKValueRange alloc] init]];
        }
        
    }
    [BGChartDataSource sharedInstance].plotPoints = @[[bgPointsM copy]];
    [BGChartDataSource sharedInstance].valueRange = @[@0,@150];
    [BGChartDataSource sharedInstance].xTitle = [InsightsBuilder sharedInstance].dateStrings;
    
    NSMutableArray* temperaturePointsM = [NSMutableArray array];
    for (NSNumber* value in [InsightsBuilder sharedInstance].temperatureValues) {
        if (value.doubleValue > 0) {
            [temperaturePointsM addObject:[[ORKValueRange alloc] initWithValue:value.doubleValue]];
        }else{
            [temperaturePointsM addObject:[[ORKValueRange alloc] init]];
        }
        
    }
    [TemperatureChartDataSource sharedInstance].plotPoints = @[[temperaturePointsM copy]];
    [TemperatureChartDataSource sharedInstance].valueRange = @[@35,@42];
    [TemperatureChartDataSource sharedInstance].xTitle = [InsightsBuilder sharedInstance].dateStrings;
    NSLog(@"insights updated");
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ChartTableViewCell cellHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChartTableViewCell *cell = nil;
    switch (indexPath.row) {
        case 0:
            cell = self.pieChartTableViewCell;
            break;
        case 1:
            cell = self.completionChartTableViewCell;
            break;
        case 2:
            cell = self.bpChartTableViewCell;
            break;
        case 3:
            cell = self.bgChartTableViewCell;
            break;
        case 4:
            cell = self.temperatureChartTableViewCell;
            break;
        default:
            break;
    }
    return cell;
}

@end
