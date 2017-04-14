//
//  YBCalendarLiteDayCell.h
//  日历
//
//  Created by 易彬 on 17/4/10.
//  Copyright © 2017年 易彬. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^liteBlock) (NSString *);

@interface YBCalendarLiteDayCell : UICollectionViewCell

@property (nonatomic, strong) NSArray * data;
@property (nonatomic, copy) NSString * selectDateStr;
@property (nonatomic, assign) BOOL firstShow;
@property (nonatomic, copy) liteBlock selectBlock;

@end
