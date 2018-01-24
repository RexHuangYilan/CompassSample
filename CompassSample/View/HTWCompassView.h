//
//  HTWCompassView.h
//  CompassSample
//
//  Created by Rex on 2018/1/21.
//  Copyright © 2018年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HTWCompassView;

/*!
 刻度結構
 */
struct HTWCompassViewLine {
    /// 寬
    CGFloat width;
    /// 高
    CGFloat height;
};


@protocol HTWCompassViewDelegate <NSObject>

-(struct HTWCompassViewLine)compassView:(HTWCompassView *)compassView drawIndex:(NSUInteger)index angle:(CGFloat)angle line:(struct HTWCompassViewLine)line;

@end

IB_DESIGNABLE
@interface HTWCompassView : UIView

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

#pragma mark - Border

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

#pragma mark -

/*!
 Delegate
 */
@property (nonatomic, weak) IBOutlet id<HTWCompassViewDelegate> delegate;

@end
