//
//  YBCalendarDayCell.m
//  日历
//
//  Created by 易彬 on 17/4/7.
//  Copyright © 2017年 易彬. All rights reserved.
//

#import "YBCalendarDayCell.h"
#import "YBCalendarGenerator.h"
#import "YBCalendarImportantDayManager.h"
#import "UIColor+expanded.h"

@interface YBCalendarDayCell ()

@property (nonatomic, strong) UIView * importantBgView;
@property (nonatomic, strong) UIView * importantPointView;
@property (nonatomic, strong) UIView * selectBgView;
@property (nonatomic, strong) YBCalendarGenerator * generator;
@property (nonatomic, strong) NSDictionary * monthData;
@property (nonatomic, strong) UIView * monthView;

@end

@implementation YBCalendarDayCell

#pragma mark - public method
#pragma mark 数据交付
- (void)setDateStr:(NSString *)dateStr
{
    _dateStr = dateStr;
    
    self.monthData = [self.generator calendarMapWith:_dateStr];
    int i=0;
    NSMutableArray * arr = [NSMutableArray array];
    
    for (UILabel * label in self.monthView.subviews) {
        
        if ([label isKindOfClass:[UILabel class]]) {
            
            NSString * str = self.monthData[@"dataArr"][i][@"day"];
            if ([str hasPrefix:@"-"]) {
                label.text = [str substringFromIndex:1];
                label.textColor = [UIColor colorWithHexString:@"FFFFFF" andAlpha:0.3];
            } else {
                label.text = str;
                label.textColor = [UIColor whiteColor];
            }
            
            str = self.monthData[@"dataArr"][i][@"dateStr"];
            NSArray * tempArr = [str componentsSeparatedByString:@"-"];
            str = [NSString stringWithFormat:@"%@年%@月%@",tempArr[0],tempArr[1],tempArr[2]];
            if ([[YBCalendarImportantDayManager shareManager].importantDaysArray containsObject:str]) {
                
                [arr addObject:label];
            }
            
            i++;
        }
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
        point.frame = CGRectMake(label.frame.origin.x+36, label.frame.origin.y+3, 6, 6);
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
        
        NSString * str = [_selectDateStr componentsSeparatedByString:@"月"][1];
        NSString * temp = [_selectDateStr stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
        temp = [temp stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
        
        for (UILabel * label in self.monthView.subviews) {
            
            if ([label isKindOfClass:[UILabel class]]) {
                
                if ([label.text integerValue] == [str integerValue]) {
                    
                    if ([label.textColor isEqual:[UIColor whiteColor]]) {
                        
                        if ([self.monthData[@"dataArr"][label.tag][@"dateStr"] isEqualToString:temp]) {
                            
                            self.selectBgView.hidden = NO;
                            self.selectBgView.center = label.center;
                            label.textColor = [UIColor colorWithHexString:@"FEAE3B"];
                        }
                        
                    } else {
                        
                        label.textColor = [UIColor colorWithHexString:@"FFFFFF" andAlpha:0.3];
                    }
                }
            }
        }
        
    } else {
        
        self.selectBgView.hidden = YES;
        
        for (UILabel * label in self.monthView.subviews) {
            
            if ([label isKindOfClass:[UILabel class]]) {
                
                if ([label.textColor isEqual:[UIColor colorWithHexString:@"FEAE3B"]]) {
                    label.textColor = [UIColor whiteColor];
                }
            }
        }
    }
}

#pragma mark - life cicle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithHexString:@"FEAE3B"];
        
        [self setUpUI];
//        [self setUpLayout];
    }
    return self;
}

#pragma mark - UI
- (void)setUpUI
{
    [self.contentView addSubview:self.selectBgView];
    [self.contentView addSubview:self.monthView];
    
    for (int i=0; i<6; i++) {
        
        for (int j=0; j<7; j++) {
            
            CGFloat labelX = 375/7 * j;
            CGFloat labelY = 35 * i + 10;
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, 375/7, 35)];
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentCenter;
            label.tag = i*7+j;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(daysClick:)];
            label.userInteractionEnabled = YES;
            [label addGestureRecognizer:tap];
            [self.monthView addSubview:label];
        }
    }
}

#pragma mark Layout
- (void)setUpLayout
{
    
}

#pragma mark - button event
- (void)daysClick:(UITapGestureRecognizer *)gesture
{
    NSString * str = self.monthData[@"dataArr"][gesture.view.tag][@"dateStr"];
    str = [NSString stringWithFormat:@"%@年%@月%@",[str componentsSeparatedByString:@"-"][0],[str componentsSeparatedByString:@"-"][1],[str componentsSeparatedByString:@"-"][2]];
    if (self.selectBlock) self.selectBlock(str);
    
    UILabel * touchLabel = (UILabel *)gesture.view;
    
    if (![touchLabel.textColor isEqual:[UIColor whiteColor]]) {
    
        return;
    }
    
    self.selectBgView.hidden = NO;
    self.selectBgView.center = touchLabel.center;
    int i=0;
    
    for (UILabel * label in self.monthView.subviews) {
        
        if ([label isKindOfClass:[UILabel class]]) {
            
            if ([label.textColor isEqual:[UIColor whiteColor]] ||
                [label.textColor isEqual:[UIColor colorWithHexString:@"FEAE3B"]]) {
                
                if (i == touchLabel.tag) {
                    label.textColor = [UIColor colorWithHexString:@"FEAE3B"];
                } else {
                    label.textColor = [UIColor whiteColor];
                }
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

- (UIView *)monthView
{
    if (!_monthView) {
        _monthView = [[UIView alloc] initWithFrame:self.bounds];
        _monthView.backgroundColor = [UIColor clearColor];
        _monthView.userInteractionEnabled = YES;
    }
    return _monthView;
}

- (YBCalendarGenerator *)generator
{
    if (!_generator) {
        _generator = [[YBCalendarGenerator alloc] init];
    }
    return _generator;
}



@end
