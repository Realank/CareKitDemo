//
//  CommTool.h
//  CareKitDemo
//
//  Created by Realank on 2018/1/24.
//  Copyright © 2018年 iMooc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define kBPTintColor (UIColorFromRGB(0x3366ff))
#define kBGTintColor (UIColorFromRGB(0x333ccff))
#define kTHTintColor (UIColorFromRGB(0x6badff))

@interface CommTool : NSObject

+ (NSDateComponents*)firstDateOfCurrentWeek;
+ (NSDateComponents*)dateBeforeDays:(NSInteger)days;
+ (NSDateComponents*)currentDate;
+ (OCKDocument*)generateSampleDocument;
+ (NSString *)documentDirectory;
@end
