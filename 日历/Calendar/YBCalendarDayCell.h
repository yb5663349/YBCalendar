//
//  YBCalendarDayCell.h
//  日历
//
//  Created by 易彬 on 17/4/7.
//  Copyright © 2017年 易彬. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^dayBlock) (NSString *);

@interface YBCalendarDayCell : UICollectionViewCell
/**
 cell所属年月份
 */
@property (nonatomic, copy) NSString * dateStr;
/**
 选中日期
 */
@property (nonatomic, copy) NSString * selectDateStr;
@property (nonatomic, copy) dayBlock selectBlock;

@end
