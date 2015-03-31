//
//  AppDelegate.h
//  Partam
//
//  Created by Sargis Gevorgyan on 2/24/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VKSdk.h>
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)CLLocationManager * locationManager;
@end
