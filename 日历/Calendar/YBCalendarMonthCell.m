//
//  YBCalendarMonthCell.m
//  日历
//
//  Created by 易彬 on 17/4/7.
//  Copyright © 2017年 易彬. All rights reserved.
//

#import "YBCalendarMonthCell.h"

@interface YBCalendarMonthCell ()

@property (nonatomic, strong) UILabel * monthLabel;

@end

@implementation YBCalendarMonthCell

#pragma mark - public method
#pragma mark 数据交付
- (void)setMonthStr:(NSString *)monthStr
{
    _monthStr = monthStr;
    self.monthLabel.text = _monthStr;
}

- (void)setIsSelectMonth:(BOOL)isSelectMonth
{
    _isSelectMonth = isSelectMonth;
    
    if (_isSelectMonth) {
        
        _monthLabel.textColor = [UIColor whiteColor];
        
    } else {
        
        _monthLabel.textColor = [UIColor lightGrayColor];
    }
}

#pragma mark - life cicle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI
- (void)setUpUI
{
//    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.monthLabel];
}


#pragma mark - setter and getter
- (UILabel *)monthLabel
{
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _monthLabel.textColor = [UIColor lightGrayColor];
        _monthLabel.font = [UIFont systemFontOfSize:13];
        _monthLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _monthLabel;
}

@end
