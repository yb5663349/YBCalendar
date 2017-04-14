//
//  ViewController.m
//  日历
//
//  Created by 易彬 on 17/4/6.
//  Copyright © 2017年 易彬. All rights reserved.
//

#import "ViewController.h"
#import "CalendarView.h"
#import "YBCalendarImportantDayManager.h"

@interface ViewController ()

@property (nonatomic, strong) CalendarView * mainView;

@end

@implementation ViewController

#pragma mark - life cicle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setUpUI];
    [YBCalendarImportantDayManager shareManager].importantDaysArray = @[@"2017年04月13",@"2017年04月18",@"2018年01月13",@"2018年01月13"];
    [self.mainView reloadImpotantDateData];
}


#pragma mark - UI层
- (void)setUpUI
{
    [self.view addSubview:self.mainView];
}


#pragma mark - getter and settes
- (CalendarView *)mainView
{
    if (!_mainView) {
        _mainView = [[CalendarView alloc] initWithFrame:self.view.bounds];
    }
    return _mainView;
}



@end
