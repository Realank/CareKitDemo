//
//  IHLSDKDeviceInfo.h
//  iHealthLayeredApp
//
//  Created by daiqingquan on 2017/4/25.
//  Copyright © 2017年 iHealthlabs. All rights reserved.
//

#ifndef IHLSDKDeviceInfo_h
#define IHLSDKDeviceInfo_h

#define RESULT_KEY_SYSTOLIC         @"systolic"         // integer
#define RESULT_KEY_DIASTOLIC        @"diastolic"        // integer
#define RESULT_KEY_ARRHYTHMIA       @"arrhythmia"       // 0/1
#define RESULT_KEY_Date             @"measured_at"      // string, UTC time, in format yyyy-MM-dd-HH-mm-ss
#define RESULT_BLOOD_GLUCOSE        @"blood_glucose"    // float
#define RESULT_KEY_TEMPERATURE      @"temperature"      // float
#define RESULT_KEY_WEIGHT           @"weight"           // float

#define RESULT_KEY_OXYGEN_SAT       @"oxygen_saturation"   // integer
#define RESULT_KEY_PERFUSION_INDEX  @"perfusion_index"     // float
#define RESULT_KEY_HEART_RATE       @"heart_rate"          // integer


//device model
typedef NS_ENUM(NSUInteger, IHLDeviceType) {
    IHLDeviceType_Unknown = 0,
    IHLDeviceType_BP5,
    IHLDeviceType_BP3L,
    IHLDeviceType_BPTRACK,
    IHLDeviceType_BP7S,
    IHLDeviceType_BP7,
    IHLDeviceType_PO3,
    IHLDeviceType_BG5,
    IHLDeviceType_BG5S,
    IHLDeviceType_BG1,
    IHLDeviceType_HS4,
    IHLDeviceType_HS4S,
    IHLDeviceType_HS2,
    IHLDeviceType_THV3,
    IHLDeviceType_AM3S,
    IHLDeviceType_AM4,
    IHLDeviceType_ECG3,
    IHLDeviceType_ECG3USB,
    IHLDeviceType_Max
};

//operation type(command)
typedef NS_ENUM(NSUInteger, IHLAction) {
    IHLActionUnknown = 0,
    IHLActionMeasureData,      //measure data(NA for KN550BT/BP7S)
    IHLActionAddDevice,        //add device only(scan device and return mac address)
    IHLActionSyncData,         //sync history data(NA for BP3L)
    IHLActionSyncMeasure,      //sync history data + measure data(NA for KN550BT/BP7S)
    IHLActionMax                   //
};

//unit type
typedef NS_ENUM(NSUInteger, IHLVitalUnit) {
    IHLUnitNA = 0,
    IHLBGUnitMMOLL,    //0 mmol/L
    IHLBGUnitMGDL,         //1 mg/dL
    IHLBPUnitMMHG,         //2 mmHg
    IHLBPUnitKPA,          //3 Kpa
    IHLWeightUnitKG,       //4 kg
    IHLWeightUnitLBS,      //5 lbs
    IHLWeightUnitSTONE,       //6 st
    IHLThermoUnitC,            //7 celsius
    IHLThermoUnitF,            //8 fahrenheit
    IHLAMUnitMile,             //9 mile
    IHLAMUnitKilometer,        //10 kilometer
    IHLUnitMax
};

//result status of each operation
typedef NS_ENUM(NSUInteger, IHLResultStatus) {
    IHLResultNA = 0,
    IHLResultSuccess,
    IHLResultFailed,
    IHLResultCanceled,
};

//device add type
typedef NS_ENUM(NSUInteger, IHLAddDeviceType) {
    IHLAddDeviceUnknown = 0,
    IHLAddDeviceWithScan,//scan
    IHLAddDeviceWithQR,//Qr code
    IHLAddDeviceWithMAC,//mac address
    IHLAddDeviceMax
};

// BG strip type
typedef enum {
    IHLBGStripGOD,//GOD
    IHLBGStripGDH,//GDH
} IHLBGStripType;
#endif /* IHLSDKDeviceInfo_h */
