//
//  RouteMapViewController.m
//  Partam
//
//  Created by Sargis Gevorgyan on 3/5/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import "RouteMapViewController.h"
#import "CustomPointAnnotation.h"

@interface RouteMapViewController ()

@end

@implementation RouteMapViewController
 static NSString * str = nil;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    str = nil;
    if (IOS_VERSION >= 7.0) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:193.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:1.0]];
        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btnBack.png"] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonPress:)];
        
        self.navigationItem.leftBarButtonItem = leftButton;
        
        
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:193.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:1.0]];
        //        [self.navigationController.navigationBar setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgNavigationBar"]]];
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, 27, 27);
        [leftButton setImage:[UIImage imageNamed:@"btnBack.png"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        
    }
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logotxt.png"]];
    [self showRoatMapView];
	// Do any additional setup after loading the view.
}
- (void)showRoatMapView {
    routeMapView.userInteractionEnabled = YES;
    routeMapView.delegate = self;
    [routeMapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
   
    if (!str) {
        str = @"showMap";
        MKCoordinateRegion region;
        float spanX = 0.04;
        float spanY = 0.04;
        
        
        CLLocationCoordinate2D annotationCoord;
        annotationCoord.latitude = [[self.webInfo valueForKey:@"lat"]floatValue];
        annotationCoord.longitude = [[self.webInfo valueForKey:@"lng"]floatValue];
        
        thePlacemark = [[MKPlacemark alloc]initWithCoordinate:annotationCoord addressDictionary:nil];
        
        region.center.latitude = thePlacemark.location.coordinate.latitude;
        region.center.longitude = thePlacemark.location.coordinate.longitude;
        region.span = MKCoordinateSpanMake(spanX, spanY);
        [routeMapView setRegion:region animated:YES];
        CustomPointAnnotation *point = [[CustomPointAnnotation alloc] init];
        point.coordinate = CLLocationCoordinate2DMake(thePlacemark.location.coordinate.latitude, thePlacemark.location.coordinate.longitude);
        point.title = [self.webInfo valueForKey:@"name"];
        point.subtitle = self.category;
        [routeMapView addAnnotation:point];
        point.pointInfo = self.webInfo;
        
        MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:thePlacemark];
        [directionsRequest setSource:[MKMapItem mapItemForCurrentLocation]];
        [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:placemark]];
        directionsRequest.transportType = MKDirectionsTransportTypeAutomobile;
        MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
            if (error) {
                NSLog(@"Error %@", error.description);
            } else {
                routeDetails = response.routes.lastObject;
                [routeMapView addOverlay:routeDetails.polyline];
                
            }
        }];
    }
}
-(void)leftButtonPress:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark MKMapVewDelegate methods
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor redColor];
    polylineView.lineWidth = 5.0;
    
    return polylineView;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotationPoint
{
    CustomPointAnnotation *annotation = (CustomPointAnnotation*)annotationPoint;
    MKAnnotationView *pinView = nil;
    
    if([annotationPoint isKindOfClass:[MKUserLocation class]] && mapView.tag == 1)  {
        return nil;
        MKAnnotationView *userLocationView = [mapView viewForAnnotation:annotationPoint];
        userLocationView.canShowCallout = NO;
        userLocationView.enabled=YES;
        mapView.showsUserLocation = YES;
        [mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
        [mapView selectAnnotation:userLocationView.annotation animated:YES];
        NSLog(@"[annotation isKindOfClass:[MKUserLocation class]");
        
        return userLocationView;
        
    }
    
    
    if(annotationPoint != routeMapView.userLocation) {
//         NSDictionary * dict =annotation.pointInfo;
//        int tag = [[dict valueForKey:@"id"] intValue];
        pinView = (MKAnnotationView *)[routeMapView dequeueReusableAnnotationViewWithIdentifier:@"123"];
        if(!pinView){
            pinView = [[MKAnnotationView alloc]  initWithAnnotation:annotation
                                                    reuseIdentifier:@"123"];
            UIView * annotationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 160, 100)];
            annotationView.backgroundColor = [UIColor clearColor];
            UIImageView * defoultImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 35, 35)];
            [defoultImg setImage:[UIImage imageNamed:@"defaultProfileImage.png"]];
            [annotationView addSubview:defoultImg];
            
            
            WebImage *img = [[WebImage alloc] initWithFrame:CGRectMake(5, 5 , 35, 35)];
            __weak WebImage * webImage = img;
            [webImage setImageURL:[self.webInfo valueForKey:@"picture"] completion:^(UIImage *image) {
                CGRect cropFrame = CGRectMake(0, 0, webImage.frame.size.width, webImage.frame.size.height);
                float q;
                if (image.size.width > image.size.height) {
                    q= image.size.height/cropFrame.size.height;
                } else {
                    q = image.size.width/cropFrame.size.width;
                }
                float coverHeight = image.size.height/q;
                float coverWidht = image.size.width/q;
                CGRect latestFrame = CGRectMake((cropFrame.size.width - coverWidht)/2, (cropFrame.size.height - coverHeight)/2, coverWidht, coverHeight);
                UIImage * coverImg =[AppManager cropImage_cropFrame:cropFrame latestFrame:latestFrame originalImage:image];
                webImage.image = coverImg;
            }];
            [annotationView addSubview:webImage];
            UIImageView * favImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
            [favImg setImage:[UIImage imageNamed:@"bgFavImg.png"]];
            if ([[self.webInfo valueForKey:@"promoted"]integerValue] == 1) {
                [annotationView addSubview:favImg];
            }
            
            UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(42, 0, 123, 30)];
            title.backgroundColor = [UIColor clearColor];
            title.textColor = [UIColor blackColor];
            title.textAlignment = NSTextAlignmentLeft;
            title.numberOfLines = 2;
            [title setFont:[UIFont systemFontOfSize:8.0f]];
            title.text = annotation.title;
            [annotationView addSubview:title];
            
            UIImageView * memorial = [[UIImageView alloc]initWithFrame:CGRectMake(43, 27, 11, 8)];
            [memorial setImage:[UIImage imageNamed:@"memorial.png"]];
            [annotationView addSubview:memorial];
            
            UILabel * subTitle = [[UILabel alloc]initWithFrame:CGRectMake(55, 22, 100, 20)];
            subTitle.backgroundColor = [UIColor clearColor];
            subTitle.textColor = [UIColor colorWithRed:44.0/225.0 green:153.0/255.0 blue:215.0/255.0 alpha:1];
            subTitle.textAlignment = NSTextAlignmentLeft;
            subTitle.numberOfLines = 1;
            [subTitle setFont:[UIFont systemFontOfSize:8.0f]];
            subTitle.text = annotation.subtitle;
            [annotationView addSubview:subTitle];
            
           

            WebImage * categoryImg =[[WebImage alloc] initWithFrame:CGRectMake(0, 0, 27, 27)];
            [categoryImg setImageURL:[NSString stringWithFormat:@"http://partam.partam.com%@",[self.pointCategoryInfo valueForKey:@"icon_url"]] completion:^(UIImage *image) {
                pinView.image = [WebImage imageByScalingAndCropping:image forSize:CGSizeMake(27, 27)];
            }];
            
            [categoryImg hideActivityIndicator];
            categoryImg.backgroundColor = [UIColor clearColor];
        
            [pinView setLeftCalloutAccessoryView:annotationView];
            pinView.canShowCallout = YES;
            [pinView setEnabled:YES];
//            pinView.image = [[AppManager sharedInstance] getMapCategoryImage:self.category];
            annotation.title = @" ";
            annotation.subtitle = @" ";
            //            pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
            //                [pinView setAnnotation:annotation];
            
            annotationView = nil;
            defoultImg = nil;
            webImage = nil;
            title = nil;
            subTitle = nil;
            memorial = nil;
            favImg = nil;
        }
    }
    
	return pinView;
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    for (NSObject *annotation in [mapView annotations])
    {
        if ([annotation isKindOfClass:[MKUserLocation class]])
        {
            NSLog(@"Bring blue location dot to front");
            MKAnnotationView *view = [mapView viewForAnnotation:(MKUserLocation *)annotation];
            [[view superview] bringSubviewToFront:view];
        }
    }
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
