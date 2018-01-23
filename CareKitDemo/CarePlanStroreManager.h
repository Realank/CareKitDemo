//
//  CarePlanStroreManager.h
//  CareKitDemo
//
//  Created by Realank on 2018/1/23.
//  Copyright © 2018年 iMooc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CareDataModel.h"

@interface CarePlanStroreManager : NSObject

@property (nonatomic, strong) OCKCarePlanStore* carePlanStore;

+(instancetype) sharedInstance;

@end
