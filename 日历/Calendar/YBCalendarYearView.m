//
//  YBCalendarYearView.m
//  日历
//
//  Created by 易彬 on 17/4/7.
//  Copyright © 2017年 易彬. All rights reserved.
//

#import "YBCalendarYearView.h"
#import "UIColor+expanded.h"

@interface YBCalendarYearView ()
{
    NSUInteger scrollIndex;
}

@property (nonatomic, strong) UILabel * oneLabel;
@property (nonatomic, strong) UILabel * twoLabel;

@end

@implementation YBCalendarYearView

#pragma mark - public method
#pragma mark 数据交付
- (void)setNextTimeStr:(NSString *)nextTimeStr
{
    _nextTimeStr = nextTimeStr;
    _nextTimeStr = [_nextTimeStr componentsSeparatedByString:@"月"][0];
    _nextTimeStr = [_nextTimeStr stringByReplacingOccurrencesOfString:@"年" withString:@"/"];
    [self startScrollAnimation];
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
    self.backgroundColor = [UIColor whiteColor];
    scrollIndex = 0;
    
    [self addSubview:self.oneLabel];
    [self addSubview:self.twoLabel];
}

#pragma mark - private method
- (void)startScrollAnimation
{
    scrollIndex ++;
    
    if (scrollIndex%2==0) {
        
        self.oneLabel.text = self.nextTimeStr;
        [UIView animateWithDuration:0.4 animations:^{
            
            self.oneLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            self.twoLabel.frame = CGRectMake(0, -self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
            
        } completion:^(BOOL finished){
            
            self.twoLabel.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
        }];
        
    } else {
        
        self.twoLabel.text = self.nextTimeStr;
        [UIView animateWithDuration:0.4 animations:^{
            
            self.twoLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            self.oneLabel.frame = CGRectMake(0, -self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
            
        } completion:^(BOOL finished){
            
            self.oneLabel.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
        }];
    }
}

#pragma mark - setter and getter
- (UILabel *)oneLabel
{
    if (!_oneLabel) {
        _oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        NSCalendar * cal = [NSCalendar currentCalendar];
        NSDate * date = [NSDate date];
        NSDateComponents * comp = [cal components: NSCalendarUnitWeekday|NSCalendarUnitYear|NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
        _oneLabel.text = [NSString stringWithFormat:@"%zd/%02zd",comp.year,comp.month];
        _oneLabel.font = [UIFont systemFontOfSize:13];
        _oneLabel.textColor = [UIColor lightGrayColor];
        _oneLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _oneLabel;
}

- (UILabel *)twoLabel
{
    if (!_twoLabel) {
        _twoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height)];
        _twoLabel.font = [UIFont systemFontOfSize:13];
        _twoLabel.textColor = [UIColor lightGrayColor];
        _twoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _twoLabel;
}

@end
