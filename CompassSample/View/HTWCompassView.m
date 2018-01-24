//
//  HTWCompassView.m
//  CompassSample
//
//  Created by Rex on 2018/1/21.
//  Copyright © 2018年 Rex. All rights reserved.
//

#import "HTWCompassView.h"

static CGFloat const pi180 = M_PI / 180;

@interface HTWCompassView ()

// 刻度
@property (nonatomic, strong) CALayer *calibrationLayer;
// 邊框
@property (nonatomic, strong) CAShapeLayer *borderLayer;

@end

@implementation HTWCompassView

#pragma mark - init

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self steupProperty];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self steupProperty];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self steupProperty];
    }
    return self;
}

-(void)steupProperty
{
    _colorBorder = [UIColor blackColor];
    _perNumber = 360;
    _startAngle = -90;
    _colorCalibration = [UIColor blackColor];
    _maxHeightCalibration = 20;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
//    [self drawGauge];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    NSLog(@"drawRect:%@",NSStringFromCGRect(rect));
    [self drawBorderWithRect:rect];
    [self drawCalibrationWithRect:rect];
}

#pragma mark - set

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    NSLog(@"setFrame:%@",NSStringFromCGRect(frame));
}

-(void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    NSLog(@"setBounds:%@",NSStringFromCGRect(bounds));
    [self.layer display];
}

#pragma mark - set Border

-(void)setLineBorder:(CGFloat)lineBorder
{
    _lineBorder = lineBorder > 20 ?20:lineBorder;
    self.borderLayer.lineWidth = lineBorder;
}

-(void)setColorBorder:(UIColor *)colorBorder
{
    _colorBorder = colorBorder;
    self.borderLayer.strokeColor = colorBorder.CGColor;
}

-(void)setBorderMargin:(CGFloat)borderMargin
{
    _borderMargin = borderMargin;
    [self.layer display];
}

-(void)setBorderPadding:(CGFloat)borderPadding
{
    _borderPadding = borderPadding;
    [self.layer display];
}

#pragma mark - set

-(void)setPerNumber:(NSUInteger)perNumber
{
    perNumber = perNumber > 360 ? 360:perNumber;
    perNumber = perNumber == 0 ?1:perNumber;
    _perNumber = perNumber;
    [self drawCalibrationWithRect:self.bounds];
}

-(void)setStartAngle:(CGFloat)startAngle
{
    _startAngle = startAngle;
    [self drawCalibrationWithRect:self.bounds];
}

-(void)setColorCalibration:(UIColor *)colorCalibration
{
    _colorCalibration = colorCalibration;
    for (CAShapeLayer *perLayer in self.calibrationLayer.sublayers) {
        perLayer.strokeColor = colorCalibration.CGColor;
    }
}

-(void)setMaxHeightCalibration:(CGFloat)maxHeightCalibration
{
    _maxHeightCalibration = maxHeightCalibration;
    [self drawCalibrationWithRect:self.bounds];
}

#pragma mark - get

-(CALayer *)calibrationLayer
{
    if (!_calibrationLayer) {
        _calibrationLayer = [CALayer layer];
        _calibrationLayer.backgroundColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:_calibrationLayer];
    }
    return _calibrationLayer;
}

-(CAShapeLayer *)borderLayer
{
    if (!_borderLayer) {
        _borderLayer = [CAShapeLayer layer];
        _borderLayer.fillColor = [UIColor clearColor].CGColor;
        _borderLayer.lineCap = kCALineCapRound;
        [self.layer addSublayer:_borderLayer];
    }
    return _borderLayer;
}

#pragma mark - private

-(void)removeAllSubLayer:(CALayer *)layer
{
    NSArray *aryTemp = [layer.sublayers copy];
    [aryTemp enumerateObjectsUsingBlock:^(CALayer * _Nonnull subLayer, NSUInteger idx, BOOL * _Nonnull stop) {
        [subLayer removeFromSuperlayer];
    }];
}

#pragma mark - draw

-(void)drawBorderWithRect:(CGRect)rect
{
    self.borderLayer.frame = rect;
    
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    CGPoint center = CGPointMake(width/2, height/2);
    CGFloat diameter = MIN(width, height);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:(diameter - self.lineBorder) / 2.f - self.borderMargin startAngle:0 * pi180  endAngle:360 * pi180 clockwise:YES];
    
    self.borderLayer.strokeColor = self.colorBorder.CGColor;
    self.borderLayer.lineWidth = self.lineBorder;
    self.borderLayer.path = [path CGPath];
}

-(void)drawCalibrationWithRect:(CGRect)rect
{
    [self removeAllSubLayer:self.calibrationLayer];
    
    // border
    CGFloat framelineBorder = self.lineBorder;    //邊框
    CGFloat framelineMargin = self.borderMargin;   // 外邊距
    CGFloat framelinePadding = self.borderPadding;  // 內邊距
    // 刻度
    CGFloat perNumber = self.perNumber;
    CGFloat startAngle = self.startAngle;
    UIColor *colorLine = self.colorCalibration;
    CGFloat lineHeight = self.maxHeightCalibration;
    
    self.calibrationLayer.frame = rect;
    CGRect frame = self.calibrationLayer.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGPoint center = CGPointMake(width/2, height/2);
    CGFloat diameter = MIN(width, height);
    
    CGFloat perAngle = 360 / perNumber;
    CGFloat lineWidth;
    
    for (int i = 0; i < perNumber; i++) {
        
        CGFloat lineAngle = startAngle + i * perAngle;
        CGFloat tempLineHeight;
        
        CGFloat textAngle = (195 - i * perAngle) * pi180;
        lineWidth = (1/5.f);
        
        CAShapeLayer *perLayer = [CAShapeLayer layer];
        perLayer.fillColor = [UIColor clearColor].CGColor;
        perLayer.lineCap = kCALineCapButt;
        perLayer.strokeColor = colorLine.CGColor;
        
        if ((int)lineAngle % 45 == 0) {
            lineWidth *= 4;
            tempLineHeight = lineHeight;
        }else if (i % 5 == 0) {
            lineWidth *= 2;
            tempLineHeight = lineHeight * 2 / 3;
            
            //            CGPoint point = [self calcCircleCoordinateWithCenter:center andWithAngle:textAngle andWithRadius:125];
            //            NSString *valueString = [NSString stringWithFormat:@"%d",i * 2];
            //
            //            UIFont* font = [UIFont fontWithName:@"Helvetica-Bold" size:7];
            //            UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(point.x - 5, point.y - 5, 12, 12)];
            //            text.text = valueString;
            //            text.font = font;
            //            text.textColor = [UIColor colorWithRed:0.54 green:0.78 blue:0.91 alpha:1.0];
            //            text.textAlignment = NSTextAlignmentCenter;
            //            [self addSubview:text];
            
        }
        else
        {
            tempLineHeight = lineHeight * 1 / 3;
        }
        
        struct HTWCompassViewLine line;
        line.height = tempLineHeight;
        line.width = lineWidth;
        
        if ([self.delegate respondsToSelector:@selector(compassView:drawIndex:angle:line:)]) {
            
            line = [self.delegate compassView:self drawIndex:i angle:lineAngle line:line];
        }
        
        CGFloat diameterCalibration = diameter - line.height;
        CGFloat borderCalibration = framelineBorder + framelineMargin + framelinePadding;
        
        CGFloat lineStartAngle = (lineAngle - line.width / 2) * pi180;
        CGFloat lineEndAngle = (lineAngle + line.width / 2) * pi180;
        UIBezierPath *perPath = [UIBezierPath bezierPathWithArcCenter:center radius:diameterCalibration / 2.f - borderCalibration startAngle:lineStartAngle endAngle:lineEndAngle clockwise:YES];
        perLayer.lineWidth = line.height;
        perLayer.path = [perPath CGPath];
        
        [self.calibrationLayer addSublayer:perLayer];
    }
}

@end
