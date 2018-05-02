//
//  ChartDataSources.m
//  CareKitDemo
//
//  Created by Realank on 2018/1/31.
//  Copyright © 2018年 iMooc. All rights reserved.
//

#import "ChartDataSources.h"

@implementation ChartDataSources

+(instancetype) sharedInstance {
    static dispatch_once_t pred;
    static id shared = nil; //设置成id类型的目的，是为了继承
    dispatch_once(&pred, ^{
        shared = [[super alloc] initUniqueInstance];
    });
    return shared;
}

-(instancetype) initUniqueInstance {
    
    if (self = [super init]) {
        [self configDatas];
    }
    return self;
}

- (void)configDatas{
    
}

@end

@implementation PieChartDataSource

+(instancetype) sharedInstance {
    static dispatch_once_t pred;
    static id shared = nil; //设置成id类型的目的，是为了继承
    dispatch_once(&pred, ^{
        shared = [[super alloc] initUniqueInstance];
    });
    return shared;
}

- (void)configDatas{
    _colors = @[UIColorFromRGB(0xf7bbe8),UIColorFromRGB(0x8e8e93),UIColorFromRGB(0xf4be4a)];
    _values = @[@10.0,@25.0,@45.0];
    _titles = @[@"Title1",@"Title2",@"Title3",];
}

- (NSInteger)numberOfSegmentsInPieChartView:(ORKPieChartView *)pieChartView{
    return _values.count;
}

- (NSString *)pieChartView:(ORKPieChartView *)pieChartView titleForSegmentAtIndex:(NSInteger)index{
    return _titles[index];
}

- (CGFloat)pieChartView:(ORKPieChartView *)pieChartView valueForSegmentAtIndex:(NSInteger)index{
    return [[_values objectAtIndex:index] floatValue];
}
- (UIColor *)pieChartView:(ORKPieChartView *)pieChartView colorForSegmentAtIndex:(NSInteger)index{
    if (index < _colors.count) {
        return [_colors objectAtIndex:index];
    }
    return [UIColor grayColor];
}

@end

@implementation LineChartDataSource

+(instancetype) sharedInstance {
    static dispatch_once_t pred;
    static id shared = nil; //设置成id类型的目的，是为了继承
    dispatch_once(&pred, ^{
        shared = [[super alloc] initUniqueInstance];
    });
    return shared;
}

- (void)configDatas{
    _plotPoints = @[ @[[[ORKValueRange alloc]initWithValue:10],
                       [[ORKValueRange alloc]initWithValue:20],
                       [[ORKValueRange alloc]initWithValue:30],
                       [[ORKValueRange alloc]init],
                       [[ORKValueRange alloc]initWithValue:50],
                       [[ORKValueRange alloc]initWithValue:60]],
                     @[[[ORKValueRange alloc]initWithValue:2],
                       [[ORKValueRange alloc]initWithValue:4],
                       [[ORKValueRange alloc]initWithValue:8],
                       [[ORKValueRange alloc]initWithValue:16],
                       [[ORKValueRange alloc]initWithValue:32],
                       [[ORKValueRange alloc]initWithValue:64]] ];
    _valueRange = @[@0,@70];
}

- (NSInteger)numberOfPlotsInGraphChartView:(ORKGraphChartView *)graphChartView{
    return _plotPoints.count;
}

- (ORKValueRange *)graphChartView:(ORKGraphChartView *)graphChartView dataPointForPointIndex:(NSInteger)pointIndex plotIndex:(NSInteger)plotIndex{
    return _plotPoints[plotIndex][pointIndex];
}

- (NSInteger)graphChartView:(ORKGraphChartView *)graphChartView numberOfDataPointsForPlotIndex:(NSInteger)plotIndex{
    return ((NSArray*)_plotPoints[plotIndex]).count;
}

- (double)maximumValueForGraphChartView:(ORKGraphChartView *)graphChartView{
    return [_valueRange[1] doubleValue];
}

- (double)minimumValueForGraphChartView:(ORKGraphChartView *)graphChartView{
    return [_valueRange[0] doubleValue];;
}

- (NSString *)graphChartView:(ORKGraphChartView *)graphChartView titleForXAxisAtPointIndex:(NSInteger)pointIndex{
    if (pointIndex < _xTitle.count) {
        return [_xTitle objectAtIndex:pointIndex];
    }
    return [NSString stringWithFormat:@"%d",pointIndex+1];
}

- (BOOL)graphChartView:(ORKGraphChartView *)graphChartView drawsPointIndicatorsForPlotIndex:(NSInteger)plotIndex{
    if (plotIndex == 1) {
        return NO;
    }
    return YES;
}
@end

@implementation BPChartDataSource


+(instancetype) sharedInstance {
    static dispatch_once_t pred;
    static id shared = nil; //设置成id类型的目的，是为了继承
    dispatch_once(&pred, ^{
        shared = [[super alloc] initUniqueInstance];
    });
    return shared;
}

@end

@implementation BGChartDataSource


+(instancetype) sharedInstance {
    static dispatch_once_t pred;
    static id shared = nil; //设置成id类型的目的，是为了继承
    dispatch_once(&pred, ^{
        shared = [[super alloc] initUniqueInstance];
    });
    return shared;
}

@end

@implementation TemperatureChartDataSource

+(instancetype) sharedInstance {
    static dispatch_once_t pred;
    static id shared = nil; //设置成id类型的目的，是为了继承
    dispatch_once(&pred, ^{
        shared = [[super alloc] initUniqueInstance];
    });
    return shared;
}

@end

@implementation CompletionChartDataSource

+(instancetype) sharedInstance {
    static dispatch_once_t pred;
    static id shared = nil; //设置成id类型的目的，是为了继承
    dispatch_once(&pred, ^{
        shared = [[super alloc] initUniqueInstance];
    });
    return shared;
}

- (void)configDatas{
    self.plotPoints = @[ @[[[ORKValueStack alloc] initWithStackedValues:@[@4]],
                           [[ORKValueStack alloc] initWithStackedValues:@[@4,@6,@7]],
                           [[ORKValueStack alloc] initWithStackedValues:@[@2,@6]],
                           [[ORKValueStack alloc] initWithStackedValues:@[@3,@5,@8,@12]],
                           [[ORKValueStack alloc] initWithStackedValues:@[@2,@6]],
                           [[ORKValueStack alloc] initWithStackedValues:@[@4,@5]],],
                         @[[[ORKValueStack alloc] initWithStackedValues:@[@4,@6]],
                           [[ORKValueStack alloc] initWithStackedValues:@[@9]],
                           [[ORKValueStack alloc] initWithStackedValues:@[@4,@6,@7]],
                           [[ORKValueStack alloc] initWithStackedValues:@[@4,@6,@8,@12]],
                           [[ORKValueStack alloc] initWithStackedValues:@[@2]],
                           [[ORKValueStack alloc] initWithStackedValues:@[@6]],] ];
    self.valueRange = @[@0,@30];
}

@end
