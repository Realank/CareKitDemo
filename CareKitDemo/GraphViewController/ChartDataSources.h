//
//  ChartDataSources.h
//  CareKitDemo
//
//  Created by Realank on 2018/1/31.
//  Copyright © 2018年 iMooc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartDataSources : NSObject

+(instancetype) sharedInstance;
- (void)configDatas;

@end
//Pie
@interface PieChartDataSource : ChartDataSources <ORKPieChartViewDataSource>

@property (nonatomic, strong) NSArray* colors;
@property (nonatomic, strong) NSArray* values;
@property (nonatomic, strong) NSArray* titles;

@end
//Base
@interface LineChartDataSource : ChartDataSources <ORKValueRangeGraphChartViewDataSource>

@property (nonatomic, strong) NSArray* plotPoints;
@property (nonatomic, strong) NSArray* valueRange;
@property (nonatomic, strong) NSArray* xTitle;

@end
//Discrete
@interface BPChartDataSource : LineChartDataSource

@end
//Line
@interface BGChartDataSource : LineChartDataSource

@end
//Line
@interface TemperatureChartDataSource : LineChartDataSource

@end
//Bar
@interface CompletionChartDataSource : LineChartDataSource <ORKValueStackGraphChartViewDataSource>

@end



