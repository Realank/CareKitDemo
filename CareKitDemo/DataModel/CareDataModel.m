//
//  CareDataModel.m
//  CareKitDemo
//
//  Created by Realank on 2018/1/23.
//  Copyright © 2018年 iMooc. All rights reserved.
//

#import "CareDataModel.h"

@implementation CareDataModel

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
        [self configActivities];
    }
    return self;
}



- (ORKOrderedTask*)makePulseAssessmentTask{
    HKQuantityType* quantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    HKUnit* unit = [HKUnit unitFromString:@"count/min"];
    ORKHealthKitQuantityTypeAnswerFormat* answerFormat = [[ORKHealthKitQuantityTypeAnswerFormat alloc] initWithQuantityType:quantityType unit:unit style:ORKNumericAnswerStyleInteger];
    NSString* title = @"Measure the number of beats per minute.";
    NSString* text = @"Place two fingers on your wrist and count how many beats you feel in 15 seconds.  Multiply this number by 4. If the result is 0, you are a zombie.";
    ORKQuestionStep* queationStep = [ORKQuestionStep questionStepWithIdentifier:@"PulseStep" title:title text:text answer:answerFormat];
    queationStep.optional = NO;
    return [[ORKOrderedTask alloc] initWithIdentifier:@"PulseTask" steps:@[queationStep]];
}

- (ORKOrderedTask*)makeTemperatureAssessmentTask{
    HKQuantityType* quantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
    HKUnit* unit = [HKUnit unitFromString:@"degC"];
    ORKHealthKitQuantityTypeAnswerFormat* answerFormat = [[ORKHealthKitQuantityTypeAnswerFormat alloc] initWithQuantityType:quantityType unit:unit style:ORKNumericAnswerStyleDecimal];
    NSString* title = @"Take temperature orally.";
    NSString* text = @"Temperatures should be in the range of 35.0-37.0°C";
    ORKQuestionStep* queationStep = [ORKQuestionStep questionStepWithIdentifier:@"TemperatureStep" title:title text:text answer:answerFormat];
    queationStep.optional = NO;
    return [[ORKOrderedTask alloc] initWithIdentifier:@"TemperatureTask" steps:@[queationStep]];
}

- (ORKOrderedTask*)makeBloodPressureAssessmentTask{
    HKUnit* unit = [HKUnit unitFromString:@"mmHg"];
    HKQuantityType* quantityTypeSys = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic];
    ORKHealthKitQuantityTypeAnswerFormat* answerFormatSys = [[ORKHealthKitQuantityTypeAnswerFormat alloc] initWithQuantityType:quantityTypeSys unit:unit style:ORKNumericAnswerStyleInteger];
    ORKQuestionStep* queationStepSys = [ORKQuestionStep questionStepWithIdentifier:@"BloodPressureSys"
                                                                             title:@"Take Blood Pressure."
                                                                              text:@"Systolic should be in the range of 90-150mmHg"
                                                                            answer:answerFormatSys];
    queationStepSys.optional = NO;
    HKQuantityType* quantityTypeDia = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic];
    ORKHealthKitQuantityTypeAnswerFormat* answerFormatDia = [[ORKHealthKitQuantityTypeAnswerFormat alloc] initWithQuantityType:quantityTypeDia unit:unit style:ORKNumericAnswerStyleInteger];
    ORKQuestionStep* queationStepDia = [ORKQuestionStep questionStepWithIdentifier:@"BloodPressureDia"
                                                                             title:@"Take Blood Pressure."
                                                                              text:@"Diastolic should be in the range of 50-100mmHg"
                                                                            answer:answerFormatDia];
    queationStepDia.optional = NO;
    return [[ORKOrderedTask alloc] initWithIdentifier:@"BloodPressureTask" steps:@[queationStepSys,queationStepDia]];
}

- (ORKOrderedTask*)makeBloodPressure2AssessmentTask{
    ORKFormStep* questionStep = [[ORKFormStep alloc] initWithIdentifier:@"BloodPressureForm" title:@"Take Blood Pressure." text:@"Systolic should be in the range of 90-150mmHg,Diastolic should be in the range of 50-100mmHg"];
    questionStep.optional = NO;
    HKUnit* unit = [HKUnit unitFromString:@"mmHg"];
    HKQuantityType* quantityTypeSys = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic];
    ORKHealthKitQuantityTypeAnswerFormat* answerFormatSys = [[ORKHealthKitQuantityTypeAnswerFormat alloc] initWithQuantityType:quantityTypeSys unit:unit style:ORKNumericAnswerStyleInteger];
    ORKFormItem* sysFormItem = [[ORKFormItem alloc] initWithIdentifier:@"sysFormItem" text:@"Systolic" answerFormat:answerFormatSys];
    sysFormItem.optional = NO;
    HKQuantityType* quantityTypeDia = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic];
    ORKHealthKitQuantityTypeAnswerFormat* answerFormatDia = [[ORKHealthKitQuantityTypeAnswerFormat alloc] initWithQuantityType:quantityTypeDia unit:unit style:ORKNumericAnswerStyleInteger];
    ORKFormItem* diaFormItem = [[ORKFormItem alloc] initWithIdentifier:@"diaFormItem" text:@"Diastolic" answerFormat:answerFormatDia];
    diaFormItem.optional = NO;
    HKQuantityType* quantityTypeHR = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    ORKHealthKitQuantityTypeAnswerFormat* answerFormatHR = [[ORKHealthKitQuantityTypeAnswerFormat alloc] initWithQuantityType:quantityTypeHR unit:[HKUnit unitFromString:@"count/min"] style:ORKNumericAnswerStyleInteger];
    ORKFormItem* hrFormItem = [[ORKFormItem alloc] initWithIdentifier:@"hrFormItem" text:@"HeartRate" answerFormat:answerFormatHR];
    diaFormItem.optional = YES;
    questionStep.formItems = @[sysFormItem, diaFormItem,hrFormItem];
    return [[ORKOrderedTask alloc] initWithIdentifier:@"BloodPressureTask3" steps:@[questionStep]];
}


- (ORKOrderedTask*)makeBloodGlucoseAssessmentTask{
    HKUnit* unit = [HKUnit unitFromString:@"mg/dL"];
    HKQuantityType* quantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose];
    ORKHealthKitQuantityTypeAnswerFormat* answerFormat = [[ORKHealthKitQuantityTypeAnswerFormat alloc] initWithQuantityType:quantityType unit:unit style:ORKNumericAnswerStyleInteger];
    ORKQuestionStep* queationStep = [ORKQuestionStep questionStepWithIdentifier:@"BloodGlucose"
                                                                             title:@"Take Blood Glucose."
                                                                              text:@"Blood Glucose should be in the range of 20-150mg/dL"
                                                                            answer:answerFormat];
    queationStep.optional = NO;
    return [[ORKOrderedTask alloc] initWithIdentifier:@"BloodPressureTask" steps:@[queationStep]];
}

- (OCKCareSchedule*)dailyScheduleWithStartYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day occurrencesPerDay:(NSInteger)occurrences{
    NSDateComponents* startDate = [[NSDateComponents alloc] initWithYear:year month:month day:day];
    OCKCareSchedule* schedule = [OCKCareSchedule dailyScheduleWithStartDate:startDate occurrencesPerDay:occurrences];
    return schedule;
}

- (void)configActivities{
    //添加干预活动
    //有氧活动
    OCKCarePlanActivity* cardioActivity = [[OCKCarePlanActivity alloc] initWithIdentifier:@"Cardio"
                                                                          groupIdentifier:@"Practice"
                                                                                     type:OCKCarePlanActivityTypeIntervention
                                                                                    title:@"Cardio"
                                                                                     text:@"60 Min"
                                                                                tintColor:UIColorFromRGB(0xf596ed)
                                                                             instructions:@"Jog at a moderate pace for an hour. If there isn't an actual one, imagine a horde of zombies behind you."
                                                                                 imageURL:nil
                                                                                 schedule:[self dailyScheduleWithStartYear:2018 month:1 day:1 occurrencesPerDay:2]
                                                                         resultResettable:YES
                                                                                 userInfo:@{
                                                                                            @"type":@"cardio"
                                                                                            }];
    //舒展活动
    OCKCarePlanActivity* limberUpActivity = [[OCKCarePlanActivity alloc] initWithIdentifier:@"Limber Up"
                                                                            groupIdentifier:nil
                                                                                       type:OCKCarePlanActivityTypeIntervention
                                                                                      title:@"Limber Up"
                                                                                       text:@"Stretch Regularly"
                                                                                  tintColor:[UIColor  orangeColor]
                                                                               instructions:@"Stretch and warm up muscles in your arms, legs and back before any expected burst of activity. This is especially important if, for example, you're heading down a hill to inspect a Hostess truck."
                                                                                   imageURL:nil
                                                                                   schedule:[OCKCareSchedule dailyScheduleWithStartDate:[CommTool firstDateOfCurrentWeek] occurrencesPerDay:6]
                                                                           resultResettable:YES
                                                                                   userInfo:nil];
    //目标训练
    OCKCarePlanActivity* targetPracticeActivity = [[OCKCarePlanActivity alloc] initWithIdentifier:@"Target Practice"
                                                                                  groupIdentifier:@"Practice"
                                                                                             type:OCKCarePlanActivityTypeIntervention
                                                                                            title:@"Target Practice"
                                                                                             text:nil
                                                                                        tintColor:UIColorFromRGB(0x9d6dff)
                                                                                     instructions:@"Gather some objects that frustrated you before the apocalypse, like printers and construction barriers. Keep your eyes sharp and your arm steady, and blow as many holes as you can in them for at least five minutes."
                                                                                         imageURL:nil
                                                                                         schedule:[self dailyScheduleWithStartYear:2018 month:1 day:1 occurrencesPerDay:1]
                                                                                 resultResettable:YES
                                                                                         userInfo:@{
                                                                                                    @"type":@"target"
                                                                                                    }];
    //估值活动
    OCKCarePlanActivity* pulseActivity = [OCKCarePlanActivity assessmentWithIdentifier:@"Pulse"
                                                                       groupIdentifier:nil
                                                                                 title:@"Pulse"
                                                                                  text:@"Do you have one?"
                                                                             tintColor:[UIColor greenColor] resultResettable:YES schedule:[OCKCareSchedule dailyScheduleWithStartDate:[CommTool firstDateOfCurrentWeek] occurrencesPerDay:1] userInfo:@{@"ORKTask":[self makePulseAssessmentTask]} optional:NO];
    

    
    OCKCarePlanActivity* bloodPressureActivity = [OCKCarePlanActivity assessmentWithIdentifier:kActivityIdentifierBP
                                                                             groupIdentifier:@"Vitals"
                                                                                       title:@"Blood Pressure"
                                                                                        text:@"mmHg"
                                                                                   tintColor:kBPTintColor
                                                                            resultResettable:YES
                                                                                    schedule:[self dailyScheduleWithStartYear:2018 month:1 day:1 occurrencesPerDay:1]
                                                                                    userInfo:@{
                                                                                               @"ORKTask":[self makeBloodPressure2AssessmentTask],
                                                                                               @"type":@"bp"
                                                                                               }
                                                                                    optional:NO];
    
    

    OCKCarePlanThreshold* thresholdPerfect = [OCKCarePlanThreshold numericThresholdWithValue:@70 type:OCKCarePlanThresholdTypeNumericRangeInclusive upperValue:@100 title:@"Healthy blood glucose."];
    OCKCarePlanThreshold* thresholdBad = [OCKCarePlanThreshold numericThresholdWithValue:@180 type:OCKCarePlanThresholdTypeNumericGreaterThanOrEqual upperValue:nil title:@"High blood glucose."];
    
    OCKCarePlanActivity* bloodGlucoseActivity = [OCKCarePlanActivity assessmentWithIdentifier:kActivityIdentifierBG
                                                                              groupIdentifier:@"Vitals"
                                                                                        title:@"Blood Glucose"
                                                                                         text:@"mg/dL"
                                                                                    tintColor:kBGTintColor
                                                                             resultResettable:NO
                                                                                     schedule:[self dailyScheduleWithStartYear:2018 month:1 day:1 occurrencesPerDay:1]
                                                                                     userInfo:@{
                                                                                                @"ORKTask":[self makeBloodGlucoseAssessmentTask],
                                                                                                @"type":@"bg"
                                                                                                }
                                                                                   thresholds:@[@[thresholdPerfect,thresholdBad]]
                                                                                     optional:NO];
    OCKCarePlanActivity* temperatureActivity = [OCKCarePlanActivity assessmentWithIdentifier:kActivityIdentifierTH
                                                                             groupIdentifier:@"Vitals"
                                                                                       title:@"Temperature"
                                                                                        text:@"degC"
                                                                                   tintColor:kTHTintColor
                                                                            resultResettable:YES
                                                                                    schedule:[self dailyScheduleWithStartYear:2018 month:1 day:1 occurrencesPerDay:1]
                                                                                    userInfo:@{
                                                                                               @"ORKTask":[self makeTemperatureAssessmentTask],
                                                                                               @"type":@"th"
                                                                                               
                                                                                               }
                                                                                    optional:NO];
    
    _activities = @[cardioActivity,targetPracticeActivity,bloodPressureActivity, bloodGlucoseActivity, temperatureActivity];//@[cardioActivity, limberUpActivity, targetPracticeActivity,pulseActivity,temperatureActivity,bloodPressureActivity,bloodGlucoseActivity];
}


@end
