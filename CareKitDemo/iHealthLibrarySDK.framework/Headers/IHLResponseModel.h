//
//  IHLResponseModel.h
//  iHealthLibrarySDK
//
//  Created by Realank on 2017/10/27.
//  Copyright © 2017年 iHealth. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 we will retrun result with this model
 */
@interface IHLResponseModel : NSObject

@property (assign, nonatomic) IHLAction action;//request action
@property (assign, nonatomic) IHLDeviceType deviceType;//request device type
@property (copy,nonatomic) NSString* mac;//request mac address or mac address which we scaned
@property (assign,nonatomic) IHLVitalUnit unit;//request unit
@property (assign, nonatomic) IHLAddDeviceType deviceAddType;//request add type
@property (copy,nonatomic) NSString* errorReason;//operation error reason(if error)
@property (assign,nonatomic) IHLResultStatus addStatus;//add device status
@property (assign,nonatomic) IHLResultStatus syncStatus;//sync data status
@property (assign,nonatomic) IHLResultStatus measureStatus;//measure status
@property (strong,nonatomic) NSArray* syncResult;//sync result
@property (strong,nonatomic) NSArray* measureResult;//measure result
@property (copy, nonatomic) NSNumber *bmr;

@end
