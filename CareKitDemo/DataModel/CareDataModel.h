//
//  CareDataModel.h
//  CareKitDemo
//
//  Created by Realank on 2018/1/23.
//  Copyright © 2018年 iMooc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CareKit/CareKit.h>
#import <ResearchKit/ResearchKit.h>


@interface CareDataModel : NSObject

@property (nonatomic, strong) NSArray<OCKCarePlanActivity*>* activities;

+(instancetype) sharedInstance;

@end
