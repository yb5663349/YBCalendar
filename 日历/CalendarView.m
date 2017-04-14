//
//  CalendarView.m
//  日历
//
//  Created by 易彬 on 17/4/6.
//  Copyright © 2017年 易彬. All rights reserved.
//

#import "CalendarView.h"
#import "YBCalendarView.h"
#import "CalendarCell.h"

@interface CalendarView () <UITableViewDelegate, UITableViewDataSource>
{
    BOOL isShowLite;
}

@property (nonatomic, strong) YBCalendarView * calendarView;
@property (nonatomic, strong) UIView      * contentView;
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation CalendarView

#pragma mark - public method
#pragma mark 数据交付
- (void)reloadImpotantDateData
{
    [self.calendarView reloadImpotantDateData];
}

#pragma mark - life cicle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        isShowLite = NO;
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI
- (void)setUpUI
{
    [self addSubview:self.calendarView];
    [self addSubview:self.contentView];
}

#pragma mark - TableView 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCell * cell = [CalendarCell cellWithTableView:tableView identifier:@"CellID"];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offectY = scrollView.contentOffset.y;
    
    if (offectY > 0) {
        
        if (self.tableView.frame.origin.y > 80) {
            
            self.tableView.frame = CGRectMake(0, 240-offectY, 375, 603-240+offectY);
        }
    }
}

#pragma mark - button event
- (void)contentPanAction:(UIPanGestureRecognizer *)gesture
{
    CGFloat translationY = - [gesture translationInView:self.contentView].y;
    
    switch (gesture.state)
    {
        case UIGestureRecognizerStateBegan: break;
        case UIGestureRecognizerStateChanged:
        {
            if (isShowLite) {
                
                if (translationY > 0) {
                    
                    [self.tableView setContentOffset:CGPointMake(0, translationY) animated:NO];
                    
                } else {
                    
                    self.calendarView.showDayLiteView = NO;
                    if (translationY < -175) {
                        
                        self.contentView.frame = CGRectMake(0, 280, self.contentView.frame.size.width, 603-280);
                        self.tableView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 603-280);
                    } else {
                        self.contentView.frame = CGRectMake(0, 105-translationY, self.contentView.frame.size.width, 603-280+translationY);
                        self.tableView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 603-280+translationY);
                    }
                }
                
            } else {
                
                if (translationY > 0) {
                    if (translationY > 175) {
                        
                        self.contentView.frame = CGRectMake(0, 105, self.contentView.frame.size.width, 603-105);
                        self.tableView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 603-105);
                    } else {
                        self.contentView.frame = CGRectMake(0, 280-translationY, self.contentView.frame.size.width, 603-280+translationY);
                        self.tableView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 603-280+translationY);
                    }
                }
            }
            
        } break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
            self.contentView.userInteractionEnabled = NO;
            if (self.contentView.frame.origin.y > 200) {
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.contentView.frame = CGRectMake(0, 280, self.contentView.frame.size.width, 603-280);
                    self.tableView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 603-280);
                    
                } completion:^(BOOL finished) {
                    
                    self.contentView.userInteractionEnabled = YES;
                    isShowLite = NO;
                }];
            } else {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.contentView.frame = CGRectMake(0, 105, self.contentView.frame.size.width, 603-105);
                    self.tableView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 603-105);
                    
                } completion:^(BOOL finished) {
                    
                    self.contentView.userInteractionEnabled = YES;
                    isShowLite = YES;
                    self.calendarView.showDayLiteView = YES;
                }];
            }
        } break;
        default: break;
    }
}

#pragma mark - setter and getter
- (YBCalendarView *)calendarView
{
    if (!_calendarView) {
     
        _calendarView = [[YBCalendarView alloc] initWithFrame:CGRectMake(0,0, 375, 280)];
    }
    return _calendarView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 375, 603-280) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[CalendarCell class] forCellReuseIdentifier:@"CellID"];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 280, 375, 603-280)];
        [_contentView addSubview:self.tableView];
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(contentPanAction:)];
        [_contentView addGestureRecognizer:pan];
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}

@end
