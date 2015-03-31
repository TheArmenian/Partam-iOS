//
//  MainViewController.h
//  Partam
//
//  Created by Sargis Gevorgyan on 2/24/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMExampleDrawerVisualStateManager.h"
#import "WebImage.h"
#import "GridView.h"
#import "LoginViewController.h"
#import "DetailViewController.h"
#import <MapKit/MapKit.h>
#import "CustomPointAnnotation.h"

@interface MainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MMDrawerControllerDelegate,MKMapViewDelegate,AppManagerDelegate> {
    
        
    IBOutlet MKMapView *mkMapView;
    
    
    int mAIndex;
    
    BOOL isUpdated;
    
    UIBarButtonItem *rightBarButton;
    UIButton * rightButton;
}
@property(nonatomic) BOOL isAbout;
@property(nonatomic,strong)UILabel * lblWarning;
@property(nonatomic,strong)IBOutlet UIView *loadingView;
@property(nonatomic,retain) NSMutableArray * webInfoArray;
@property(nonatomic,assign)BOOL isCanLoaded;
@property(nonatomic,strong)IBOutlet UITableView *mainTblView;
@property(nonatomic,assign)int count;
@property(nonatomic,assign)int limit;
@property(nonatomic,assign)int selectedCitylimit;
@property(nonatomic,assign)int selectedCityCategorylimit;
@property(nonatomic,assign)int selectedCategorylimit;
@property(nonatomic,assign)BOOL isCanLoadedPointByCity;
@property(nonatomic,assign)BOOL isCanLoadedPointByCityAndCategory;
@property(nonatomic,assign)BOOL isCanLoadedPointByCategory;
@property(nonatomic,strong)NSDictionary * city;
@property(nonatomic,strong)NSString * categoriresID;

-(void)sendLoadPointsRequest;
@end
