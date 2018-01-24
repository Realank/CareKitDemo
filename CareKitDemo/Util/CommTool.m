//
//  CommTool.m
//  CareKitDemo
//
//  Created by Realank on 2018/1/24.
//  Copyright © 2018年 iMooc. All rights reserved.
//

#import "CommTool.h"

@implementation CommTool

+ (NSDateComponents*)firstDateOfCurrentWeek{
    NSDate *beginningOfWeek = nil;
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    gregorian.locale = [NSLocale currentLocale];
    [gregorian rangeOfUnit:NSCalendarUnitWeekOfYear startDate:&beginningOfWeek interval:nil forDate:[NSDate date]];
    NSDateComponents* dateComponents = [gregorian components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:beginningOfWeek];
    return dateComponents;
}

+ (NSDateComponents*)currentDate{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* now = [NSDate date];
    NSDateComponents* currentDate = [calendar components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    return currentDate;
}

@end
