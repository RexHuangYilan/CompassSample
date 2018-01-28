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
}

@end
