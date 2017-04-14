//
//  YBCalendarImportantDayManager.h
//  日历
//
//  Created by 易彬 on 17/4/10.
//  Copyright © 2017年 易彬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBCalendarImportantDayManager : NSObject
/**
 重要日期管理器单例

 @return 单例
 */
+ (instancetype)shareManager;

@property (nonatomic, strong) NSArray * importantDaysArray;

@end
