//
//  CompassView.h
//  CompassSample
//
//  Created by Rex on 2018/1/26.
//  Copyright © 2018年 Rex. All rights reserved.
//

#import "HTWCalibrationView.h"
#import <CoreLocation/CoreLocation.h>



IB_DESIGNABLE
@interface CompassView : HTWCalibrationView <HTWCalibrationViewDelegate>

/*!
 字型顏色
 defalut Black
 */
@property (nonatomic, strong) IBInspectable UIColor * _Nonnull colorFont;

/*!
 東西南北字型大小
 */
@property (nonatomic) IBInspectable CGFloat fourSideFontSize;

/*!
 斜角字型大小
 */
@property (nonatomic) IBInspectable CGFloat bevelSideFontSize;

/*!
 角度字型大小
 */
@property (nonatomic) IBInspectable CGFloat angleFontSize;

/*!
 角度字型大小
 */
@property (nonatomic, strong, null_resettable) IBOutlet UIView *compassPointerView;

/*!
 北方角度
 */
@property (nonatomic, weak) CLHeading * _Nullable heading;


@end
