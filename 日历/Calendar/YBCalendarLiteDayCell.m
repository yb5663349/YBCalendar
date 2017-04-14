//
//  YBCalendarLiteDayCell.m
//  日历
//
//  Created by 易彬 on 17/4/10.
//  Copyright © 2017年 易彬. All rights reserved.
//

#import "YBCalendarLiteDayCell.h"
#import "YBCalendarImportantDayManager.h"
#import "YBCalendarGenerator.h"
#import "UIColor+expanded.h"

@interface YBCalendarLiteDayCell ()

@property (nonatomic, strong) UIView * selectBgView;
@property (nonatomic, strong) UIView * daysView;

@end

@implementation YBCalendarLiteDayCell

#pragma mark - public method
#pragma mark 数据交付
- (void)setData:(NSArray *)data
{
    _data = data;
    self.selectBgView.hidden = YES;
    
    NSMutableArray * arr = [NSMutableArray array];
    NSUInteger i =0;
    for (UILabel * label in self.daysView.subviews) {
        
        NSString * str = [_data[i] componentsSeparatedByString:@"月"][1];
        label.text = [NSString stringWithFormat:@"%zd",[str integerValue]];
        label.textColor = [UIColor whiteColor];
        
        
        if ([[YBCalendarImportantDayManager shareManager].importantDaysArray containsObject:_data[i]]) {
            
            [arr addObject:label];
        }
        
        i ++;
    }
    
    
    for (UIButton * btn in self.contentView.subviews) {
        
        if ([btn isKindOfClass:[UIButton class]]) {
            
            [btn removeFromSuperview];
        }
    }
    
    for (int i=0; i<arr.count; i++) {
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 29, 29);
        [btn.layer setCornerRadius:29/2];
        [btn setBackgroundColor:[UIColor colorWithHexString:@"FFBD60"]];
        btn.userInteractionEnabled = NO;
        [self.contentView insertSubview:btn belowSubview:self.selectBgView];
        UILabel * label = arr[i];
        btn.center = label.center;
        
        UIButton * point = [UIButton buttonWithType:UIButtonTypeCustom];
        point.frame = CGRectMake(label.frame.origin.x+36, label.frame.origin.y+13, 6, 6);
        [point.layer setCornerRadius:6/2];
        [point setBackgroundColor:[UIColor colorWithHexString:@"FF6E3A"]];
        point.userInteractionEnabled = NO;
        [self.contentView insertSubview:point aboveSubview:self.selectBgView];
    }
}

- (void)setSelectDateStr:(NSString *)selectDateStr
{
    _selectDateStr = selectDateStr;
    
    if (_selectDateStr) {
        
        for (UILabel * label in self.daysView.subviews) {
            
            if ([_data[label.tag] isEqualToString:_selectDateStr]) {
                
                self.selectBgView.hidden = NO;
                self.selectBgView.center = label.center;
                label.textColor = [UIColor colorWithHexString:@"FEAE3B"];
                
            } else {
                
                label.textColor = [UIColor whiteColor];
            }
        }
        
    } else {
        
        self.selectBgView.hidden = YES;
    }
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
    [self.contentView addSubview:self.selectBgView];
    
    [self.contentView addSubview:self.daysView];
    
    for (int i=0; i<7; i++) {
        
        CGFloat labelX = 375/7 * i;
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 0, 375/7, 55)];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = i;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(daysClick:)];
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:tap];
        [self.daysView addSubview:label];
    }
}

#pragma mark Layout
- (void)setUpLayout
{
    
}

#pragma mark - button event
- (void)daysClick:(UITapGestureRecognizer *)gesture
{
    NSString * str = _data[gesture.view.tag];
    if (self.selectBlock) self.selectBlock(str);
    
    UILabel * touchLabel = (UILabel *)gesture.view;
    
    self.selectBgView.hidden = NO;
    self.selectBgView.center = touchLabel.center;
    int i=0;
    
    for (UILabel * label in self.daysView.subviews) {
        
        if ([label isKindOfClass:[UILabel class]]) {
            
            if (i == touchLabel.tag) {
                label.textColor = [UIColor colorWithHexString:@"FEAE3B"];
            } else {
                label.textColor = [UIColor whiteColor];
            }
        }
        
        i++;
    }
}

#pragma mark - setter and getter
- (UIView *)selectBgView
{
    if (!_selectBgView) {
        _selectBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 29, 29)];
        [_selectBgView.layer setCornerRadius:29/2];
        _selectBgView.backgroundColor = [UIColor whiteColor];
        _selectBgView.hidden = YES;
    }
    return _selectBgView;
}

- (UIView *)daysView
{
    if (!_daysView) {
        _daysView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 55)];
    }
    return _daysView;
}

@end
