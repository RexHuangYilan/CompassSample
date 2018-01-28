//
//  CompassView.m
//  CompassSample
//
//  Created by Rex on 2018/1/26.
//  Copyright © 2018年 Rex. All rights reserved.
//

#import "CompassView.h"
#import "CompassPointerView.h"

@interface CompassView ()

@property (nonatomic, strong) NSDictionary *direction;
@property (nonatomic, strong) NSMutableArray<UILabel *> *texts;
/*!
 東西南北字型
 */
@property (nonatomic, strong) UIFont *fourSideFont;

/*!
 斜角字型
 */
@property (nonatomic, strong) UIFont *bevelSideFont;

/*!
 角度字型
 */
@property (nonatomic, strong) UIFont *angleFont;

/*!
 是否預設指針
 */
@property (nonatomic) BOOL isDefalutPointer;

@end

@implementation CompassView

@synthesize compassPointerView = _compassPointerView;

#pragma mark - init

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
        [self compassSteupProperty];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        [self compassSteupProperty];
    }
    return self;
}

-(void)compassSteupProperty
{
    _colorFont = [UIColor blackColor];
    _fourSideFontSize = 20;
    _bevelSideFontSize = 16;
    _angleFontSize = 12;
    _fourSideFont = [UIFont fontWithName:@"Helvetica-Bold" size:_fourSideFontSize];
    _bevelSideFont = [UIFont fontWithName:@"Helvetica-Bold" size:_bevelSideFontSize];
    _angleFont = [UIFont fontWithName:@"Helvetica-Bold" size:_angleFontSize];
}

#pragma mark - draw

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [self autolayoutPointer];
    [self bringSubviewToFront:self.compassPointerView];
}

#pragma mark - get

-(NSDictionary *)direction
{
    if (!_direction) {
        _direction = @{
                       @(0):@"N",
                       @(45):@"NE",
                       @(90):@"E",
                       @(135):@"SE",
                       @(180):@"S",
                       @(225):@"SW",
                       @(270):@"W",
                       @(315):@"NW",
                       };
    }
    return _direction;
}

-(NSMutableArray<UILabel *> *)texts
{
    if (!_texts) {
        _texts = [NSMutableArray array];
    }
    return _texts;
}

-(UIView *)compassPointerView
{
    if (!_compassPointerView) {
        CGRect frame = [self pointerDefalutRect];
        CompassPointerView *compassPointerView  = [[CompassPointerView alloc] initWithFrame:frame];
        compassPointerView.margin = 5;
        self.compassPointerView = compassPointerView;
        self.isDefalutPointer = YES;
    }
    return _compassPointerView;
}

#pragma mark - set

-(void)setColorFont:(UIColor *)colorFont
{
    _colorFont = colorFont;
    for (UILabel *label in self.texts) {
        label.textColor = colorFont;
    }
}

-(void)setFourSideFontSize:(CGFloat)fourSideFontSize
{
    _fourSideFontSize = fourSideFontSize;
    self.fourSideFont = [UIFont fontWithName:@"Helvetica-Bold" size:fourSideFontSize];
    [self drawCalibrationView];
}

-(void)setBevelSideFontSize:(CGFloat)bevelSideFontSize
{
    _bevelSideFontSize = bevelSideFontSize;
    self.bevelSideFont = [UIFont fontWithName:@"Helvetica-Bold" size:bevelSideFontSize];
    [self drawCalibrationView];
}

-(void)setAngleFontSize:(CGFloat)angleFontSize
{
    _angleFontSize = angleFontSize;
    self.angleFont = [UIFont fontWithName:@"Helvetica-Bold" size:angleFontSize];
    [self drawCalibrationView];
}

-(void)setCompassPointerView:(UIView *)compassPointerView
{
    if (_compassPointerView) {
        [_compassPointerView removeFromSuperview];
    }
    
    self.isDefalutPointer = NO;
    _compassPointerView = compassPointerView;
    
    if (compassPointerView) {
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat height = CGRectGetHeight(self.bounds);
        CGPoint center = CGPointMake(width/2, height/2);
        compassPointerView.center = center;
        [self addSubview:compassPointerView];
    }
}

-(void)setHeading:(CLHeading *)heading
{
    _heading = heading;
    // 小於0是不正確的
    if (heading.headingAccuracy < 0) {
        return;
    }
    
    // 取得向北的角度
    CGFloat angle = heading.magneticHeading;
    
    // 修正不同畫面方向的角度偏移
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            angle -= 180;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            angle -= 90;
            break;
        case UIInterfaceOrientationLandscapeRight:
            angle += 90;
            break;
        default:
            break;
    }
    // 弧度
    CGFloat radian = - angle / 180.0 * M_PI;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.compassPointerView.transform = CGAffineTransformMakeRotation(radian);
    }];
}

#pragma mark - private

-(CGRect)pointerDefalutRect
{
    CGFloat framelineBorder = self.lineBorder;    //邊框
    CGFloat framelineMargin = self.borderMargin;   // 外邊距
    CGFloat framelinePadding = self.borderPadding;  // 內邊距
    
    CGRect frame = self.bounds;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat diameter = MIN(width, height);
    
    frame.size.width = diameter / 10;
    frame.size.height = (diameter / 2.f - framelineBorder - framelineMargin - framelinePadding) * 2.f;
    return frame;
}

-(void)autolayoutPointer
{
    if (self.isDefalutPointer) {
        CGRect frame = [self pointerDefalutRect];
        self.compassPointerView.frame = frame;
    }
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    CGPoint center = CGPointMake(width/2, height/2);
    self.compassPointerView.center = center;
}

#pragma mark - public

-(void)drawCalibration
{
    [super drawCalibration];
    [self autolayoutPointer];
}

#pragma mark - HTWCalibrationViewDelegate

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
    if (index == 0) {
        [self.texts removeAllObjects];
    }
    
    UILabel *text;
    NSString *valueString;
    UIFont *font;
    
    if ((int)angle % 90 == 0)
    {
        valueString = self.direction[@((int)angle)];
        font = self.fourSideFont;
    }
    else if ((int)angle % 45 == 0) {
        valueString = self.direction[@((int)angle)];
        font = self.bevelSideFont;
    }
    else if ((int)angle % 15 == 0)
    {
        valueString = [NSString stringWithFormat:@"%ld",(long)index];
        font = self.angleFont;
    }
    
    if (valueString)
    {
        CGSize size = [valueString sizeWithAttributes:@{NSFontAttributeName:font}];
        
        text = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        text.text = valueString;
        text.font = font;
        text.textColor = self.colorFont;
        text.textAlignment = NSTextAlignmentCenter;
        
        [self.texts addObject:text];
    }
    
    return text;
}

@end
