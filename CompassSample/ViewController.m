//
//  ViewController.m
//  CompassSample
//
//  Created by Rex on 2018/1/16.
//  Copyright © 2018年 Rex. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationM;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    self.locationM = [[CLLocationManager alloc] init];
    //設置代理
    self.locationM.delegate = self;
    //開始更新設備朝向
    [self.locationM startUpdatingHeading];
}

-(void)locationManager:(nonnull CLLocationManager *)manager didUpdateHeading:(nonnull CLHeading *)newHeading
{
    // 小於0是不正確的
    if (newHeading.headingAccuracy < 0) {
        return;
    }
    
    // 取得向北的角度
    CGFloat angle = newHeading.magneticHeading;
    
    // 轉探弧度
    CGFloat radian = angle / 180.0 * M_PI;
    
    NSLog(@"radian:%f",radian);
    // 反轉
    [UIView animateWithDuration:0.5 animations:^{
//        self.compassView.transform = CGAffineTransformMakeRotation(-radian);
    }];
}

@end
