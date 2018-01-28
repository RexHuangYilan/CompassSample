//
//  HTWCalibrationView.m
//  CompassSample
//
//  Created by Rex on 2018/1/21.
//  Copyright © 2018年 Rex. All rights reserved.
//

#import "HTWCalibrationView.h"

static CGFloat const pi180 = M_PI / 180;

@interface HTWCalibrationView ()

// 刻度
@property (nonatomic, strong) CALayer *calibrationLayer;
// 邊框
@property (nonatomic, strong) CAShapeLayer *borderLayer;
// 刻度畫面
@property (nonatomic, strong) UIView *calibrationView;

@end

@implementation HTWCalibrationView

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
    [self drawBorder];
    [self drawCalibration];
    [self drawCalibrationView];
}

#pragma mark - set

-(void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
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
    [self drawCalibration];
}

-(void)setStartAngle:(CGFloat)startAngle
{
    _startAngle = startAngle;
    [self drawCalibration];
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
    [self drawCalibration];
}

-(void)setViewMargin:(CGFloat)viewMargin
{
    _viewMargin = viewMargin;
    [self drawCalibrationView];
}

-(void)setHideCalibration:(BOOL)hideCalibration
{
    _hideCalibration = hideCalibration;
    self.calibrationLayer.hidden = hideCalibration;
}

-(void)setHideCalibrationView:(BOOL)hideCalibrationView
{
    _hideCalibrationView = hideCalibrationView;
    self.calibrationView.hidden = hideCalibrationView;
}

-(void)setHideBorder:(BOOL)hideBorder
{
    _hideBorder = hideBorder;
    self.borderLayer.hidden = hideBorder;
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

-(UIView *)calibrationView
{
    if (!_calibrationView) {
        _calibrationView = [UIView new];
        _calibrationView.backgroundColor = [UIColor clearColor];
        [self addSubview:_calibrationView];
    }
    return _calibrationView;
}

-(CGFloat)radiusBorder
{
    CGRect frame = self.bounds;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat diameter = MIN(width, height);
    CGFloat radiusBorder = (diameter - self.lineBorder) / 2.f - self.borderMargin;
    return radiusBorder;
}

#pragma mark - private

-(void)removeAllSubLayer:(CALayer *)layer
{
    NSArray *aryTemp = [layer.sublayers copy];
    [aryTemp enumerateObjectsUsingBlock:^(CALayer * _Nonnull subLayer, NSUInteger idx, BOOL * _Nonnull stop) {
        [subLayer removeFromSuperlayer];
    }];
}

-(void)removeAllSubViews:(UIView *)superView
{
    NSArray *aryTemp = [superView.subviews copy];
    [aryTemp enumerateObjectsUsingBlock:^(UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        [view removeFromSuperview];
    }];
}

-(CGPoint)calcCircleCoordinateWithCenter:(CGPoint)center
                            andWithAngle:(CGFloat)angle
                           andWithRadius:(CGFloat)radius
{
    CGFloat x2 = radius * cosf(angle);
    CGFloat y2 = radius * sinf(angle);
    return CGPointMake(center.x + x2, center.y - y2);
}

#pragma mark - draw

-(void)drawBorderWithRect:(CGRect)rect
{
    self.borderLayer.frame = rect;
    
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    CGPoint center = CGPointMake(width/2, height/2);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:self.radiusBorder startAngle:0 * pi180  endAngle:360 * pi180 clockwise:YES];
    
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
        
        CGFloat angle = i * perAngle;
        
        lineWidth = (1/5.f);
        
        CAShapeLayer *perLayer = [CAShapeLayer layer];
        perLayer.fillColor = [UIColor clearColor].CGColor;
        perLayer.lineCap = kCALineCapButt;
        perLayer.strokeColor = colorLine.CGColor;
        
        struct HTWCalibrationViewLine line;
        line.height = lineHeight;
        line.width = lineWidth;
        
        if ([self.delegate respondsToSelector:@selector(calibrationView:drawIndex:angle:line:)])
        {
            line = [self.delegate calibrationView:self drawIndex:i angle:angle line:line];
        }
        
        CGFloat diameterCalibration = diameter - line.height;
        CGFloat borderCalibration = framelineBorder + framelineMargin + framelinePadding;
        CGFloat lineAngle = startAngle + angle;
        
        CGFloat lineStartAngle = (lineAngle - line.width / 2) * pi180;
        CGFloat lineEndAngle = (lineAngle + line.width / 2) * pi180;
        UIBezierPath *perPath = [UIBezierPath bezierPathWithArcCenter:center radius:diameterCalibration / 2.f - borderCalibration startAngle:lineStartAngle endAngle:lineEndAngle clockwise:YES];
        perLayer.lineWidth = line.height;
        perLayer.path = [perPath CGPath];
        
        [self.calibrationLayer addSublayer:perLayer];
    }
}

-(void)drawCalibrationViewWithRect:(CGRect)rect
{
    [self removeAllSubViews:self.calibrationView];
    
    // 刻度
    CGFloat perNumber = self.perNumber;
    
    self.calibrationView.frame = rect;
    CGRect frame = self.calibrationLayer.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGPoint center = CGPointMake(width/2, height/2);
    
    CGFloat perAngle = 360 / perNumber;
    CGFloat radius = self.radiusBorder + self.viewMargin;
    
    for (int i = 0; i < perNumber; i++) {
        
        CGFloat angle = i * perAngle;
        CGFloat textAngle = (90 - i * perAngle) * pi180;
        
        CGPoint point = [self calcCircleCoordinateWithCenter:center andWithAngle:textAngle andWithRadius:radius];
        
        if ([self.delegate respondsToSelector:@selector(calibrationView:drawViewIndex:angle:viewCenter:)]) {
            
            UIView *view = [self.delegate calibrationView:self drawViewIndex:i angle:angle viewCenter:&point];
            if (view) {
                view.center = point;
                
                [self.calibrationView addSubview:view];
            }
        }
    }
}

#pragma mark - public

-(void)reDraw
{
    [self drawBorder];
    [self drawCalibration];
    [self drawCalibrationView];
}

-(void)drawCalibration
{
    [self drawCalibrationWithRect:self.bounds];
}

-(void)drawCalibrationView
{
    [self drawCalibrationViewWithRect:self.bounds];
}

-(void)drawBorder
{
    [self drawBorderWithRect:self.bounds];
}

@end
