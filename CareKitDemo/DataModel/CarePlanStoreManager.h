//
//  CarePlanStroreManager.h
//  CareKitDemo
//
//  Created by Realank on 2018/1/23.
//  Copyright © 2018年 iMooc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarePlanStoreManager : NSObject

@property (nonatomic, strong) OCKCarePlanStore* carePlanStore;
@property (nonatomic, strong) OCKPatient* patient;
@property (nonatomic, strong) NSArray<OCKContact*>* contacts;
+(instancetype) sharedInstance;

@end
