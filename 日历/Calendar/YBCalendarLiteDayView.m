//
//  YBCalendarLiteDayView.m
//  日历
//
//  Created by 易彬 on 17/4/10.
//  Copyright © 2017年 易彬. All rights reserved.
//

#import "YBCalendarLiteDayView.h"
#import "YBCalendarLiteDayCell.h"
#import "UIColor+expanded.h"
#import "NSObject+Date.h"
#import "YBCalendarGenerator.h"

@interface YBCalendarLiteDayView () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    BOOL firstShow;
    BOOL dragEnble;
}

@property (nonatomic, copy, readwrite) NSString * selectDateStr;
@property (nonatomic, strong) UICollectionView * dayView;
@property (nonatomic, strong) YBCalendarGenerator * generator;

@end


@implementation YBCalendarLiteDayView

#pragma mark - public method
#pragma mark 数据交付
- (void)showSelectDateStr:(NSString *)dateStr
{
    self.selectDateStr = dateStr;
    
    if (self.selectDateStr) {
        
        NSDateFormatter * format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy年MM月dd"];
        NSDate * aDate = [format dateFromString:self.selectDateStr];
        NSDate * bDate = [format dateFromString:@"2015年12月28"];
        // 日历对象 （方便比较两个日期之间的差距）
        NSCalendar *calendar = [NSCalendar currentCalendar];
        // 计算两个日期之间的差值
        NSDateComponents * cmps = [calendar components:NSCalendarUnitDay fromDate:bDate toDate:aDate options:0];
        
        NSIndexPath * cellIndexPath = [NSIndexPath indexPathForItem:cmps.day/7 inSection:0];
        
        [self.dayView scrollToItemAtIndexPath:cellIndexPath
                             atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                     animated:NO];
    } else {
        [self.dayView reloadData];
    }
}

- (void)reloadImpotantDateData
{
    [self.dayView reloadData];
}

- (void)setDateStr:(NSString *)dateStr
{
    _dateStr = dateStr;
    _dateStr = [[_dateStr componentsSeparatedByString:@"月"][0] stringByAppendingString:@"月01"];
    [self setUpUI];
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    
    if (hidden) {
        
        firstShow = YES;
        [self.dayView removeFromSuperview];
        self.dayView = nil;
    }
}

#pragma mark - life cicle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        firstShow = YES;
        dragEnble = NO;
        self.backgroundColor = [UIColor colorWithHexString:@"FEAE3B"];
    }
    return self;
}

#pragma mark - UI
- (void)setUpUI
{
    BOOL value = [self.subviews containsObject:self.dayView];
    if (!value) [self addSubview:self.dayView];
    
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月dd"];
    NSDate * aDate = [format dateFromString:self.dateStr];
    NSDate * bDate = [format dateFromString:@"2015年12月28"];
    // 日历对象 （方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 计算两个日期之间的差值
    NSDateComponents * cmps = [calendar components:NSCalendarUnitDay fromDate:bDate toDate:aDate options:0];
    
    NSIndexPath * cellIndexPath = [NSIndexPath indexPathForItem:cmps.day/7 inSection:0];
    
    [self.dayView scrollToItemAtIndexPath:cellIndexPath
                         atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                 animated:value];
}

#pragma mark - UICollectionView 代理和数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;   // 返回有多少组
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 157;   // 这个就是3年的数目，一个个数出来的
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YBCalendarLiteDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellID" forIndexPath:indexPath];
    cell.data = [self.generator calendarLiteListWithDateStr:@"2015年12月28" row:indexPath.row];
    cell.selectDateStr = self.selectDateStr;
    
    __weak __typeof(&*self)weakSelf = self;
    cell.selectBlock =^(NSString * selectDateStr) {
        [weakSelf.delegate YBCalendarLiteDayChange:selectDateStr];
        weakSelf.selectDateStr = selectDateStr;
    };
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    dragEnble = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint p = *targetContentOffset;
    CGFloat x = p.x;
    firstShow = NO;
    
    if ((int)x % 375 == 0 && !firstShow && dragEnble) {
        
        NSUInteger row = (int)x/375;
        NSArray * arr = [self.generator calendarLiteListWithDateStr:@"2015年12月28" row:row];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(YBCalendarLiteDayChange:)]) {
            
            dragEnble = NO;
            [self.delegate YBCalendarLiteDayChange:arr[0]];
        }
    }
}

#pragma mark - private method
- (void)changeMonthViewDateWithStr:(NSString *)day
{
    day = [[day componentsSeparatedByString:@"月"][0] stringByAppendingString:@"月01"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(YBCalendarLiteDayChange:)]) {
        [self.delegate YBCalendarLiteDayChange:day];
    }
}

#pragma mark - setter and getter
- (UICollectionView *)dayView
{
    if (!_dayView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(375, 55);                                     // 设置cell的尺寸
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;     // 设置滚动的方向
        
        _dayView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 375, 55) collectionViewLayout:layout];
        [_dayView registerClass:[YBCalendarLiteDayCell class] forCellWithReuseIdentifier:@"CellID"];
        _dayView.backgroundColor = [UIColor colorWithHexString:@"FEAE3B"];
        _dayView.pagingEnabled = YES;
        _dayView.bounces = NO;
        _dayView.showsHorizontalScrollIndicator = NO;
        _dayView.dataSource = self;
        _dayView.delegate = self;
    }
    return _dayView;
}

- (YBCalendarGenerator *)generator
{
    if (!_generator) {
        _generator = [[YBCalendarGenerator alloc] init];
    }
    return _generator;
}

@end
