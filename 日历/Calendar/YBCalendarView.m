//
//  YBCalendarView.m
//  日历
//
//  Created by 易彬 on 17/4/6.
//  Copyright © 2017年 易彬. All rights reserved.
//

#import "YBCalendarView.h"
#import "YBCalendarYearView.h"
#import "YBCalendarMonthView.h"
#import "YBCalendarDayView.h"
#import "YBCalendarLiteDayView.h"
#import "UIColor+expanded.h"
#import "NSObject+Date.h"

@interface YBCalendarView () <YBCalendarMonthViewDelegate,YBCalendarDayViewDelegate,YBCalendarLiteDayViewDelegate>

@property (nonatomic, strong) YBCalendarYearView  * yearView;
@property (nonatomic, strong) UIView              * lineView;
@property (nonatomic, strong) YBCalendarMonthView * monthView;
@property (nonatomic, strong) YBCalendarDayView   * dayView;
@property (nonatomic, strong) YBCalendarLiteDayView * liteView;

@end

@implementation YBCalendarView

#pragma mark - public method
#pragma mark 数据交付
- (void)setShowDayLiteView:(BOOL)showDayLiteView
{
    _showDayLiteView = showDayLiteView;
    self.liteView.hidden = !_showDayLiteView;
    if (self.liteView.hidden) {
        
        [self.dayView showSelectDateStr:self.liteView.selectDateStr];
    } else {
        
        self.liteView.dateStr = self.dayView.currentDateStr;
        [self.liteView showSelectDateStr:self.dayView.selectDateStr];
    }
}

- (void)reloadImpotantDateData
{
    [self.dayView reloadImpotantDateData];
    [self.liteView reloadImpotantDateData];
}

#pragma mark - life cicle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpUI];
        [self setUpLayout];
    }
    return self;
}

#pragma mark - UI
- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.yearView];
    [self addSubview:self.lineView];
    [self addSubview:self.monthView];
    [self addSubview:self.dayView];
    [self addSubview:self.liteView];
}

#pragma mark Layout
- (void)setUpLayout
{
    
}

#pragma mark - YBCalendarMonthViewDelegate
- (void)YBCalendarMonthChange:(NSString *)dateStr
{
//    self.yearView.nextTimeStr = dateStr;
//    self.dayView.dateStr = dateStr;
//    self.liteView.dateStr = self.dayView.currentDateStr;
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式
    [dateFormatter setDateFormat:@"yyyy年MM月dd"];
    
    NSDate * aDate = [dateFormatter dateFromString:self.monthView.currentDateStr];
    NSDate * bDate = [dateFormatter dateFromString:dateStr];
    NSCalendar * gregorian = [NSCalendar currentCalendar];
    NSDateComponents * comps = [gregorian components:NSCalendarUnitMonth fromDate:aDate toDate:bDate options:0];
    
    if ([comps month] == 0) {
        return;
    } else if ([comps month] == 1 || [comps month] == -1) {
        
        if ([self compareDate:self.monthView.currentDateStr withDate:dateStr] == 1) {
            self.yearView.nextTimeStr = dateStr;
            self.dayView.dateStr = dateStr;
            self.liteView.dateStr = self.dayView.currentDateStr;
            [self.monthView previousMonthAnimation];
            
        } else if ([self compareDate:self.monthView.currentDateStr withDate:dateStr] == -1) {
            self.yearView.nextTimeStr = dateStr;
            self.dayView.dateStr = dateStr;
            self.liteView.dateStr = self.dayView.currentDateStr;
            [self.monthView nextMonthAnimation];
        }
        
    } else {
        
        self.yearView.nextTimeStr = dateStr;
        self.dayView.dateStr = dateStr;
        self.liteView.dateStr = self.dayView.currentDateStr;
        [self.monthView spanMonthAnimation:dateStr];
    }
}

#pragma mark - YBCalendarDayViewDelegate
- (void)YBCalendarDayChange:(NSString *)dateStr
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式
    [dateFormatter setDateFormat:@"yyyy年MM月dd"];
    
    NSDate * aDate = [dateFormatter dateFromString:self.monthView.currentDateStr];
    NSDate * bDate = [dateFormatter dateFromString:dateStr];
    NSCalendar * gregorian = [NSCalendar currentCalendar];
    NSDateComponents * comps = [gregorian components:NSCalendarUnitMonth fromDate:aDate toDate:bDate options:0];
    
    if ([comps month] == 0) {
        return;
    } else if ([comps month] == 1 || [comps month] == -1) {
        
        if ([self compareDate:self.monthView.currentDateStr withDate:dateStr] == 1) {
            self.yearView.nextTimeStr = dateStr;
            [self.monthView previousMonthAnimation];
            
        } else if ([self compareDate:self.monthView.currentDateStr withDate:dateStr] == -1) {
            self.yearView.nextTimeStr = dateStr;
            [self.monthView nextMonthAnimation];
        }
        
    } else {
     
        self.yearView.nextTimeStr = dateStr;
        [self.monthView spanMonthAnimation:dateStr];
    }
}

#pragma mark - YBCalendarLiteDayViewDelegate
- (void)YBCalendarLiteDayChange:(NSString *)dateStr
{
    if ([self compareDate:self.monthView.currentDateStr withDate:dateStr] == 1) {
        self.yearView.nextTimeStr = dateStr;
        self.dayView.dateStr = dateStr;
        [self.monthView previousMonthAnimation];
        [self.liteView showSelectDateStr:nil];
        
    } else if ([self compareDate:self.monthView.currentDateStr withDate:dateStr] == -1) {
        self.yearView.nextTimeStr = dateStr;
        self.dayView.dateStr = dateStr;
        [self.monthView nextMonthAnimation];
        [self.liteView showSelectDateStr:nil];
    }
}

#pragma mark - setter and getter
- (YBCalendarYearView *)yearView
{
    if (!_yearView) {
        _yearView = [[YBCalendarYearView alloc] initWithFrame:CGRectMake(0, 0, 84, 50)];
    }
    return _yearView;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(84, 12.5, 0.5, 25)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"E1E1E1"];
    }
    return _lineView;
}

- (YBCalendarMonthView *)monthView
{
    if (!_monthView) {
        _monthView = [[YBCalendarMonthView alloc] initWithFrame:CGRectMake(84.5, 0, 375-84.5, 50)];
        _monthView.delegate = self;
    }
    return _monthView;
}

- (YBCalendarDayView *)dayView
{
    if (!_dayView) {
        _dayView = [[YBCalendarDayView alloc] initWithFrame:CGRectMake(0, 50, 375, 230)];
        _dayView.delegate = self;
    }
    return _dayView;
}

- (YBCalendarLiteDayView *)liteView
{
    if (!_liteView) {
        _liteView = [[YBCalendarLiteDayView alloc] initWithFrame:CGRectMake(0, 50, 375, 55)];
        _liteView.delegate = self;
        _liteView.hidden = YES;
    }
    return _liteView;
}


@end
