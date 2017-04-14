//
//  YBCalendarGenerator.m
//  日历
//
//  Created by 易彬 on 17/4/8.
//  Copyright © 2017年 易彬. All rights reserved.
//

#import "YBCalendarGenerator.h"
#define YBCALENDAR_SECOND_PER_DAY (24 * 60 * 60)

@implementation YBCalendarGenerator

- (NSDictionary *)calendarMapWith:(NSString *)dateStr
{
    
    NSMutableDictionary * mdic = [NSMutableDictionary dictionary];
    NSMutableArray * dateArr = [NSMutableArray array];
    NSCalendar * cal = [NSCalendar currentCalendar];
    NSDate * curDate = [self dateFromMonthString:dateStr];
    NSRange days = [cal rangeOfUnit:NSCalendarUnitDay
                             inUnit:NSCalendarUnitMonth
                            forDate:curDate];
    
    NSDateComponents * firstDayOfMonth = [self componentOfDate:curDate calendar:cal];
    firstDayOfMonth.day=1;
    NSDate * fdate = [cal dateFromComponents:firstDayOfMonth];
    firstDayOfMonth = [self componentOfDate:fdate calendar:cal];
    /**************************************************/
    /* 从周日开始就可以把下面的注释打开,并去掉               */
    /* NSInteger weekGap = firstDayOfMonth.weekday-2; */
    /* if (weekGap < 1) weekGap+=7;                   */
    /**************************************************/
    
//    if (firstDayOfMonth.weekday != 1) {
//
//        NSInteger weekGap = firstDayOfMonth.weekday-1;
//        if (weekGap < 0) weekGap+=7;

        NSInteger weekGap = firstDayOfMonth.weekday-2;
        if (weekGap < 1) weekGap+=7;
        
        NSDate * firstDate = [fdate dateByAddingTimeInterval:-YBCALENDAR_SECOND_PER_DAY*weekGap];
        NSDateComponents * firstComponent = [self componentOfDate:firstDate calendar:cal];
        
        for (int i=0; i<weekGap; i++) {
            
            NSMutableDictionary * item = [NSMutableDictionary dictionary];
            NSString * dateStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)firstComponent.year,(long)firstComponent.month,(long)firstComponent.day];
            [item setObject:dateStr forKey:@"dateStr"];
            [item setObject:[NSString stringWithFormat:@"-%zd",firstComponent.day] forKey:@"day"];
            firstComponent.day++;
            [dateArr addObject:item];
        }
//    }
    
    NSDateComponents * curComponents = [self componentOfDate:curDate calendar:cal];
    [mdic setObject:[NSString stringWithFormat:@"%ld年%ld月",(long)curComponents.year,(long)curComponents.month] forKey:@"monthStr"];
    
    for (int i=1; i<=days.length; i++) {
        
        NSMutableDictionary * item = [NSMutableDictionary dictionary];
        curComponents.day = i;
        NSString * dateStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)(curComponents.year),(long)curComponents.month,(long)i];
        [item setObject:dateStr forKey:@"dateStr"];
        [item setObject:[NSString stringWithFormat:@"%zd",i] forKey:@"day"];
        [dateArr addObject:item];
    }
    
    NSDateComponents * lastDayOfMonth = [self componentOfDate:curDate calendar:cal];
    lastDayOfMonth.day = days.length;
    NSDate * ldate = [cal dateFromComponents:lastDayOfMonth];
    lastDayOfMonth = [self componentOfDate:ldate calendar:cal];
    
    if (lastDayOfMonth.weekday != 0 || dateArr.count < 42) {
        
        NSInteger weekGap = 8-lastDayOfMonth.weekday;
        NSDate * lastDate = [ldate dateByAddingTimeInterval:YBCALENDAR_SECOND_PER_DAY*weekGap];
        NSDateComponents * lastComponent = [self componentOfDate:lastDate calendar:cal];
        
        for (int i=1; i<=weekGap; i++) {
            
            NSMutableDictionary * item = [NSMutableDictionary dictionary];
            NSString * dateStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)lastComponent.year,(long)lastComponent.month,(long)i];
            [item setObject:dateStr forKey:@"dateStr"];
            [item setObject:[NSString stringWithFormat:@"-%zd",i] forKey:@"day"];
            lastComponent.day = i;
            [dateArr addObject:item];
        }
        
        if (dateArr.count < 42) {
            
            NSInteger leftCount = 42 - dateArr.count;
            
            for (NSInteger i=weekGap+1; i<=weekGap+leftCount; i++) {
                
                NSMutableDictionary * item = [NSMutableDictionary dictionary];
                NSString * dateStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)lastComponent.year,(long)lastComponent.month,(long)i];
                [item setObject:dateStr forKey:@"dateStr"];
                [item setObject:[NSString stringWithFormat:@"-%zd",i] forKey:@"day"];
                lastComponent.day = i;
                
                [dateArr addObject:item];
                if(dateArr.count>42){
                    break;
                }
            }
        }
    }
    
    
    [mdic setObject:[dateArr copy] forKey:@"dataArr"];
    return [mdic copy];
}

- (NSDate *)dateFromMonthString:(NSString *)dateStr
{
    dateStr = [dateStr stringByAppendingString:@"01"];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月dd"];
    NSDate* date=[format dateFromString:dateStr];
    return date;
}

- (NSDateComponents *)componentOfDate:(NSDate *)date calendar:(NSCalendar *)calendar
{
    NSDateComponents* com=[calendar components: NSCalendarUnitWeekday|NSCalendarUnitYear|NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
    com.hour=0;
    com.minute=0;
    com.second=0;
    return com;
}


- (NSArray *)calendarLiteListWithDateStr:(NSString *)dateStr
                                     row:(NSUInteger)row
{
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月dd"];
    NSDate * date = [format dateFromString:dateStr];
    
    NSCalendar * cal = [NSCalendar currentCalendar];
    NSDateComponents * comp = [cal components:NSCalendarUnitWeekday|NSCalendarUnitYear|NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
    [comp setDay:[comp day] + row*7];
    
    NSDate * NewDate = [cal dateFromComponents:comp];
    comp = [cal components: NSCalendarUnitWeekday|NSCalendarUnitYear|NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:NewDate];
    
    // 获取今天是周几
    NSInteger kWeekDay = [comp weekday];
    // 获取几天是几号
    NSInteger kDay = [comp day];
    
    NSInteger one,two,three,four,five,six,seven;
    
    if (kWeekDay == 1) {
        
        one = -6;
        two = -5;
        three = -4;
        four = -3;
        five = -2;
        six = -1;
        seven = 0;
        
    } else {
        
        one = [cal firstWeekday] - kWeekDay + 1;
        two = one + 1;
        three = one + 2;
        four = one + 3;
        five = one + 4;
        six = one + 5;
        seven = one + 6;
    }
    
    NSArray * arr = @[@(one),@(two),@(three),@(four),@(five),@(six),@(seven)];
    NSMutableArray * dayList = [NSMutableArray array];
    
    for (int i=0; i<arr.count; i++)
    {
        NSInteger value = [arr[i] integerValue];
        
        // 在当前日期(去掉时分秒)基础上加上差的天数
        NSDateComponents * kComp = [cal components: NSCalendarUnitWeekday|NSCalendarUnitYear|NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:NewDate];
        [kComp setDay:kDay + value];
        NSDate * firstDayOfWeek = [cal dateFromComponents:kComp];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年MM月dd"];
        NSString * firstDay = [formatter stringFromDate:firstDayOfWeek];
        [dayList addObject:firstDay];
    }
    
    return dayList;
}


@end
