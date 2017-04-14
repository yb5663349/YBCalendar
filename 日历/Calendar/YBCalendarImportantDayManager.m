//
//  YBCalendarImportantDayManager.m
//  日历
//
//  Created by 易彬 on 17/4/10.
//  Copyright © 2017年 易彬. All rights reserved.
//

#import "YBCalendarImportantDayManager.h"

@implementation YBCalendarImportantDayManager

- (void)setImportantDaysArray:(NSArray *)importantDaysArray
{
    _importantDaysArray = importantDaysArray;
}

+ (instancetype)shareManager
{
    static YBCalendarImportantDayManager * manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[self alloc] init];
    });
    return manager;
}


@end
