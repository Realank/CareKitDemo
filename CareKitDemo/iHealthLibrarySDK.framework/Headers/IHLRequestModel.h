//
//  ILUrlRequestModel.h
//  iHealthLayeredApp
//
//  Created by Lei Bao on 2017/5/27.
//  Copyright © 2017年 iHealthlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IHLSDKDeviceInfo.h"

#define IHLCOLOR_KEY_NAVIGATION_BAR      @"NavigationBarColor"       //Navigation bar: navigationBar.barTintColor
#define IHLCOLOR_KEY_TITLE               @"TitleColor"               //Navigation Title
#define IHLCOLOR_KEY_BACKBUTTON          @"BackButtonColor"          //Navigation Back
#define IHLCOLOR_KEY_RIGHTBUTTON        @"RightButtonColor"         //Navigation RightButton
#define IHLCOLOR_KEY_SRTARTBUTTON        @"StartButtonColor"         //StartButton
#define IHLCOLOR_KEY_THEME               @"ThemeColor"               //Theme color
#define IHLCOLOR_KEY_LOGOIMAGE           @"LogoImage"                //logo Image

/**
 Authentication result
 */
typedef NS_ENUM(NSUInteger, IHLAuthenResult) {
    IHLAuthen_RegisterSuccess = 1,//New-user registration succeeded
    IHLAuthen_LoginSuccess,// User login succeeded
    IHLAuthen_CombinedSuccess,// The user is iHealth user as well, measurement via SDK has been activated, and the data from the measurement belongs to the user
    IHLAuthen_TrySuccess,//Testing without Internet connection succeeded
    IHLAuthen_InvalidateUserInfo,//Userid/clientID/clientSecret verification failed
    IHLAuthen_SDKInvalidateRight,//SDK has not been authorized
    IHLAuthen_UserInvalidateRight,//User has not been authorized
    IHLAuthen_InternetError,//Internet error, verification failed
    IHLAuthen_AppSecretVerifySuccess, // appsecrect is right
    IHLAuthen_AppSecretVerifyFailed, //appsecrect error
    IHLAuthen_InputError //Input error
};

/**
 Only for AM3S/AM4
 
 - ILUserSex_Female: Female
 - ILUserSex_Male: Male
 */
typedef NS_ENUM(NSUInteger, IHLUserSex) {
    IHLUserSex_Female = 0,
    IHLUserSex_Male = 1,
};


typedef void(^IHLValideResult)(IHLAuthenResult result);

@class IHLResponseModel;


/**
 if you want to get result call back, you should comply this protocol
 */
@protocol IHLRequestDelegate <NSObject>
@required
- (void)iHLResponseWithResult:(IHLResponseModel*)result;
@end


/**
 use this model to request operations
 */
@interface IHLRequestModel : NSObject

@property (nonatomic, assign) BOOL blindResult;

@property (nonatomic, strong) NSDictionary* customColorDictionary;

@property (assign, nonatomic, readonly) IHLAction action;//request action type

@property (assign, nonatomic, readonly) IHLDeviceType deviceType;//device type

@property (copy, nonatomic, readonly) NSString *mac;//device mac address(if you know the mac address, and want to measure/sync directly)

@property (assign, nonatomic, readonly) IHLVitalUnit unit;//unit type(NA for PO3)

//  Properties relationship
//  R is short for "required". NR is short for "not required"
//                  measure             sync                add device
//  action          R                   R                   R
//  deviceType      R                   R                   R
//  mac             R(Only AddTypeMac)  R(Only AddTypeMac)  NR
//  unit            R(except PO3)       R(except PO3)       NR
//  addtype         R                   R                   R
//  godCodeR        R(only BG5)         NR                  NR
//


/**
 validate your app to use Library App

 @param clientID your clientID
 @param appSecret your appSecret
 @param userAccount your userAccount
 @param userValideResultBlock a callback block to return you authen result
 */
+ (void)userValidateWithClientID:(NSString*)clientID
                       appSecret:(NSString *)appSecret
                       userAcount:(NSString*)userAccount
                    resultBlock:(IHLValideResult)userValideResultBlock;





/**
 config request parameters, you can only use this method to initiate this class instance


 @param action request action
 @param addMethod add device type
 @param deviceType device type
 @param macAddress mac address if you know
 @param unit measure/sync unit, NA for PO3
 @param godCode GOD code for BG
 @param popAlertView should confirm popup alert view when adding devices
 @param userID user ID for AM
 @param sex user sex for AM
 @param age user age for AM
 @param height user height for AM
 @param weight user weight for AM
 @param flag swimFlag for AM
 */
+ (void)configModelWithAction:(IHLAction)action
                    addMethod:(IHLAddDeviceType)addMethod
                    forDevice:(IHLDeviceType)deviceType
                      withMac:(NSString*)macAddress
                         unit:(IHLVitalUnit)unit
                 stripTypeIfBG:(IHLBGStripType)bgStripType
                  godCodeIfBG:(NSString*)godCode
           shouldPopAlertView:(BOOL)popAlertView
                   userIDIfAM:(NSNumber *)userID
                  userSexIfAM:(IHLUserSex)sex
                  userAgeIfAM:(NSUInteger)age
               userHeightIfAM:(NSUInteger)height
               userWeightIfAM:(NSUInteger)weight
                 swimFlagIfAM:(BOOL)flag
            skipBP7AngleCheck:(BOOL)skipBP7AngleCheck;


/**
 use this method to get this class instance

 @return this class instance
 */
+ (instancetype)sharedInstance;


/**
 request operation immediately, it will present a page

 @param delegate specify a instance which comply IHLRequestDelegate protocol, to get result
 @param animation show page with animation or not
 */
- (void)requestOpertationWithDelegate:(id<IHLRequestDelegate>)delegate withAnimation:(BOOL)animation;



@end
