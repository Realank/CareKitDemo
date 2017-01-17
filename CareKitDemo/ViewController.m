//
//  ViewController.m
//  CareKitDemo
//
//  Created by Realank on 2017/1/17.
//  Copyright © 2017年 iMooc. All rights reserved.
//

#import "ViewController.h"
#import <CareKit/CareKit.h>
#import <ResearchKit/ResearchKit.h>

@interface ViewController ()<OCKSymptomTrackerViewControllerDelegate>

@property (nonatomic, strong) OCKCarePlanStore* carePlanStore;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initCarePlanStore];
}

- (NSDateComponents*)firstDateOfCurrentWeek{
    NSDate *beginningOfWeek = nil;
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    gregorian.locale = [NSLocale currentLocale];
    [gregorian rangeOfUnit:NSCalendarUnitWeekOfYear startDate:&beginningOfWeek interval:nil forDate:[NSDate date]];
    NSDateComponents* dateComponents = [gregorian components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:beginningOfWeek];
    return dateComponents;
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

- (void)initCarePlanStore{
    //创建健康数据存储路径
    NSURL* documentDir = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    NSURL* storeURL = [documentDir URLByAppendingPathComponent:@"CarePlanStore"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:storeURL.path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:storeURL.path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    _carePlanStore = [[OCKCarePlanStore alloc] initWithPersistenceDirectoryURL:storeURL];
    //添加干预活动
    //有氧活动
    OCKCarePlanActivity* cardioActivity = [[OCKCarePlanActivity alloc] initWithIdentifier:@"Cardio"
                                                                          groupIdentifier:nil
                                                                                     type:OCKCarePlanActivityTypeIntervention
                                                                                    title:@"Cardio"
                                                                                     text:@"60 Min"
                                                                                tintColor:[UIColor  orangeColor]
                                                                             instructions:@"Jog at a moderate pace for an hour. If there isn't an actual one, imagine a horde of zombies behind you."
                                                                                 imageURL:nil
                                                                                 schedule:[OCKCareSchedule dailyScheduleWithStartDate:[self firstDateOfCurrentWeek] occurrencesPerDay:2]
                                                                         resultResettable:YES
                                                                                 userInfo:nil];
    //舒展活动
    OCKCarePlanActivity* limberUpActivity = [[OCKCarePlanActivity alloc] initWithIdentifier:@"Limber Up"
                                                                            groupIdentifier:nil
                                                                                       type:OCKCarePlanActivityTypeIntervention
                                                                                      title:@"Limber Up"
                                                                                       text:@"Stretch Regularly"
                                                                                  tintColor:[UIColor  orangeColor]
                                                                               instructions:@"Stretch and warm up muscles in your arms, legs and back before any expected burst of activity. This is especially important if, for example, you're heading down a hill to inspect a Hostess truck."
                                                                                   imageURL:nil
                                                                                   schedule:[OCKCareSchedule dailyScheduleWithStartDate:[self firstDateOfCurrentWeek] occurrencesPerDay:6]
                                                                           resultResettable:YES
                                                                                   userInfo:nil];
    //目标训练
    OCKCarePlanActivity* targetPracticeActivity = [[OCKCarePlanActivity alloc] initWithIdentifier:@"Target Practice"
                                                                                  groupIdentifier:nil
                                                                                             type:OCKCarePlanActivityTypeIntervention
                                                                                            title:@"Target Practice"
                                                                                             text:nil
                                                                                        tintColor:[UIColor  orangeColor]
                                                                                     instructions:@"Gather some objects that frustrated you before the apocalypse, like printers and construction barriers. Keep your eyes sharp and your arm steady, and blow as many holes as you can in them for at least five minutes."
                                                                                         imageURL:nil
                                                                                         schedule:[OCKCareSchedule dailyScheduleWithStartDate:[self firstDateOfCurrentWeek] occurrencesPerDay:2]
                                                                                 resultResettable:YES
                                                                                         userInfo:nil];
    //估值活动
    OCKCarePlanActivity* pulseActivity = [OCKCarePlanActivity assessmentWithIdentifier:@"Pulse"
                                                                       groupIdentifier:nil
                                                                                 title:@"Pulse"
                                                                                  text:@"Do you have one?"
                                                                             tintColor:[UIColor greenColor]
                                                                      resultResettable:YES
                                                                              schedule:[OCKCareSchedule dailyScheduleWithStartDate:[self firstDateOfCurrentWeek] occurrencesPerDay:1]
                                                                              userInfo:@{@"ORKTask":[self makePulseAssessmentTask]}];
    OCKCarePlanActivity* temperatureActivity = [OCKCarePlanActivity assessmentWithIdentifier:@"Temperature"
                                                                       groupIdentifier:nil
                                                                                 title:@"Temperature"
                                                                                  text:@"Oral"
                                                                             tintColor:[UIColor yellowColor]
                                                                      resultResettable:YES
                                                                              schedule:[OCKCareSchedule dailyScheduleWithStartDate:[self firstDateOfCurrentWeek] occurrencesPerDay:1]
                                                                              userInfo:@{@"ORKTask":[self makeTemperatureAssessmentTask]}];
    
    NSArray* activitiesArray = @[cardioActivity, limberUpActivity, targetPracticeActivity,pulseActivity,temperatureActivity];
    //添加活动
    for (OCKCarePlanActivity* activityToAdd in activitiesArray) {
        //先判断有没有同名的活动，没有再添加
        [_carePlanStore activityForIdentifier:activityToAdd.identifier completion:^(BOOL success, OCKCarePlanActivity * _Nullable activity, NSError * _Nullable error) {
            if (success) {
                if (!activity) {
                    //没有同名活动则添加
                    [_carePlanStore addActivity:activityToAdd completion:^(BOOL success, NSError * _Nullable error) {
                        if (success) {
                            //添加成功
                            NSLog(@"success");
                        }
                    }];
                }
            }
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }

}
- (IBAction)pushCareCard:(id)sender {
    OCKCareCardViewController* viewController = [[OCKCareCardViewController alloc] initWithCarePlanStore:_carePlanStore];
    [self.navigationController pushViewController:viewController animated:YES];
}
- (IBAction)symptomTracker:(id)sender {
    OCKSymptomTrackerViewController* viewController = [[OCKSymptomTrackerViewController alloc] initWithCarePlanStore:_carePlanStore];
    viewController.progressRingTintColor = [UIColor purpleColor];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)symptomTrackerViewController:(OCKSymptomTrackerViewController *)viewController didSelectRowWithAssessmentEvent:(OCKCarePlanEvent *)assessmentEvent{
    NSDictionary* userInfo = assessmentEvent.activity.userInfo;
    if (userInfo ) {
        ORKOrderedTask* task = userInfo[@"ORKTask"];
        if (task) {
            ORKTaskViewController* viewController = [[ORKTaskViewController alloc] initWithTask:task taskRunUUID:nil];
            [self presentViewController:viewController animated:YES completion:nil];
        }
    }
}

@end









