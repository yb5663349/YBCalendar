//
//  YBCalendarDayView.h
//  日历
//
//  Created by 易彬 on 17/4/7.
//  Copyright © 2017年 易彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBCalendarDayViewDelegate <NSObject>
- (void)YBCalendarDayChange:(NSString *)dateStr;
@end

@interface YBCalendarDayView : UIView
/**
 日期
 */
@property (nonatomic, copy) NSString * dateStr;
/**
 选中日期
 */
@property (nonatomic, copy, readonly) NSString * selectDateStr;
/**
 当前日期
 */
@property (nonatomic, copy, readonly) NSString * currentDateStr;
/**
 代理
 */
@property (nonatomic, weak) id<YBCalendarDayViewDelegate>delegate;
/**
 显示选中的日期

 @param dateStr 选中日期
 */
- (void)showSelectDateStr:(NSString *)dateStr;
- (void)reloadImpotantDateData;

@end
