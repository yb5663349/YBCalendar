//
//  YBCalendarGenerator.h
//  日历
//
//  Created by 易彬 on 17/4/8.
//  Copyright © 2017年 易彬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBCalendarGenerator : NSObject
/**
 根据月份生成日历表

 @param dateStr 年月份
 @return 日历表
 */
- (NSDictionary *)calendarMapWith:(NSString *)dateStr;
/**
 根据年月日生成精简日历每个Cell的数据数组

 @param dateStr 日期
 @param row 第几组
 @return 数组
 */
- (NSArray *)calendarLiteListWithDateStr:(NSString *)dateStr
                                     row:(NSUInteger)row;

@end
