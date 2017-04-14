//
//  YBCalendarView.h
//  日历
//
//  Created by 易彬 on 17/4/6.
//  Copyright © 2017年 易彬. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 日历View的代理，主要是月份View的出现需要执行的逻辑
 和点击某日需要执行的逻辑
 */
@protocol YBCalendarViewDelegate <NSObject>

- (void)YBCalendarViewNewMonthAppear:(NSUInteger)year month:(NSUInteger)month;
- (void)YBCalendarViewDayClick:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;

@end

@interface YBCalendarView : UIView
/**
 代理
 */
@property (nonatomic, weak) id<YBCalendarViewDelegate>delegate;
/**
 显示日期LiteView
 */
@property (nonatomic, assign) BOOL showDayLiteView;
- (void)reloadImpotantDateData;

@end
