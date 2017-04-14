//
//  YBCalendarDayView.m
//  日历
//
//  Created by 易彬 on 17/4/7.
//  Copyright © 2017年 易彬. All rights reserved.
//

#import "YBCalendarDayView.h"
#import "YBCalendarDayCell.h"
#import "UIColor+expanded.h"

@interface YBCalendarDayView () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    BOOL dragEnble;
}

@property (nonatomic, strong) UICollectionView * dayView;
@property (nonatomic, copy, readwrite) NSString * selectDateStr;
@property (nonatomic, copy, readwrite) NSString * currentDateStr;

@end

@implementation YBCalendarDayView

#pragma mark - public method
#pragma mark 数据交付
- (void)showSelectDateStr:(NSString *)dateStr
{
    self.selectDateStr = dateStr;
    [self.dayView reloadData];
}

- (void)setDateStr:(NSString *)dateStr
{
    _dateStr = dateStr;
    _dateStr = [[_dateStr componentsSeparatedByString:@"月"][0] stringByAppendingString:@"月01"];
    self.currentDateStr = _dateStr;
    [self scrollDateIndexPath];
}

- (void)reloadImpotantDateData
{
    [self.dayView reloadData];
}

#pragma mark - life cicle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpUI];
        [self setUpBasic];
    }
    return self;
}

#pragma mark - UI
- (void)setUpUI
{
    self.backgroundColor = [UIColor colorWithHexString:@"FEAE3B"];
    dragEnble = NO;
    [self addSubview:self.dayView];
}

- (void)setUpBasic
{
    NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate * dt = [NSDate date];
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents * comp = [gregorian components:unitFlags fromDate:dt];
    
    if (comp.year > 2018) comp.year = 2018;
    
    NSIndexPath * cellIndexPath = [NSIndexPath indexPathForItem:comp.month-1 inSection:comp.year-2016];
    [self.dayView scrollToItemAtIndexPath:cellIndexPath
                         atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                 animated:NO];
    
    self.currentDateStr = [NSString stringWithFormat:@"%zd年%02zd月",comp.year,comp.month];
}

#pragma mark - UICollectionView 代理和数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;   // 返回有多少组
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;   // 返回第section组有多少个cell
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YBCalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellID" forIndexPath:indexPath];
    cell.dateStr = [NSString stringWithFormat:@"%zd年%02zd月",indexPath.section+2016,indexPath.row+1];
    cell.selectDateStr = self.selectDateStr;
    
    __weak __typeof(&*self)weakSelf = self;
    cell.selectBlock =^(NSString * selectDateStr) {
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
    
    if ((int)x % 375 == 0 && dragEnble) {
        
        NSUInteger year = (int)x/375/12 + 2016;
        NSUInteger month = (int)x/375%12 + 1;
        if (self.delegate && [self.delegate respondsToSelector:@selector(YBCalendarDayChange:)]) {
            dragEnble = NO;
            self.selectDateStr = nil;
            [self.dayView reloadData];
            self.currentDateStr = [NSString stringWithFormat:@"%zd年%02zd月01",year,month];
            [self.delegate YBCalendarDayChange:[NSString stringWithFormat:@"%zd年%02zd月01",year,month]];
        }
    }
}


#pragma mark - private method
- (void)scrollDateIndexPath
{
    NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy年MM月dd"];
    NSDate *date = [[NSDate alloc] init];
    date = [dateformater dateFromString:self.dateStr];
    
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents * comp = [gregorian components:unitFlags fromDate:date];
    
    if (comp.year > 2018) comp.year = 2018;
    
    NSIndexPath * cellIndexPath = [NSIndexPath indexPathForItem:comp.month-1 inSection:comp.year-2016];
    [self.dayView scrollToItemAtIndexPath:cellIndexPath
                         atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                 animated:YES];
}


#pragma mark - setter and getter
- (UICollectionView *)dayView
{
    if (!_dayView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(375, 230);                                     // 设置cell的尺寸
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;     // 设置滚动的方向
        
        _dayView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        [_dayView registerClass:[YBCalendarDayCell class] forCellWithReuseIdentifier:@"CellID"];
        _dayView.pagingEnabled = YES;
        _dayView.bounces = NO;
        _dayView.showsHorizontalScrollIndicator = NO;
        _dayView.dataSource = self;
        _dayView.delegate = self;
    }
    return _dayView;
}

@end
