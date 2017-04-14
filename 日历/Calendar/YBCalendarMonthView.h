//
//  YBCalendarMonthView.h
//  日历
//
//  Created by 易彬 on 17/4/7.
//  Copyright © 2017年 易彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBCalendarMonthViewDelegate <NSObject>
- (void)YBCalendarMonthChange:(NSString *)dateStr;
@end

@interface YBCalendarMonthView : UIView
/**
 下一个月动画
 */
- (void)nextMonthAnimation;
/**
 上一个月动画
 */
- (void)previousMonthAnimation;
/**
 跨月份动画

 @param spanDateStr 跨度后的日期
 */
- (void)spanMonthAnimation:(NSString *)spanDateStr;
/**
 当前月份 <只读>
 */
@property (nonatomic, copy, readonly) NSString * currentDateStr;
/**
 代理
 */
@property (nonatomic, weak) id<YBCalendarMonthViewDelegate>delegate;

@end
