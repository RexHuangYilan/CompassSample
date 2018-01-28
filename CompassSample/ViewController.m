//
//  ViewController.m
//  CompassSample
//
//  Created by Rex on 2018/1/16.
//  Copyright © 2018年 Rex. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "CompassView.h"

@interface ViewController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationM;
@property (weak, nonatomic) IBOutlet CompassView *compassView;

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
    self.compassView.heading = newHeading;
//    // 小於0是不正確的
//    if (newHeading.headingAccuracy < 0) {
//        return;
//    }
//    
//    // 取得向北的角度
//    CGFloat angle = newHeading.magneticHeading;
//    
//    NSLog(@"angle:%f",angle);
//    
//    // 轉探弧度
//    CGFloat radian = angle / 180.0 * M_PI;
//    
//    NSLog(@"radian:%f",radian);
//    // 反轉
//    [UIView animateWithDuration:0.5 animations:^{
//        self.compassView.compassPointerView.transform = CGAffineTransformMakeRotation(-radian);
//    }];
}

@end
