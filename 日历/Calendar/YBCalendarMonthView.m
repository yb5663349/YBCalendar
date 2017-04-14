//
//  YBCalendarMonthView.m
//  日历
//
//  Created by 易彬 on 17/4/7.
//  Copyright © 2017年 易彬. All rights reserved.
//

#import "YBCalendarMonthView.h"
#import "UIColor+expanded.h"
#define MaxYearValue 3

@interface YBCalendarMonthView () <UIScrollViewDelegate>
{
    NSInteger currentTag;
    BOOL dragEnble;
}

@property (nonatomic, copy, readwrite) NSString * currentDateStr;
@property (nonatomic, strong) UIScrollView * monthView;
@property (nonatomic, strong) UIImageView  * selectedBgView;
@property (nonatomic, assign) NSUInteger selectYear;
@property (nonatomic, assign) NSUInteger selectMonth;

@end

@implementation YBCalendarMonthView

#pragma mark - public method
- (void)nextMonthAnimation
{
    currentTag ++;
    self.monthView.decelerationRate = UIScrollViewDecelerationRateNormal;
    [self labelAnimation];
}

- (void)previousMonthAnimation
{
    currentTag --;
    self.monthView.decelerationRate = UIScrollViewDecelerationRateNormal;
    [self labelAnimation];
}

- (void)spanMonthAnimation:(NSString *)spanDateStr
{
    NSInteger yearValue = [[spanDateStr componentsSeparatedByString:@"年"][0] integerValue];
    NSString * monthStr = [spanDateStr componentsSeparatedByString:@"年"][1];
    NSUInteger monthValue = [[monthStr componentsSeparatedByString:@"月"][0] integerValue];
    
    currentTag = (yearValue-2016)*12 + monthValue - 1;
    self.monthView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    [self labelAnimation];
}


#pragma mark - life cicle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI
- (void)setUpUI
{
    NSCalendar * cal = [NSCalendar currentCalendar];
    NSDate * date = [NSDate date];
    NSDateComponents * comp = [cal components: NSCalendarUnitWeekday|NSCalendarUnitYear|NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
    self.selectYear = comp.year-2016;
    self.selectMonth = comp.month;
    self.currentDateStr = [NSString stringWithFormat:@"%zd年%02zd月01",comp.year,comp.month];
    
    [self addSubview:self.monthView];
    
    CGFloat lastX = 0.0;
    for (int i=0; i<MaxYearValue; i++) {
        
        for (int j=0; j<12; j++) {
            
            CGFloat k = (self.bounds.size.width-17)/5 * (j+i*12);
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(k, 0, (self.bounds.size.width-17)/5, self.bounds.size.height)];
            label.text = [NSString stringWithFormat:@"%zd月",j+1];
            label.textColor = (i==self.selectYear)&&(j+1)==self.selectMonth ? [UIColor whiteColor]:[UIColor colorWithHexString:@"666666"];
            label.font = [UIFont systemFontOfSize:13];
            label.textAlignment = NSTextAlignmentCenter;
            label.tag = j+i*12;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(monthClickAction:)];
            [label addGestureRecognizer:tap];
            label.userInteractionEnabled = YES;
            
            [self.monthView addSubview:label];
            if ((i==self.selectYear)&&(j+1) == self.selectMonth) {
                currentTag = label.tag;
                [self.selectedBgView setCenter:label.center];
            }
            lastX = k + (self.bounds.size.width-17)/5;
        }
    }
    
    self.monthView.contentSize = CGSizeMake(lastX, 0);
    CGFloat initX = self.selectMonth - 3;
    
    if (initX >= 0) {
        CGFloat width = self.bounds.size.width - 17;
        [self.monthView setContentOffset:CGPointMake((self.selectMonth-3)*(width/5)+self.selectYear*12*width/5, 0) animated:NO];
        
    }
}

#pragma mark - button event
- (void)monthClickAction:(UITapGestureRecognizer *)gesture
{
    NSInteger monthValue = gesture.view.tag % 12 + 1;
    NSInteger yearValue = gesture.view.tag / 12 + 2016;
    
//    if ([comps month] == 1) {
    
        if (self.delegate && [self.delegate respondsToSelector:@selector(YBCalendarMonthChange:)]) {
            
            [self.delegate YBCalendarMonthChange:[NSString stringWithFormat:@"%zd年%02zd月01",yearValue,monthValue]];
        }
//        
//    } else {
//        
//        
//    }
}

#pragma mark - private method
- (void)labelAnimation
{
    UILabel * centerLabel;
    for (UILabel * label in self.monthView.subviews) {
        
        
        if ([label isKindOfClass:[UILabel class]]) {
            
            if (label.tag == currentTag) {
                label.textColor = [UIColor whiteColor];
                centerLabel = label;
            } else {
                label.textColor = [UIColor lightGrayColor];
            }
            
        }
    }
    
    NSInteger monthValue = currentTag % 12 + 1;
    NSInteger yearValue = currentTag / 12 + 2016;
    CGFloat width = self.bounds.size.width - 17;
    
    if (currentTag < 12) {
        
        CGFloat initX = monthValue - 3;
        if (initX >= 0) {
            
            [self.monthView setContentOffset:CGPointMake((monthValue-3)*(width/5), 0) animated:YES];
        }
        
    } else if (currentTag > 11 && currentTag < 24) {
        
        [self.monthView setContentOffset:CGPointMake((monthValue-3)*(width/5)+1*12*width/5, 0) animated:YES];
        
    } else {
        
        if (monthValue < 11) {
            
            [self.monthView setContentOffset:CGPointMake((monthValue-3)*(width/5)+2*12*width/5, 0) animated:YES];
        }
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [self.selectedBgView setCenter:centerLabel.center];
    }];
    
    self.currentDateStr = [NSString stringWithFormat:@"%zd年%02zd月01",yearValue,monthValue];
}

#pragma mark - setter and getter
- (UIScrollView *)monthView
{
    if (!_monthView) {
        _monthView = [[UIScrollView alloc] initWithFrame:CGRectMake(12, 0, self.bounds.size.width-17, self.bounds.size.height)];
        _monthView.delegate = self;
        _monthView.showsHorizontalScrollIndicator = NO;
        
        [_monthView addSubview:self.selectedBgView];
    }
    return _monthView;
}

- (UIImageView *)selectedBgView
{
    if (!_selectedBgView) {
        _selectedBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 50)];
        _selectedBgView.userInteractionEnabled = NO;
        _selectedBgView.image = [UIImage imageNamed:@"mogu.png"];
    }
    return _selectedBgView;
}


@end
