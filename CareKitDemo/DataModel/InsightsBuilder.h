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
@property (nonatomic, weak) id<InsightBuilderUpdateInsightsDelegate> delegate;
+(instancetype) sharedInstance;
- (void)updateInsights;
@end
