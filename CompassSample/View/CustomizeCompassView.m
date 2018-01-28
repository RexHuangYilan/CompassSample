//
//  CustomizeCompassView.m
//  CompassSample
//
//  Created by Rex on 2018/1/26.
//  Copyright © 2018年 Rex. All rights reserved.
//

#import "CustomizeCompassView.h"

@implementation CustomizeCompassView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
    }
    return self;
}

-(struct HTWCalibrationViewLine)calibrationView:(HTWCalibrationView *)calibrationView drawIndex:(NSUInteger)index angle:(CGFloat)angle line:(struct HTWCalibrationViewLine)line
{
    if ((int)angle % 45 == 0) {
        line.width *= 4;
    }
    else if (index % 5 == 0)
    {
        line.width *= 2;
        line.height = self.maxHeightCalibration * 2 / 3;
    }
    else
    {
        line.height = self.maxHeightCalibration * 1 / 3;
    }
    
    return line;
}

-(UIView *)calibrationView:(HTWCalibrationView *)calibrationView drawViewIndex:(NSUInteger)index angle:(CGFloat)angle viewCenter:(CGPoint *)viewCenter
{
    if ((int)angle % 45 == 0) {
        NSString *valueString = [NSString stringWithFormat:@"%ld",(long)index];
        
        UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:7];
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        text.text = valueString;
        text.font = font;
        text.textColor = [UIColor colorWithRed:0.54 green:0.78 blue:0.91 alpha:1.0];
        text.textAlignment = NSTextAlignmentCenter;
        return text;
    }
    return nil;
}

@end
