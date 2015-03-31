//
//  MainViewController.m
//  Partam
//
//  Created by Sargis Gevorgyan on 2/24/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import "MainViewController.h"
#import "AboutViewController.h"
#import "FlurryAds.h"
#import "MapViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize isAbout;

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
    self.loadingView.hidden = YES;
    
    self.lblWarning =[[UILabel alloc]initWithFrame:CGRectMake(0, self.view.center.y-85, 320, 70)];
    self.lblWarning.backgroundColor = [UIColor clearColor];
    self.lblWarning.textColor = [UIColor colorWithRed:193.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:1.0];
    self.lblWarning.text = @"Sorry nothing found";
    self.lblWarning.font = [UIFont systemFontOfSize:25];
    self.lblWarning.textAlignment = NSTextAlignmentCenter;
    self.lblWarning.hidden = YES;
    [self.view addSubview:self.lblWarning];
    [self.view bringSubviewToFront:mkMapView];
    self.loadingView.layer.cornerRadius = 10;
    self.mm_drawerController.delegate = self;
    self.count = 10;
    self.limit = 0;
    //    mkMapView.frame = CGRectMake(mkMapView.frame.size.width, 0, mkMapView.frame.size.width, mkMapView.frame.size.height);
    mkMapView.alpha = 0;
    mkMapView.delegate = self;
    
    self.isCanLoaded = YES;
    self.lblWarning.hidden = YES;
    [WebServiceManager loadPointInfo:self.count :self.limit completion:^(id response, NSError *error) {
        if (!error) {
            self.webInfoArray = response;
            [self.mainTblView reloadData];
        }
    }];
    if (IOS_VERSION >= 7.0) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:193.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:1.0]];
        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menuIcon.png"] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonPress:)];
        
        self.navigationItem.leftBarButtonItem = leftButton;
        rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 0, 27, 27);
        [rightButton setImage:[UIImage imageNamed:@"locationIcon.png"] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:@"locationIconSelected.png"] forState:UIControlStateSelected];
        [rightButton addTarget:self action:@selector(rightButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        //        rightBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"locationIcon.png"] style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonPress:)];
        //
        
        self.navigationItem.rightBarButtonItem = rightBarButton;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:193.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:1.0]];
        //        [self.navigationController.navigationBar setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgNavigationBar"]]];
        rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 0, 27, 27);
        [rightButton setImage:[UIImage imageNamed:@"locationIcon.png"] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:@"locationIconSelected.png"] forState:UIControlStateSelected];
        [rightButton addTarget:self action:@selector(rightButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, 27, 27);
        [leftButton setImage:[UIImage imageNamed:@"menuIcon.png"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        
    }
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logotxt.png"]];
    
    self.mainTblView.delegate = self;
    self.mainTblView.dataSource = self;
    
    //    self.webInfoArray =[[NSMutableArray alloc]initWithArray:[[AppManager sharedInstance] loadWebInfo:self.count :self.limit]];
    
    isUpdated = YES;
    [AppManager sharedInstance].delegate = self;
    
    
    [FlurryAds setAdDelegate:self];
    [FlurryAds fetchAndDisplayAdForSpace:@"fullscreen_ios" view:self.view viewController:self size:FULLSCREEN];
    
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (IOS_VERSION >= 7.0) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        
    }
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.mainTblView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [FlurryAds setAdDelegate:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  TableView Delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    //#warning Potentially incomplete method implementation.
    
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.webInfoArray.count == 0) {
        return 0;
    }
    
    if (indexPath.row == self.webInfoArray.count) {
        return 80;
    }
    return 320;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //#warning Incomplete method implementation.
    
    // Return the number of rows in the section.
    
    return (self.webInfoArray.count+(self.isCanLoaded?1:0));
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.webInfoArray.count == 0) {
//        self.lblWarning.hidden = NO;
//    } else {
//        self.lblWarning.hidden = YES;
//    }
//    NSLog(@"indexPath.Row = %d",indexPath.row);
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.webInfoArray.count) {
        
        NSDictionary * currentInfo = self.webInfoArray[indexPath.row];
        
        GridView * currentView = [[GridView alloc]initWithFrame:CGRectMake(0, 0, 320, 320) pointInfo:currentInfo];
        [cell addSubview:currentView];
    }
    if (isUpdated) {
        if (indexPath.row >= self.webInfoArray.count && self.isCanLoaded && self.webInfoArray.count != 0) {
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgCityLabel"]];
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
            
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 80)];
            spinner.center = CGPointMake(view.center.x, view.center.y);
            view.backgroundColor = [UIColor darkGrayColor];
            [view addSubview:spinner];
            [cell addSubview:view];
            [spinner startAnimating];
            [self performSelector:@selector(sendLoadPointsRequest) withObject:nil afterDelay:0];
            
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.webInfoArray.count) {
        return;
    }
    UINavigationController* centerViewController = (UINavigationController*)self.mm_drawerController.centerViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    NSDictionary * currentInfo = self.webInfoArray[indexPath.row];
    
    NSDictionary * categoryInfo;
    for (int i = 0; i < [AppManager sharedInstance].categoriesArray.count; i ++) {
        NSDictionary * info = [AppManager sharedInstance].categoriesArray[i];
        if ([[[currentInfo valueForKey:@"category"] valueForKey:@"id"] isEqual:[info valueForKey:@"id"]]) {
            categoryInfo = info;
            break;
        }
    }
    viewController.pointCategoryInfo = categoryInfo;
    viewController.mainInfo = currentInfo;
    //viewController.category = [[currentInfo valueForKey:@"category"] valueForKey:@"title"];
    
    [centerViewController pushViewController:viewController animated:YES];
    self.loadingView.hidden = YES;
    
}

-(void)sendLoadPointsRequest{
    [AppManager sharedInstance].isFilter = YES;
    if (self.isCanLoadedPointByCity) {
        
        [WebServiceManager loadPointByCity_latitude:[self.city valueForKey:@"lat"] longitude:[self.city valueForKey:@"lng"] limit:10 offSet:self.selectedCitylimit completion:^(id response, NSError *error) {
            if (!error) {
                [self changeTableViewInfo:response];
                self.selectedCitylimit+=10;
            }
            self.loadingView.hidden = YES;
            return ;
        }];
        //        [self.webInfoArray addObjectsFromArray:[[AppManager sharedInstance] loadPointByCity_latitude:[self.city valueForKey:@"lat"] longitude:[self.city valueForKey:@"lng"] limit:10 offSet:self.selectedCitylimit]];
        return;
    }
    if (self.isCanLoadedPointByCityAndCategory) {
        [WebServiceManager loadPointByCategoriesAndCity:self.categoriresID latitude:[self.city valueForKey:@"lat"] longitude:[self.city valueForKey:@"lng"] limit:10 offSet:self.selectedCityCategorylimit completion:^(id response, NSError *error) {
            if (!error) {
                [self changeTableViewInfo:response];
                self.selectedCityCategorylimit+=10;
            }
            self.loadingView.hidden = YES;
            return ;
        }];
        //        [self.webInfoArray addObjectsFromArray:[[AppManager sharedInstance] loadPointByCategoriesAndCity:self.categoriresID latitude:[self.city valueForKey:@"lat"] longitude:[self.city valueForKey:@"lng"] limit:10 offSet:self.selectedCityCategorylimit]];
        //        [self.mainTblView reloadData];
        return;
    }
    if (self.isCanLoadedPointByCategory) {
        [WebServiceManager loadPointByCategory:self.categoriresID limit:self.selectedCategorylimit completion:^(id response, NSError *error) {
            if (!error) {
                [self changeTableViewInfo:response];
            }
            self.loadingView.hidden = YES;
            self.selectedCategorylimit+=10;
            return;
        }];
        //        [self.webInfoArray addObjectsFromArray:[[AppManager sharedInstance]loadPointByCategory:self.categoriresID limit:self.selectedCategorylimit ]];
        //        [self.mainTblView reloadData];
        
        return;
    }
    [AppManager sharedInstance].isFilter = NO;
    self.limit+=10;
    [WebServiceManager loadPointInfo:self.count :self.limit completion:^(id response, NSError *error) {
        if (!error) {
            [self changeTableViewInfo:response];
        }
        self.loadingView.hidden = YES;
    }];
    ;
    
    
}

-(void)changeTableViewInfo:(NSArray*)response {
    if (self.webInfoArray.count == 0) {
        [self.webInfoArray addObjectsFromArray:response];
        if ([response count] < 10) {
            self.isCanLoaded = NO;
        }
        [self.mainTblView reloadData];
        if (self.webInfoArray.count == 0) {
            self.lblWarning.hidden = NO;
        } else {
            self.lblWarning.hidden = YES;
        }
    } else {
        
        if ([response count] > 0) {
            
            [self.mainTblView beginUpdates];
            
            NSMutableArray *indexPaths = [NSMutableArray new];
            
            for (int i = self.webInfoArray.count; i < self.webInfoArray.count + [response count]; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPaths addObject:indexPath];
            }
            
            [self.mainTblView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
            [self.webInfoArray addObjectsFromArray:response];
            
            [self.mainTblView endUpdates];
            
            if (self.webInfoArray.count == 0) {
                self.lblWarning.hidden = NO;
            } else {
                self.lblWarning.hidden = YES;
            }
        } else  {
            self.isCanLoaded = NO;
            NSMutableArray *indexPaths = [NSMutableArray new];
            
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.webInfoArray.count inSection:0];
            [indexPaths addObject:indexPath];
            
            
            [self.mainTblView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
            
        }
        
    }
    if (self.webInfoArray.count == 0) {
        self.lblWarning.hidden = NO;
    } else {
        self.lblWarning.hidden = YES;
    }
}

#pragma mark AppManagerDelegate Methods
-(void)upDateFailed {
    self.isCanLoaded = NO;
    [self.mainTblView reloadData];
}

-(void)upDateCompleted{
    [self.mainTblView reloadData];
}

#pragma mark - Button Handlers

-(void)leftButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)rightButtonPress:(id)sender{
    MapViewController * viewController =[self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    viewController.webInfoArray = self.webInfoArray;
    [self.navigationController pushViewController:viewController animated:YES];
    return;
    rightButton.selected = !rightButton.selected;
    if (!rightButton.selected) {
        [UIView animateWithDuration:0.3 animations:^{
            
            mkMapView.alpha = 0;
            
        }];
        
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
       
        mkMapView.alpha = 1;
        
    }];
    
    [mkMapView removeAnnotations:mkMapView.annotations];
    NSMutableArray * annotations =[NSMutableArray new];
    NSArray * array;
    if ([AppManager sharedInstance].isFilter) {
        array = self.webInfoArray;
    } else {
        array =[AppManager sharedInstance].allPoints;
    }
    mAIndex = array.count;
    for (int i = 0; i < array.count; i ++) {
        NSDictionary * currentInfo = array[i];
        
        CLLocationCoordinate2D annotationCoord;
        
        if (![[currentInfo valueForKey:@"lat"]isKindOfClass:[NSNull class]]) {
            annotationCoord.latitude = [[currentInfo valueForKey:@"lat"]floatValue];
        }
        if (![[currentInfo valueForKey:@"lng"] isKindOfClass:[NSNull class]]) {
            annotationCoord.longitude = [[currentInfo valueForKey:@"lng"]floatValue];
        }
        
        
        CustomPointAnnotation *annotationPoint = [[CustomPointAnnotation alloc] init];
        annotationPoint.coordinate = annotationCoord;
        if (![[currentInfo valueForKey:@"name"] isKindOfClass:[NSNull class]]) {
            annotationPoint.title = [currentInfo valueForKey:@"name"];
        }
        
        annotationPoint.pointInfo = currentInfo;
        
        if (![[currentInfo valueForKey:@"category"]isKindOfClass:[NSNull class]]) {
            if (![[[currentInfo valueForKey:@"category"] valueForKey:@"title"]isKindOfClass:[NSNull class]]) {
                annotationPoint.subtitle = [[currentInfo valueForKey:@"category"] valueForKey:@"title"];
            }
        }
        
        
        [annotations addObject:annotationPoint];
        if (IOS_VERSION < 7.0 ) {
            [mkMapView addAnnotation:annotationPoint];
        }
        annotationPoint = nil;
        
    }
    if (IOS_VERSION >= 7.0 ) {
        [mkMapView showAnnotations:annotations animated:YES];
    }
    annotations = nil;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(mkMapView.userLocation.coordinate, 10000, 10000);
    region.span = MKCoordinateSpanMake(0.04, 0.04);
    [mkMapView setRegion:region animated:YES];
}

#pragma mark MKMapVewDelegate methods
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotationPoint
{
    CustomPointAnnotation *annotation = (CustomPointAnnotation*)annotationPoint;
    MKAnnotationView *pinView = nil;
    int tag,index;
    NSArray * array;
    if ([AppManager sharedInstance].isFilter) {
        array = self.webInfoArray;
    } else {
        array =[AppManager sharedInstance].allPoints;
    }
    
    if(annotationPoint != mkMapView.userLocation) {
        NSDictionary * dict =annotation.pointInfo;
        pinView = (MKAnnotationView *)[mkMapView dequeueReusableAnnotationViewWithIdentifier:[[dict valueForKey:@"id"]stringValue]];
        
        if(!pinView){
            
            for (int i = 0; i < array.count; i++) {
                if ([dict isEqualToDictionary:array[i]]) {
                    tag = [[dict valueForKey:@"id"] integerValue];
                    index = i;
                    break;
                }
            }
            pinView = [[MKAnnotationView alloc]  initWithAnnotation:annotation reuseIdentifier:[[dict valueForKey:@"id"]stringValue]];
            
            UIView * annotationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 160, 100)];
            annotationView.backgroundColor = [UIColor clearColor];
            UIImageView * defoultImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 35, 35)];
            [defoultImg setImage:[UIImage imageNamed:@"defaultProfileImage.png"]];
            [annotationView addSubview:defoultImg];
            
            
            WebImage *webImage = [[WebImage alloc] initWithFrame:CGRectMake(5, 5 , 35, 35) imageURL:[dict valueForKey:@"picture"]];
            [annotationView addSubview:webImage];
            UIImageView * favImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
            [favImg setImage:[UIImage imageNamed:@"bgFavImg.png"]];
            if ([[dict valueForKey:@"promoted"]integerValue] == 1) {
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
            subTitle.textColor = [UIColor colorWithRed:44.0/255.0 green:153.0/255.0 blue:215.0/255.0 alpha:1];
            subTitle.textAlignment = NSTextAlignmentLeft;
            subTitle.numberOfLines = 1;
            [subTitle setFont:[UIFont systemFontOfSize:8.0f]];
            subTitle.text = annotation.subtitle;
            [annotationView addSubview:subTitle];
            
            UIButton * btn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 160, 100)];
            btn.tag = tag;
            [btn addTarget:self action:@selector(btnAnontationSelect:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = [UIColor clearColor];
            [annotationView addSubview:btn];
            
            
            [pinView setLeftCalloutAccessoryView:annotationView];
            pinView.canShowCallout = YES;
            [pinView setEnabled:YES];
//            if ([AppManager sharedInstance].isFilter) {
//                pinView.image = [[AppManager sharedInstance] getMapCategoryImage:annotation.subtitle];
//            } else {
//                NSDictionary * categoryInfo = [array[index] valueForKey:@"category"];
//                WebImage * categoryImg =[[WebImage alloc] initWithFrame:CGRectMake(0, 0, 27, 27)];
//                [categoryImg setImageURL:[categoryInfo valueForKey:@"icon_url"] completion:^(UIImage *image) {
//                    pinView.image = [WebImage imageByScalingAndCropping:image forSize:CGSizeMake(27, 27)];
//                }];
//                
//                [categoryImg hideActivityIndicator];
//                categoryImg.backgroundColor = [UIColor clearColor];
//                //                 [pinView addSubview:categoryImg];
//                //                 [pinView sendSubviewToBack:categoryImg];
//                
//            }
            
        
            NSDictionary * categoryInfo;
            for (int i = 0; i < [AppManager sharedInstance].categoriesArray.count; i ++) {
               NSDictionary * info = [AppManager sharedInstance].categoriesArray[i];
                if ([[[dict valueForKey:@"category"] valueForKey:@"id"] isEqual:[info valueForKey:@"id"]]) {
                    categoryInfo = info;
                    break;
                }
            }
            
            WebImage * categoryImg =[[WebImage alloc] initWithFrame:CGRectMake(0, 0, 27, 27)];
            [categoryImg setImageURL:[NSString stringWithFormat:@"http://partam.partam.com%@",[categoryInfo valueForKey:@"icon_url"]] completion:^(UIImage *image) {
                pinView.image = [WebImage imageByScalingAndCropping:image forSize:CGSizeMake(27, 27)];
            }];
            
            [categoryImg hideActivityIndicator];
            categoryImg.backgroundColor = [UIColor clearColor];
                        
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
        } else  {
            annotation.title = @" ";
            annotation.subtitle = @" ";
        }
    } else {
        return nil;
    }
    //    }
	return pinView;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
}

-(IBAction)btnAnontationSelect:(id)sender {
    UINavigationController* centerViewController = (UINavigationController*)self.mm_drawerController.centerViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    NSDictionary * currentInfo ;//= self.webInfoArray[[sender tag]];
    NSArray * filterArray =[[AppManager sharedInstance].allPoints filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id = %d",[sender tag]]];
    if (filterArray.count == 0) {
        filterArray =[self.webInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id = %d",[sender tag]]];
        
    }
    if (filterArray.count > 0) {
        currentInfo = filterArray[0];
    }
    
    NSDictionary * categoryInfo;
    for (int i = 0; i < [AppManager sharedInstance].categoriesArray.count; i ++) {
        NSDictionary * info = [AppManager sharedInstance].categoriesArray[i];
        if ([[[currentInfo valueForKey:@"category"] valueForKey:@"id"] isEqual:[info valueForKey:@"id"]]) {
            categoryInfo = info;
            break;
        }
    }
    // viewController.category = [[currentInfo valueForKey:@"category"] valueForKey:@"title"];
    viewController.mainInfo = currentInfo;
    viewController.pointCategoryInfo = categoryInfo;
    [centerViewController pushViewController:viewController animated:YES];
}


#pragma mark MMDrawerControllerDelegate method
-(void)viewControllerClosed:(NSDictionary*)withParams {
    
    NSString *action = [withParams valueForKey:@"action"];
    
    if ([action isEqual:@"about"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AboutViewController * aboutViewController = [storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
        [self.navigationController pushViewController:aboutViewController animated:NO];
        
    }
    
    if ([action isEqual:@"login"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController * loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        loginViewController.isFavorites = NO;
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}
@end

