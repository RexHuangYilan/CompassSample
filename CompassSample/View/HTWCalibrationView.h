//
//  HTWCalibrationView.h
//  CompassSample
//
//  Created by Rex on 2018/1/21.
//  Copyright © 2018年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HTWCalibrationView;

/*!
 刻度結構
 */
struct HTWCalibrationViewLine {
    /// 寬
    CGFloat width;
    /// 高
    CGFloat height;
};


@protocol HTWCalibrationViewDelegate <NSObject>

-(struct HTWCalibrationViewLine)calibrationView:(HTWCalibrationView *)calibrationView
                                      drawIndex:(NSUInteger)index
                                          angle:(CGFloat)angle
                                           line:(struct HTWCalibrationViewLine)line;

-(UIView *)calibrationView:(HTWCalibrationView *)calibrationView
             drawViewIndex:(NSUInteger)index
                     angle:(CGFloat)angle
                viewCenter:(CGPoint *)viewCenter;

@end

IB_DESIGNABLE
@interface HTWCalibrationView : UIView

#pragma mark - Border

/*!
 邊框
 */
@property (nonatomic) IBInspectable CGFloat lineBorder;

/*!
 外邊距
 */
@property (nonatomic) IBInspectable CGFloat borderMargin;

/*!
 內邊距
 */
@property (nonatomic) IBInspectable CGFloat borderPadding;

/*!
 邊框顏色
 defalut Black
 */
@property (nonatomic, strong) IBInspectable UIColor *colorBorder;

#pragma mark - Calibration

/*!
 分成幾格
 Max 360
 Min 1
 defalut 360
 */
@property (nonatomic) IBInspectable NSUInteger perNumber;

/*!
 起始角度
 上:-90 下:90 左:180 右:0
 defalut -90
 */
@property (nonatomic) IBInspectable CGFloat startAngle;

/*!
 刻度顏色
 defalut Black
 */
@property (nonatomic, strong) IBInspectable UIColor *colorCalibration;

/*!
 最大刻度長度
 defalut 20
 */
@property (nonatomic) IBInspectable CGFloat maxHeightCalibration;

#pragma mark - Calibration View

/*!
 顯示畫面的外邊距
 */
@property (nonatomic) IBInspectable CGFloat viewMargin;

#pragma mark -

/*!
 Delegate
 */
@property (nonatomic, weak) IBOutlet id<HTWCalibrationViewDelegate> delegate;

/*!
 隱藏刻度
 */
@property (nonatomic) IBInspectable BOOL hideCalibration;

/*!
 隱藏刻度提示
 */
@property (nonatomic) IBInspectable BOOL hideCalibrationView;

/*!
 隱藏邊框
 */
@property (nonatomic) IBInspectable BOOL hideBorder;

/*!
 重畫
 */
-(void)reDraw;

/*!
 重畫刻度
 */
-(void)drawCalibration;

/*!
 重畫刻度提示
 */
-(void)drawCalibrationView;

/*!
 重畫邊框
 */
-(void)drawBorder;

@end
