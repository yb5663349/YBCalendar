//
//  NSObject+Date.m
//  日历
//
//  Created by 易彬 on 17/4/11.
//  Copyright © 2017年 易彬. All rights reserved.
//

#import "NSObject+Date.h"

@implementation NSObject (Date)
/**
 比较两个日期的大小
 
 @param aDate A日期
 @param bDate B日期
 @return 大小
 */
- (NSInteger)compareDate:(NSString *)aDate withDate:(NSString *)bDate
{
    NSInteger aa = 0;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy年MM月dd"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    aDate = [[aDate componentsSeparatedByString:@"月"][0] stringByAppendingString:@"月01"];
    bDate = [[bDate componentsSeparatedByString:@"月"][0] stringByAppendingString:@"月01"];
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result == NSOrderedSame) {
        //        相等  aa=0
    } else if (result == NSOrderedAscending) {
        //bDate比aDate大
        aa = -1;
    } else if (result == NSOrderedDescending) {
        //bDate比aDate小
        aa = 1;
    }
    
    return aa;
}

/**
 判断是否是同一个月
 
 @param dateStr 日期字符串
 @return Yes or No
 */
- (BOOL)isSameMonthWithDateStr:(NSString *)dateStr
{
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy年MM月dd"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    NSString * str = [NSString stringWithFormat:@"%@",self];
    dta = [dateformater dateFromString:str];
    dtb = [dateformater dateFromString:dateStr];
    
    NSCalendar * cal = [NSCalendar currentCalendar];
    NSDateComponents * comp1 = [cal components: NSCalendarUnitWeekday|NSCalendarUnitYear|NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:dta];
    NSDateComponents * comp2 = [cal components: NSCalendarUnitWeekday|NSCalendarUnitYear|NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:dtb];
    
    if (comp1.month == comp2.month) {
        return YES;
    }
    
    return NO;
}

@end
