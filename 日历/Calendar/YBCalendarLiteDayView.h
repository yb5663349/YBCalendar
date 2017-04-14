//
//  YBCalendarLiteDayView.h
//  日历
//
//  Created by 易彬 on 17/4/10.
//  Copyright © 2017年 易彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBCalendarLiteDayViewDelegate <NSObject>
- (void)YBCalendarLiteDayChange:(NSString *)dateStr;
@end

@interface YBCalendarLiteDayView : UIView
/**
 日期
 */
@property (nonatomic, copy) NSString * dateStr;
/**
 选中日期
 */
@property (nonatomic, copy, readonly) NSString * selectDateStr;
/**
 代理
 */
@property (nonatomic, weak) id<YBCalendarLiteDayViewDelegate>delegate;
/**
 显示选中的日期
 
 @param dateStr 选中日期
 */
- (void)showSelectDateStr:(NSString *)dateStr;
- (void)reloadImpotantDateData;

@end
