//
//  CalendarCell.h
//  日历
//
//  Created by 易彬 on 17/4/6.
//  Copyright © 2017年 易彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarCell : UITableViewCell
/**
 *  快速创建Cell类方法
 *
 *  @param tableView  tableView
 *  @param identifier identifier
 *
 *  @return Cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

@end
