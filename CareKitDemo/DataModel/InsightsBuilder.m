//
//  InsightsBuilder.m
//  CareKitDemo
//
//  Created by Realank on 2018/1/23.
//  Copyright © 2018年 iMooc. All rights reserved.
//

#import "InsightsBuilder.h"
@interface InsightsBuilder()

@property (nonatomic, strong) NSMutableDictionary* temperatureValuesM;
@property (nonatomic, strong) NSMutableArray* datesM;
@property (nonatomic, strong) NSMutableArray* completionsM;
@property (nonatomic, strong) NSMutableArray* completionsLabelM;
@property (nonatomic, assign) NSInteger fetchProgress;
@end
@implementation InsightsBuilder


- (void)resetProgress{
    _fetchProgress = -1;
}

- (void)startToFetch{
    _fetchProgress = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self resetProgress];
    });
}
- (BOOL)isFetchMissionEmpty{
    return _fetchProgress == -1;
}

- (void)fillProgress{
    _fetchProgress++;
    if (_fetchProgress == [CareDataModel sharedInstance].activities.count) {
        [self fetchDailyCompletion];
    }
}

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
        OCKMessageItem* emptyInsights = [[OCKMessageItem alloc] initWithTitle:@"No Insights" text:@"You haven't entered any data, or reports are in process." tintColor:[UIColor orangeColor] messageType:OCKMessageItemTypeTip];
        _insights = @[emptyInsights];
        _fetchProgress = -1;
    }
    return self;
}

- (OCKCarePlanStore*)carePlanStore{
    return [CarePlanStroreManager sharedInstance].carePlanStore;
}


- (void)updateInsights{
    
    if (![self isFetchMissionEmpty]) {
        return;
    }
    
    [self startToFetch];
    
    
    _temperatureValuesM = [NSMutableDictionary dictionary];

    for (OCKCarePlanActivity* activity in [CareDataModel sharedInstance].activities) {
        [self fetchEventResultWithActivity:activity];
    }
    
}

- (void)fetchEventResultWithActivity:(OCKCarePlanActivity*)activity{
    
    NSDateComponents* queryRangeStart = [CommTool firstDateOfCurrentWeek];
    NSDateComponents* queryRangeEnd = [CommTool currentDate];
    [[CarePlanStroreManager sharedInstance].carePlanStore enumerateEventsOfActivity:activity
                                                                          startDate:queryRangeStart
                                                                            endDate:queryRangeEnd
                                                                            handler:^(OCKCarePlanEvent * _Nullable event, BOOL * _Nonnull stop) {
                                                                                if (!event.result) {
                                                                                    return;
                                                                                }
                                                                                [self saveEventResult:event.result];
                                                                                 
                                                                                
                                                                                
                                                                            }
                                                                         completion:^(BOOL completed, NSError * _Nullable error) {
                                                                             if (completed) {
                                                                                 [self fillProgress];
                                                                             }else if (error){
                                                                                 NSLog(@"error:%@",error);
                                                                             }
                                                                             
                                                                         }];
}

- (void)saveEventResult:(OCKCarePlanEventResult*)result{
    NSLog(@"result:%@",result.userInfo);
    NSDictionary* resultDict = result.userInfo;
    NSString* label = resultDict[@"valueString"];
    NSDateComponents* date = resultDict[@"date"];
    NSArray* values = resultDict[@"values"];
    NSString* type = resultDict[@"type"];
    NSString* unit = resultDict[@"unit"];
    if ([type isEqualToString:@"th"]) {
        _temperatureValuesM[date] = resultDict;
    }
}

- (void)fetchDailyCompletion{

    NSDateComponents* queryRangeStart = [CommTool firstDateOfCurrentWeek];
    NSDateComponents* queryRangeEnd = [CommTool currentDate];
    _completionsM = [NSMutableArray array];
    _completionsLabelM = [NSMutableArray array];
    _datesM = [NSMutableArray array];
    [[self carePlanStore] dailyCompletionStatusWithType:OCKCarePlanActivityTypeAssessment startDate:queryRangeStart endDate:queryRangeEnd handler:^(NSDateComponents * _Nonnull date, NSUInteger completedEvents, NSUInteger totalEvents) {
        int progress = roundf(completedEvents*100.0/totalEvents);
        [_completionsM addObject:@(progress)];
        [_completionsLabelM addObject:[NSString stringWithFormat:@"%d%%",progress]];
        [_datesM addObject:date];
    } completion:^(BOOL completed, NSError * _Nullable error) {
        if (completed) {
            [self drawChart];
        }
    }];
}

- (void)drawChart{
    NSMutableArray* temperatureValues = [NSMutableArray array];
    NSMutableArray* temperatureValueLables = [NSMutableArray array];
    NSMutableArray* dateStrings = [NSMutableArray array];
    for (NSDateComponents* date in _datesM) {
        NSDictionary* resultDict = _temperatureValuesM[date];
        if (resultDict) {
            NSString* label = resultDict[@"valueString"];
            NSDateComponents* date = resultDict[@"date"];
            NSArray* values = resultDict[@"values"];
            NSString* type = resultDict[@"type"];
            NSString* unit = resultDict[@"unit"];
            [temperatureValues addObject:values.firstObject];
            [temperatureValueLables addObject:label];
        }else{
            [temperatureValues addObject:@0];
            [temperatureValueLables addObject:@"N/A"];
        }
        NSDate* nsdate = [[NSCalendar currentCalendar] dateFromComponents:date];
        NSString* dateString = [NSDateFormatter localizedStringFromDate:nsdate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
        [dateStrings addObject:dateString];
    }
    OCKBarSeries* progressBarSeries = [[OCKBarSeries alloc] initWithTitle:@"completion" values:_completionsM valueLabels:_completionsLabelM tintColor:[UIColor lightGrayColor]];
    OCKBarSeries* temperatureBarSeries = [[OCKBarSeries alloc] initWithTitle:@"temperature" values:temperatureValues valueLabels:temperatureValueLables tintColor:[UIColor redColor]];
    OCKBarChart* barChart = [[OCKBarChart alloc] initWithTitle:@"Training Plan" text:@"Completions" tintColor:[UIColor greenColor] axisTitles:dateStrings axisSubtitles:nil dataSeries:@[progressBarSeries,temperatureBarSeries]];
    _insights = @[barChart];
    if (_delegate) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate insightBuilderDidUpdatedInsights];
        });
        
    }
    NSLog(@"update insights");
}



@end
