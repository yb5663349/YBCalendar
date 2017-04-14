//
//  NSObject+Date.h
//  日历
//
//  Created by 易彬 on 17/4/11.
//  Copyright © 2017年 易彬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Date)
/**
 比较两个日期的大小
 
 @param aDate A日期
 @param bDate B日期
 @return 大小
 */
- (NSInteger)compareDate:(NSString *)aDate withDate:(NSString *)bDate;
/**
 判断是否是同一个月

 @param dateStr 日期字符串
 @return Yes or No
 */
- (BOOL)isSameMonthWithDateStr:(NSString *)dateStr;

@end
