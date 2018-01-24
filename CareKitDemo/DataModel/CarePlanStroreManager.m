//
//  CarePlanStroreManager.m
//  CareKitDemo
//
//  Created by Realank on 2018/1/23.
//  Copyright © 2018年 iMooc. All rights reserved.
//

#import "CarePlanStroreManager.h"


@implementation CarePlanStroreManager

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
        //创建健康数据存储路径
        NSURL* documentDir = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
        NSURL* storeURL = [documentDir URLByAppendingPathComponent:@"CarePlanStore"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:storeURL.path]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:storeURL.path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        _carePlanStore = [[OCKCarePlanStore alloc] initWithPersistenceDirectoryURL:storeURL];
        
        //添加活动
        for (OCKCarePlanActivity* activityToAdd in [CareDataModel sharedInstance].activities) {
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
    return self;
}

@end
