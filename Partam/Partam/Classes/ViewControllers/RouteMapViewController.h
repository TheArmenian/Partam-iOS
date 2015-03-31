//
//  RouteMapViewController.h
//  Partam
//
//  Created by Sargis Gevorgyan on 3/5/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "WebImage.h"

@interface RouteMapViewController : UIViewController<MKMapViewDelegate> {
    CLPlacemark *thePlacemark;
    MKRoute *routeDetails;
    
    IBOutlet MKMapView *routeMapView;
}
@property(nonatomic,strong)NSMutableDictionary * webInfo;
@property(nonatomic,strong)NSString * category;
@property(nonatomic,strong)NSDictionary * pointCategoryInfo;
@end
