//
//  ChartTableViewCell.h
//  CareKitDemo
//
//  Created by Realank on 2018/1/31.
//  Copyright © 2018年 iMooc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartTableViewCell : UITableViewCell

@property (nonatomic, weak) UIView* chartView;
@property (nonatomic, weak) UILabel* titleLabel;

+ (CGFloat)cellHeight;
- (void)addSubViewWithConstraint:(UIView*)subView;
@end

@interface PieChartTableViewCell : ChartTableViewCell


@end

@interface GraphChartTableViewCell : ChartTableViewCell

@end

@interface LineGraphChartTableViewCell : GraphChartTableViewCell
@end
@interface DiscreteGraphChartTableViewCell : GraphChartTableViewCell
@end
@interface BarGraphChartTableViewCell : GraphChartTableViewCell
@end
