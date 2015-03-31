//
//  AppDelegate.m
//  Partam
//
//  Created by Sargis Gevorgyan on 2/24/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuViewController.h"
#import "LoginViewController.h"
#import "MMDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "MainViewController.h"
#import <Crashlytics/Crashlytics.h>
#import "Flurry.h"
#import "FlurryAds.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSString *bundledPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"PartamPathImages"];
    [[SDImageCache sharedImageCache] addReadOnlyCachePath:bundledPath];
    
    [Crashlytics startWithAPIKey:@"62a680b0c5ad254be2c5f84a3d5895bba2b9ad34"];
        
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    if (IOS_VERSION >= 7.0) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:193.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:1.0]];
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * leftSideDrawerViewController = [storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    
    [leftSideDrawerViewController setModalPresentationStyle:UIModalPresentationFullScreen];
    
    MainViewController * centerViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
//    [centerViewController setModalPresentationStyle:UIModalPresentationFullScreen];
    
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:centerViewController];
    
    MMDrawerController * drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:navigationController
                                             leftDrawerViewController:leftSideDrawerViewController
                                             rightDrawerViewController:nil];
    [drawerController setMaximumLeftDrawerWidth:265.0];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
//    [drawerController
//     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
//         MMDrawerControllerDrawerVisualStateBlock block;
//         block = [[MMExampleDrawerVisualStateManager sharedManager]
//                  drawerVisualStateBlockForDrawerSide:drawerSide];
//         if(block){
//             block(drawerController, drawerSide, percentVisible);
//         }
//     }];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:drawerController];
    self.window.translatesAutoresizingMaskIntoConstraints =YES;
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    if ([AppManager sharedInstance].token.length > 0) {
        [[AppManager sharedInstance] loadUserInfo];
    }
    
    [Flurry startSession:@"K6T6C255SDRGG9TFZ5VX"];
    [FlurryAds initialize:self.window.rootViewController];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.distanceFilter = 50;
    [AppManager sharedInstance].currentLocation = self.locationManager.location;
    if (IOS_VERSION >= 8.0) {
        [self.locationManager requestAlwaysAuthorization];
        NSLog(@"%f,%f",self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude);
    } else {
        [self.locationManager startUpdatingLocation];
    }
    
    
    return YES;

}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSString *stringUrl = [url absoluteString];
    if ([stringUrl rangeOfString:@"pin1440129prod://"].location != NSNotFound) {
        return YES;
    }
    if ([stringUrl rangeOfString:@"vk4553914://"].location != NSNotFound) {
        [VKSdk processOpenURL:url fromApplication:sourceApplication];
        return YES;
    }
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    NSString *newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
	NSLog(@"My token is: %@", newToken);
    
    NSString *url = [NSString stringWithFormat:@"%@/devicetokens/news",[AppManager sharedInstance].apiURL];
    NSString *postString = [NSString stringWithFormat:@"type=ios&token=%@", newToken];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
	[NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    
}

#pragma mark CLLocationManagerDelegate
- (void)requestAlwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        [alertView show];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (!oldLocation || (oldLocation.coordinate.latitude != newLocation.coordinate.latitude && oldLocation.coordinate.longitude != newLocation.coordinate.longitude)) {
        [AppManager sharedInstance].currentLocation = newLocation;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}
@end
