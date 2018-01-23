//
//  HomeViewController.m
//  CareKitDemo
//
//  Created by Realank on 2018/1/23.
//  Copyright © 2018年 iMooc. All rights reserved.
//

#import "HomeViewController.h"
#import "CareDataModel.h"
#import "CarePlanStroreManager.h"
@interface HomeViewController ()<OCKCareContentsViewControllerDelegate,ORKTaskViewControllerDelegate>

@property (nonatomic, weak) OCKCareContentsViewController* careContentsViewController;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewControllers = @[
                             [[UINavigationController alloc] initWithRootViewController:[self careContentsViewController]]
                             ];
}

#pragma mark - getters
- (OCKCarePlanStore*)carePlanStore{
    return [CarePlanStroreManager sharedInstance].carePlanStore;
}

- (OCKCareContentsViewController *)careContentsViewController{
    if (!_careContentsViewController) {
        OCKCareContentsViewController* vc = [[OCKCareContentsViewController alloc] initWithCarePlanStore:[self carePlanStore]];
        vc.glyphTintColor = [UIColor purpleColor];
        vc.title = @"Care Contents";
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:vc.title
                                                      image:[UIImage imageNamed:@"carecard"] selectedImage:[UIImage imageNamed:@"carecard-filled"]];
        vc.delegate = self;
        _careContentsViewController = vc;
        return vc;
    }
    return _careContentsViewController;
}

- (NSString*)stringWithNumArray:(NSArray<NSNumber*>*)array{
    if (array.count == 0) {
        return @"";
    }
    NSMutableString* string = [NSMutableString stringWithFormat:@"%@",array.firstObject];
    for (int i = 1; i < array.count; i++) {
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
                
                OCKCarePlanEventResult* eventResult = [[OCKCarePlanEventResult alloc] initWithValueString:[self stringWithNumArray:numbericResultsM] unitString:unit userInfo:nil];
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
        if (task) {
            ORKTaskViewController* viewController = [[ORKTaskViewController alloc] initWithTask:task taskRunUUID:nil];
            viewController.delegate = self;
            [self presentViewController:viewController animated:YES completion:nil];
            
        }
    }
}


@end
