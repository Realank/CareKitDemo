//
//  InsightsBuilder.h
//  CareKitDemo
//
//  Created by Realank on 2018/1/23.
//  Copyright © 2018年 iMooc. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol InsightBuilderUpdateInsightsDelegate

- (void)insightBuilderDidUpdatedInsights;
@end

@interface InsightsBuilder : NSObject

@property (nonatomic, strong) NSArray<OCKInsightItem*>* insights;
@property (nonatomic, strong) NSMutableDictionary* practiceProportionM;
@property (nonatomic, strong) NSMutableArray* datesM;
@property (nonatomic, strong) NSMutableArray* dateStrings;
@property (nonatomic, strong) NSMutableArray* completionsM;
@property (nonatomic, strong) NSMutableArray* completionsLabelM;
@property (nonatomic, strong) NSMutableArray* temperatureValues;
@property (nonatomic, strong) NSMutableArray* bpSysValues;
@property (nonatomic, strong) NSMutableArray* bpDiaValues;
@property (nonatomic, strong) NSMutableArray* bgValues;

@property (nonatomic, weak) id<InsightBuilderUpdateInsightsDelegate> delegate;
+(instancetype) sharedInstance;
- (void)updateInsights;
@end
