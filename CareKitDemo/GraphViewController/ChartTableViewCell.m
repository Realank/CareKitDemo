//
//  ChartTableViewCell.m
//  CareKitDemo
//
//  Created by Realank on 2018/1/31.
//  Copyright © 2018年 iMooc. All rights reserved.
//

#import "ChartTableViewCell.h"

@implementation ChartTableViewCell

+ (CGFloat)cellHeight{
    return 260.0f;
}

- (void)addSubViewWithConstraint:(UIView*)subView{
    
    _chartView = subView;
    [self.contentView addSubview:subView];
    NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:subView.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:10];
    NSLayoutConstraint* rightConstraint = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:subView.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10];
    NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:subView.superview attribute:NSLayoutAttributeTop multiplier:1 constant:10 + 30];
    NSLayoutConstraint* bottomConstraint = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:subView.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
//    [self.contentView addConstraints:@[leftConstraint, rightConstraint]];
    leftConstraint.active = YES;
    rightConstraint.active = YES;
    topConstraint.active = YES;
    bottomConstraint.active = YES;
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel* label = [[UILabel alloc] init];
    _titleLabel = label;
    label.text = @"Title";
    label.font = [UIFont boldSystemFontOfSize:17];
    [self.contentView addSubview:label];
    NSLayoutConstraint* leftConstraintLabel = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:label.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:10];

    NSLayoutConstraint* topConstraintLabel = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:label.superview attribute:NSLayoutAttributeTop multiplier:1 constant:10];
    //    [self.contentView addConstraints:@[leftConstraint, rightConstraint]];
    leftConstraintLabel.active = YES;
    topConstraintLabel.active = YES;
    label.translatesAutoresizingMaskIntoConstraints = NO;
}


@end

@implementation PieChartTableViewCell


- (instancetype)init{
    if (self = [super init]) {
        
        [self addSubViewWithConstraint:[[ORKPieChartView alloc] init]];
    }
    return self;
}
@end

@implementation GraphChartTableViewCell



@end

@implementation LineGraphChartTableViewCell : GraphChartTableViewCell
- (instancetype)init{
    if (self = [super init]) {
        [self addSubViewWithConstraint:[[ORKLineGraphChartView alloc] init]];
    }
    return self;
}

@end
@implementation DiscreteGraphChartTableViewCell : GraphChartTableViewCell

- (instancetype)init{
    if (self = [super init]) {
        [self addSubViewWithConstraint:[[ORKDiscreteGraphChartView alloc] init]];
    }
    return self;
}
@end
@implementation BarGraphChartTableViewCell : GraphChartTableViewCell

- (instancetype)init{
    if (self = [super init]) {
        [self addSubViewWithConstraint:[[ORKBarGraphChartView alloc] init]];
    }
    return self;
}
@end
