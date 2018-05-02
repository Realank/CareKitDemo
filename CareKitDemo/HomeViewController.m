//
//  HomeViewController.m
//  CareKitDemo
//
//  Created by Realank on 2018/1/23.
//  Copyright © 2018年 iMooc. All rights reserved.
//

#import "HomeViewController.h"
#import "GraphTableViewController.h"
#import "CareDataModel.h"
#import "CarePlanStoreManager.h"
#import "InsightsBuilder.h"
@interface HomeViewController ()<OCKCareContentsViewControllerDelegate,ORKTaskViewControllerDelegate,InsightBuilderUpdateInsightsDelegate,OCKConnectViewControllerDelegate,IHLRequestDelegate>

@property (nonatomic, weak) OCKCareContentsViewController* careContentsViewController;
@property (nonatomic, weak) OCKInsightsViewController* insightsViewController;
@property (nonatomic, weak) OCKConnectViewController* connectViewController;
@property (nonatomic, weak) GraphTableViewController* graphViewController;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewControllers = @[
                             [[UINavigationController alloc] initWithRootViewController:self.careContentsViewController],
                             [[UINavigationController alloc] initWithRootViewController:self.graphViewController],
//                             [[UINavigationController alloc] initWithRootViewController:self.insightsViewController],
                             [[UINavigationController alloc] initWithRootViewController:self.connectViewController]
                             ];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[InsightsBuilder sharedInstance] updateInsights];
}

#pragma mark - getters
- (OCKCarePlanStore*)carePlanStore{
    return [CarePlanStoreManager sharedInstance].carePlanStore;
}

- (OCKCareContentsViewController *)careContentsViewController{
    if (!_careContentsViewController) {
        OCKCareContentsViewController* vc = [[OCKCareContentsViewController alloc] initWithCarePlanStore:[self carePlanStore]];
        vc.glyphTintColor = UIColorFromRGB(0xed3f3f);
        vc.glyphType = OCKGlyphTypeHeart;
        vc.title = @"Care Contents";
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:vc.title
                                                      image:[UIImage imageNamed:@"carecard"] selectedImage:[UIImage imageNamed:@"carecard-filled"]];
        vc.delegate = self;
        _careContentsViewController = vc;
        return vc;
    }
    return _careContentsViewController;
}

- (OCKInsightsViewController *)insightsViewController{
    if (!_insightsViewController) {
        OCKPatientWidget* widget1 = [OCKPatientWidget defaultWidgetWithActivityIdentifier:kActivityIdentifierBP tintColor:[UIColor redColor]];
        OCKPatientWidget* widget2 = [OCKPatientWidget defaultWidgetWithActivityIdentifier:kActivityIdentifierBG tintColor:[UIColor redColor]];
        OCKPatientWidget* widget3 = [OCKPatientWidget defaultWidgetWithActivityIdentifier:kActivityIdentifierTH tintColor:[UIColor redColor]];
        OCKInsightsViewController* vc = [[OCKInsightsViewController alloc] initWithInsightItems:[InsightsBuilder sharedInstance].insights patientWidgets:@[widget1,widget2,widget3] thresholds:nil store:[self carePlanStore]];
        vc.title = @"Insights";
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:vc.title
                                                      image:[UIImage imageNamed:@"insights"] selectedImage:[UIImage imageNamed:@"insights-filled"]];
        _insightsViewController = vc;
        return vc;
    }
    return _insightsViewController;
}

- (OCKConnectViewController*)connectViewController{
    if (!_connectViewController) {
        OCKConnectViewController* vc = [[OCKConnectViewController alloc] initWithContacts:[CarePlanStoreManager sharedInstance].contacts patient:[CarePlanStoreManager sharedInstance].patient];
        vc.delegate = self;
//        vc.dataSource = self;
        vc.title = @"Connect";
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:vc.title
                                                      image:[UIImage imageNamed:@"connect"] selectedImage:[UIImage imageNamed:@"connect-filled"]];
        _connectViewController = vc;
        return vc;
    }
    return _connectViewController;
    
}

- (GraphTableViewController *)graphViewController{
    if (!_graphViewController) {
        GraphTableViewController* vc = [[GraphTableViewController alloc] init];
        _graphViewController = vc;
        vc.title = @"Graphs";
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:vc.title
                                                      image:[UIImage imageNamed:@"graphTab"] selectedImage:[UIImage imageNamed:@"graphTab"]];
        return vc;
    }
    return _graphViewController;
    
}

- (NSString*)stringWithNumArray:(NSArray<NSNumber*>*)array{
    if (array.count == 0) {
        return @"";
    }
    NSMutableString* string = [NSMutableString stringWithFormat:@"%@",array.firstObject];
    for (int i = 1; i < array.count && i < 2; i++) {
        [string appendFormat:@"/%@",array[i]];
    }
    return [string copy];
}
#pragma mark - delegates
//ORKTaskViewControllerDelegate
- (void)taskViewController:(ORKTaskViewController *)taskViewController didFinishWithReason:(ORKTaskViewControllerFinishReason)reason error:(NSError *)error{
    
    if (reason == ORKTaskViewControllerFinishReasonCompleted) {
        OCKCarePlanEvent* event = [self careContentsViewController].lastSelectedEvent;
        if(event){
            ORKStepResult* firstResult = (ORKStepResult*)taskViewController.result.firstResult;
            NSMutableArray* numbericResultsM = [NSMutableArray array];
            for (ORKResult* stepResult in firstResult.results) {
                ORKNumericQuestionResult* numbericResult = (ORKNumericQuestionResult*) stepResult;
                NSNumber* answer = numbericResult.numericAnswer;
                if (answer) {
                    [numbericResultsM addObject:answer];
                }
            }
            NSString* unit = @"";
            ORKStepResult* firstStepResult = (ORKStepResult*)firstResult.results.firstObject;
            if([firstStepResult isKindOfClass:ORKNumericQuestionResult.class]){
                unit = ((ORKNumericQuestionResult*)firstStepResult).unit;
            }
            if (numbericResultsM.count) {
                NSString* valueString = [self stringWithNumArray:numbericResultsM];
                OCKCarePlanEventResult* eventResult = [[OCKCarePlanEventResult alloc]       initWithValueString:valueString
                                                                                unitString:unit
                                                                                userInfo:@{
                                                                                     @"date":event.date,
                                                                                     @"values":[numbericResultsM copy],
                                                                                     @"type":event.activity.userInfo[@"type"],
                                                                                     @"unit":unit,
                                                                                     @"valueString":valueString,
                                                                                           }
                                                                                values:nil];
                [[self carePlanStore] updateEvent:event withResult:eventResult state:OCKCarePlanEventStateCompleted completion:^(BOOL success, OCKCarePlanEvent * _Nullable event, NSError * _Nullable error) {
                    if(!success){
                        NSLog(@"Error:%@",error.localizedDescription);
                    }
                }];
            }
        }
        
    }
    [taskViewController dismissViewControllerAnimated:YES completion:nil];
}
//OCKCareContentsViewControllerDelegate
- (void)careContentsViewController:(OCKCareContentsViewController *)viewController didSelectRowWithAssessmentEvent:(OCKCarePlanEvent *)assessmentEvent{
    NSDictionary* userInfo = assessmentEvent.activity.userInfo;
    if (userInfo ) {
        id<ORKTask> task = userInfo[@"ORKTask"];
        NSString* type = userInfo[@"type"];
        NSLog(@"performing new task: %@",type);
//        if (task) {
//            ORKTaskViewController* viewController = [[ORKTaskViewController alloc] initWithTask:task taskRunUUID:nil];
//            viewController.delegate = self;
//            [self presentViewController:viewController animated:YES completion:nil];
//
//        }
//        return;
        IHLVitalUnit unit =  IHLUnitNA;
        IHLDeviceType deviceType =  IHLDeviceType_Unknown;
        if ([type isEqualToString:@"bp"]) {
            unit = IHLBPUnitMMHG;
            deviceType = IHLDeviceType_BP3L;
        }else if ([type isEqualToString:@"bg"]) {
            unit = IHLBGUnitMGDL;
            deviceType = IHLDeviceType_BG5;
        }else if ([type isEqualToString:@"th"]) {
            unit = IHLThermoUnitC;
            deviceType = IHLDeviceType_THV3;
        }
        [IHLRequestModel configModelWithAction:IHLActionMeasureData addMethod:IHLAddDeviceWithScan forDevice:deviceType withMac:@"" unit:unit stripTypeIfBG:IHLBGStripGOD godCodeIfBG:@"02396264396214322D1200A02B2A638EDA14428894E61901238305E712BC" shouldPopAlertView:YES userIDIfAM:@(325243) userSexIfAM:IHLUserSex_Female userAgeIfAM:23 userHeightIfAM:170 userWeightIfAM:60 swimFlagIfAM:NO skipBP7AngleCheck:NO];
        [[IHLRequestModel sharedInstance] requestOpertationWithDelegate:self withAnimation:YES];
    }
}
- (void)careContentsViewController:(OCKCareContentsViewController *)viewController didSelectButtonWithInterventionEvent:(OCKCarePlanEvent *)interventionEvent{
    [[CarePlanStoreManager sharedInstance].carePlanStore updateEvent:interventionEvent withResult:nil state:OCKCarePlanEventStateCompleted completion:^(BOOL success, OCKCarePlanEvent * _Nullable event, NSError * _Nullable error) {
        [[InsightsBuilder sharedInstance] updateInsights];
    }];
    
}
//- (BOOL)careContentsViewController:(OCKCareContentsViewController *)viewController shouldHandleEventCompletionForInterventionActivity:(OCKCarePlanActivity *)interventionActivity{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [[InsightsBuilder sharedInstance] updateInsights];
//    });
//    return YES;
//}

- (void)iHLResponseWithResult:(IHLResponseModel*)result{
    NSLog(@"sync result%@",result.syncResult);
    NSLog(@"measure result%@",result.measureResult);
    OCKCarePlanEvent* event = [self careContentsViewController].lastSelectedEvent;
    if(event && result.measureStatus == IHLResultSuccess && result.measureResult.count == 1){
        NSArray* values = @[];
        NSString* valueString = @"";
        NSString* unit = @"";
        NSString* eventType = (NSString*)event.activity.userInfo[@"type"];
        if (result.deviceType == IHLDeviceType_THV3 && [eventType isEqualToString:@"th"]) {
            NSDictionary* measureResult = result.measureResult.firstObject;
            values = @[@([measureResult[@"temperature"] floatValue])];
            valueString = [values.firstObject stringValue];
            unit = @"degC";
        }else if (result.deviceType == IHLDeviceType_BP3L && [eventType isEqualToString:@"bp"]) {
            NSDictionary* measureResult = result.measureResult.firstObject;
            NSInteger sys = [measureResult[@"systolic"] integerValue];
            NSInteger dia = [measureResult[@"diastolic"] integerValue];
            values = @[@(sys),@(dia)];
            valueString = [NSString stringWithFormat:@"%ld/%ld",sys,dia];
            unit = @"mmHg";
        }else if (result.deviceType == IHLDeviceType_BG5 && [eventType isEqualToString:@"bg"]) {
            NSDictionary* measureResult = result.measureResult.firstObject;
            values = @[@([measureResult[@"blood_glucose"] floatValue])];
            valueString = [values.firstObject stringValue];
            unit = @"mg/dL";
        }
        
        if (values.count == 0) {
            return;
        }
        OCKCarePlanEventResult* eventResult = [[OCKCarePlanEventResult alloc] initWithValueString:valueString
                                                                                        unitString:unit
                                                                                          userInfo:@{
                                                                                                     @"date":event.date,      @"values":values,                   @"type":eventType,
                                                                            @"unit":unit,              @"valueString":valueString,
                                                                                                     }
                                                                                            values:nil];
        [[self carePlanStore] updateEvent:event withResult:eventResult state:OCKCarePlanEventStateCompleted completion:^(BOOL success, OCKCarePlanEvent * _Nullable event, NSError * _Nullable error) {
            if(!success){
                NSLog(@"Error:%@",error.localizedDescription);
            }
        }];
    }
}

- (void)insightBuilderDidUpdatedInsights{
    self.insightsViewController.items = [InsightsBuilder sharedInstance].insights;
    NSLog(@"insights updated");
}

- (void)connectViewController:(OCKConnectViewController *)connectViewController didSelectShareButtonForContact:(OCKContact *)contact presentationSourceView:(nullable UIView *)sourceView{
    OCKDocument* doc = [CommTool generateSampleDocument];
    [doc createPDFDataWithCompletion:^(NSData * _Nonnull PDFdata, NSError * _Nullable error) {
        UIActivityViewController* vc = [[UIActivityViewController alloc] initWithActivityItems:@[PDFdata] applicationActivities:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:vc animated:YES completion:nil];
        });
    }];
}


@end
