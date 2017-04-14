//
//  CalendarCell.m
//  日历
//
//  Created by 易彬 on 17/4/6.
//  Copyright © 2017年 易彬. All rights reserved.
//

#import "CalendarCell.h"

@implementation CalendarCell

#pragma mark - public method
#pragma mark 数据交付


#pragma mark - 快速创建Cell类方法
+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier
{
    id cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

#pragma mark - life cicle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor redColor];
        
        [self setUpUI];
        [self setUpLayout];
    }
    return self;
}

#pragma mark - UI
- (void)setUpUI
{
    
}

#pragma mark Layout
- (void)setUpLayout
{
    
}

#pragma mark - getter and setter


@end
