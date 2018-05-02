//
//  InsightsBuilder.m
//  CareKitDemo
//
//  Created by Realank on 2018/1/23.
//  Copyright © 2018年 iMooc. All rights reserved.
//

#import "InsightsBuilder.h"
@interface InsightsBuilder()
@property (nonatomic, strong) NSMutableDictionary* interventionCompleteStatusM;
@property (nonatomic, strong) NSMutableDictionary* temperatureValuesM;
@property (nonatomic, strong) NSMutableDictionary* bpValuesM;
@property (nonatomic, strong) NSMutableDictionary* bgValuesM;
@property (nonatomic, assign) NSInteger fetchProgress;
@end
@implementation InsightsBuilder


- (void)resetProgress{
    _fetchProgress = -1;
}

- (void)startToFetch{
    _fetchProgress = 0;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self resetProgress];
//    });
}
- (BOOL)isFetchMissionEmpty{
    return _fetchProgress == -1;
}

- (void)fillProgress{
    _fetchProgress++;
    if (_fetchProgress == [CareDataModel sharedInstance].activities.count) {
        [self resetProgress];
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
    return [CarePlanStoreManager sharedInstance].carePlanStore;
}


- (void)updateInsights{
    NSLog(@"start update insights");
    if (![self isFetchMissionEmpty]) {
        return;
    }
    
    [self startToFetch];
    
    _practiceProportionM = [NSMutableDictionary dictionary];
    _temperatureValuesM = [NSMutableDictionary dictionary];
    _bpValuesM = [NSMutableDictionary dictionary];
    _bgValuesM = [NSMutableDictionary dictionary];
    _interventionCompleteStatusM = [NSMutableDictionary dictionary];
    for (OCKCarePlanActivity* activity in [CareDataModel sharedInstance].activities) {
        [self fetchEventResultWithActivity:activity];
    }
    
}

- (void)fetchEventResultWithActivity:(OCKCarePlanActivity*)activity{
    
    NSDateComponents* queryRangeStart = [CommTool dateBeforeDays:7];//[CommTool firstDateOfCurrentWeek];
    NSDateComponents* queryRangeEnd = [CommTool currentDate];
    [[CarePlanStoreManager sharedInstance].carePlanStore enumerateEventsOfActivity:activity
                                                                          startDate:queryRangeStart
                                                                            endDate:queryRangeEnd
                                                                            handler:^(OCKCarePlanEvent * _Nullable event, BOOL * _Nonnull stop) {
                                                                                if (event.activity.type == OCKCarePlanActivityTypeAssessment && event.result) {
                                                                                    [self saveAssessmentEventResult:event.result];
                                                                                }else if(event.activity.type == OCKCarePlanActivityTypeIntervention && event.state == OCKCarePlanEventStateCompleted){
                                                                                    [self saveInterventionEvent:event];
                                                                                }
                                                                                
                                                                            }
                                                                         completion:^(BOOL completed, NSError * _Nullable error) {
                                                                             if (completed) {
                                                                                 [self fillProgress];
                                                                             }else if (error){
                                                                                 NSLog(@"error:%@",error);
                                                                             }
                                                                             
                                                                         }];
}


- (void)saveInterventionEvent:(OCKCarePlanEvent*)event{
    NSString* identifier = event.activity.identifier;
    NSNumber* times = _practiceProportionM[identifier];
    if (!times) {
        times = @0;
    }
    _practiceProportionM[identifier] = @(times.integerValue + 1);
    
}
- (void)saveAssessmentEventResult:(OCKCarePlanEventResult*)result{
    NSLog(@"result:%@",result.userInfo);
    NSDictionary* resultDict = result.userInfo;
    NSString* label = resultDict[@"valueString"];
    NSDateComponents* date = resultDict[@"date"];
    NSArray* values = resultDict[@"values"];
    NSString* type = resultDict[@"type"];
    NSString* unit = resultDict[@"unit"];
    if ([type isEqualToString:@"th"]) {
        _temperatureValuesM[date] = resultDict;
    }else if ([type isEqualToString:@"bp"]){
        _bpValuesM[date] = resultDict;
    }else if ([type isEqualToString:@"bg"]){
        _bgValuesM[date] = resultDict;
    }
}

- (void)fetchDailyCompletion{

    NSDateComponents* queryRangeStart = [CommTool dateBeforeDays:7];
    NSDateComponents* queryRangeEnd = [CommTool currentDate];
    _completionsM = [NSMutableArray array];
    _completionsLabelM = [NSMutableArray array];
    _datesM = [NSMutableArray array];
    [[self carePlanStore] dailyCompletionStatusWithType:OCKCarePlanActivityTypeIntervention startDate:queryRangeStart endDate:queryRangeEnd handler:^(NSDateComponents * _Nonnull date, NSUInteger completedEvents, NSUInteger totalEvents) {
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
    _temperatureValues = [NSMutableArray array];
    NSMutableArray* temperatureValueLables = [NSMutableArray array];
    _bpSysValues = [NSMutableArray array];
    NSMutableArray* bpSysValueLables = [NSMutableArray array];
    _bpDiaValues = [NSMutableArray array];
    NSMutableArray* bpDiaValueLables = [NSMutableArray array];
    _bgValues = [NSMutableArray array];
    NSMutableArray* bgValueLables = [NSMutableArray array];
    _dateStrings = [NSMutableArray array];
    for (NSDateComponents* date in _datesM) {
        NSDictionary* resultDict = _temperatureValuesM[date];
        if (resultDict) {
            NSString* label = resultDict[@"valueString"];
            NSArray* values = resultDict[@"values"];
            [_temperatureValues addObject:values.firstObject];
            [temperatureValueLables addObject:label];
        }else{
            [_temperatureValues addObject:@0];
            [temperatureValueLables addObject:@"N/A"];
        }
        
        resultDict = _bpValuesM[date];
        if (resultDict) {
            NSArray* values = resultDict[@"values"];
            NSNumber* sys = values[0];
            NSNumber* dia = values[1];
            [_bpSysValues addObject:sys];
            [_bpDiaValues addObject:dia];
            [bpSysValueLables addObject:sys.stringValue];
            [bpDiaValueLables addObject:dia.stringValue];
        }else{
            [_bpSysValues addObject:@0];
            [_bpDiaValues addObject:@0];
            [bpSysValueLables addObject:@"N/A"];
            [bpDiaValueLables addObject:@"N/A"];
        }
        
        resultDict = _bgValuesM[date];
        if (resultDict) {
            NSString* label = resultDict[@"valueString"];
            NSArray* values = resultDict[@"values"];
            [_bgValues addObject:values.firstObject];
            [bgValueLables addObject:label];
        }else{
            [_bgValues addObject:@0];
            [bgValueLables addObject:@"N/A"];
        }
        
        NSDate* nsdate = [[NSCalendar currentCalendar] dateFromComponents:date];
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"EEE"];
//        NSString* dateString = [NSDateFormatter localizedStringFromDate:nsdate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
        NSString* dateString = [df stringFromDate:nsdate];
        [_dateStrings addObject:dateString];
    }
    OCKBarSeries* progressBarSeries = [[OCKBarSeries alloc] initWithTitle:@"Practice Completion" values:_completionsM valueLabels:_completionsLabelM tintColor:UIColorFromRGB(0xed3f3f)];

    
    OCKBarSeries* bpSysBarSeries = [[OCKBarSeries alloc] initWithTitle:@"SYS" values:_bpSysValues valueLabels:bpSysValueLables tintColor:UIColorFromRGB(0x265cfd)];
    OCKBarSeries* bpDiaBarSeries = [[OCKBarSeries alloc] initWithTitle:@"DIA" values:_bpDiaValues valueLabels:bpDiaValueLables tintColor:UIColorFromRGB(0x5881fc)];
    
    OCKBarSeries* bgBarSeries = [[OCKBarSeries alloc] initWithTitle:@"Glucose" values:_bgValues valueLabels:bgValueLables tintColor:kBGTintColor];
    
    OCKBarSeries* thBarSeries = [[OCKBarSeries alloc] initWithTitle:@"Temperature" values:_temperatureValues valueLabels:temperatureValueLables tintColor:kTHTintColor];
    
    OCKBarChart* barChart = [[OCKBarChart alloc] initWithTitle:@"Activities" text:@"status" tintColor:[UIColor grayColor] axisTitles:_dateStrings axisSubtitles:nil dataSeries:@[progressBarSeries,thBarSeries] minimumScaleRangeValue:@0 maximumScaleRangeValue:@10];
    _insights = @[barChart];
    if (_delegate) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate insightBuilderDidUpdatedInsights];
        });
        
    }
    NSLog(@"update insights");
}



@end
