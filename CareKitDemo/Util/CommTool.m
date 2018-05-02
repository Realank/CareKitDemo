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

+ (NSDateComponents*)dateBeforeDays:(NSInteger)days{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate *before = [NSDate dateWithTimeIntervalSinceNow:(-3600 * 24 * days)];
    NSDateComponents* dateComponents = [calendar components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:before];
    return dateComponents;
}

+ (NSDateComponents*)currentDate{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* now = [NSDate date];
    NSDateComponents* currentDate = [calendar components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    return currentDate;
}

+ (OCKDocument*)generateSampleDocument{
    OCKDocumentElementSubtitle* subtitle = [[OCKDocumentElementSubtitle alloc] initWithSubtitle:@"sample"];
    OCKDocumentElementParagraph* paragraph = [[OCKDocumentElementParagraph alloc] initWithContent:@"Hello world"];
    OCKDocument* doc = [[OCKDocument alloc] initWithTitle:@"Document" elements:@[subtitle,paragraph]];
    doc.pageHeader = @"Developed By Realank";
    return doc;
}

//获取Documents目录
+(NSString *)documentDirectory{
    //[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return documentsDirectory;
}

@end
