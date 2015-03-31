//
//  MapViewController.m
//  Partam
//
//  Created by Sargis_Gevorgyan on 12.09.14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "CustomPointAnnotation.h"
#import "DetailViewController.h"
#import "MapPhotoCell.h"
#import "LoginViewController.h"

#define kGeoCodingString @"http://maps.google.com/maps/geo?q=%f,%f&output=csv"

@interface MapViewController ()<MKMapViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,CLLocationManagerDelegate> {
    
    __weak IBOutlet MKMapView *mkMapView;
    NSInteger mAIndex;
    __weak IBOutlet UIView *viewAddNewPoint;
    __weak IBOutlet UIScrollView *scrlAddNewPoint;
    __weak IBOutlet UICollectionView *collectionPhotos;
    __weak IBOutlet UIButton *btnNext;
    __weak IBOutlet UIScrollView *scrlMain;
    __weak IBOutlet UIButton * btnHideKeyboard;
    __weak IBOutlet UIButton * btnHideKeyboard1;
    NSMutableArray * photosArray;
    
    UIImagePickerController * imagePicker;
    UIImagePickerController * cameraPicker;
    
    BOOL isAddNewPoint;
    
    __weak IBOutlet UITextField *txtName;
    __weak IBOutlet UITextField *txtCity;
    __weak IBOutlet UITextField *txtAddress;
    __weak IBOutlet UITextField *txtWeb;
    __weak IBOutlet UITextView *txtDescription;
    __weak IBOutlet UITextField *txtTags;
    __weak IBOutlet UITextField *txtPaypal;
    
    __weak IBOutlet UILabel *lblCategory;
    __weak IBOutlet UILabel *lblType;
    __weak IBOutlet UILabel *lblInfo;
    
    __weak IBOutlet UITableView *tblCategories;
    
    NSArray * categories;
    
    CLLocationCoordinate2D  newPlaceCoordinate;
    __weak IBOutlet UIView *viewGridNewPlace;
    __weak IBOutlet UIView *viewIsBusiness;
    
    CLPlacemark * placemark;
    __weak IBOutlet UIView *loading;
    CLLocationManager * cm;
}

@end

@implementation MapViewController

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
       
    if ([AppManager sharedInstance].currentLocation.coordinate.longitude == 0) {
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        [AppManager sharedInstance].currentLocation = locationManager.location;
    }
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btnBack.png"] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonPressed:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"mapBtnAdd.png"] style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonPressed:)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logotxt.png"]];
    viewAddNewPoint.alpha = 0;
    
    //mkMapView.showsUserLocation = YES;
    
    tblCategories.alpha = 0;
    
    categories = [AppManager sharedInstance].categoriesArray;
    
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    lpgr.minimumPressDuration = 1.0;  //user must press for 2 seconds
    [mkMapView addGestureRecognizer:lpgr];
    mkMapView.delegate = self;
    newPlaceCoordinate = mkMapView.userLocation.coordinate;
    [self setMapViewInfo];
    
    loading.layer.cornerRadius = 10;
    loading.hidden = YES;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if (btnNext.tag == 2) {
        [scrlAddNewPoint setContentOffset:CGPointMake(570, 0)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Handle UIGestureRecognizer

- (void)handleTapGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (isAddNewPoint) {
        isAddNewPoint = NO;
        newPlaceCoordinate = mkMapView.userLocation.coordinate;
        [self setMapViewInfo];
    }
    
}
- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:mkMapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [mkMapView convertPoint:touchPoint toCoordinateFromView:mkMapView];
    
    newPlaceCoordinate = touchMapCoordinate;
    isAddNewPoint = YES;
    [self setMapViewInfo];
}

#pragma mark - Button Handlers

-(void)leftButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightButtonPressed:(id)sender{
    
    photosArray = [NSMutableArray new];
    isAddNewPoint = YES;
    
    newPlaceCoordinate = mkMapView.userLocation.coordinate;
    [self setMapViewInfo];
    
    
}

-(void)setMapViewInfo {
    [mkMapView removeAnnotations:mkMapView.annotations];
    [mkMapView removeAnnotation:mkMapView.userLocation];
    for (id <MKAnnotation> annotation in mkMapView.annotations)
    {
        if ([annotation isKindOfClass:[MKUserLocation class]])
        {
            [mkMapView removeAnnotation:annotation];
        }
        
    }
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
        annotationPoint.isAddNewPoint = NO;
        if (![[currentInfo valueForKey:@"category"]isKindOfClass:[NSNull class]]) {
            if (![[[currentInfo valueForKey:@"category"] valueForKey:@"title"]isKindOfClass:[NSNull class]]) {
                annotationPoint.subtitle = [[currentInfo valueForKey:@"category"] valueForKey:@"title"];
            }
        }
        [annotations addObject:annotationPoint];
        
    }
    if (isAddNewPoint) {
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [mkMapView addGestureRecognizer:gesture];
        CustomPointAnnotation *annotationPoint = [[CustomPointAnnotation alloc] init];
        annotationPoint.coordinate = newPlaceCoordinate;
        [annotations addObject:annotationPoint];
        annotationPoint.isAddNewPoint = YES;
        mkMapView.showsUserLocation = NO;
        
    } else {
        mkMapView.showsUserLocation = YES;
        newPlaceCoordinate = [AppManager sharedInstance].currentLocation.coordinate;
    }
    
    [mkMapView showAnnotations:annotations animated:YES];
    
    annotations = nil;
    
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newPlaceCoordinate, 10000, 10000);
        region.span = MKCoordinateSpanMake(0.04, 0.04);
        [mkMapView setRegion:region animated:YES];
    
    for (CustomPointAnnotation * annotation in mkMapView.annotations)
    {
        if (![annotation isKindOfClass:[MKUserLocation class]]) {
            if (annotation.isAddNewPoint) {
                [mkMapView selectAnnotation:annotation animated:YES];
            }
        }
        
    }
}

-(void)btnAddNewPointSelected:(id)sender {
    txtName.text = @"";
    txtCity.text = @"";
    txtAddress.text = @"";
    txtDescription.text = @"";
    txtTags.text = @"";
    txtWeb.text = @"";
    txtPaypal.text = @"";
    lblCategory.text = @"";
    lblType.hidden = YES;
    lblInfo.hidden = YES;
    btnHideKeyboard.hidden = YES;
    btnHideKeyboard1.hidden = YES;
    photosArray = [NSMutableArray new];
    [collectionPhotos reloadData];
    
    [self getAddressFromLatLon:newPlaceCoordinate.latitude withLongitude:newPlaceCoordinate.longitude];
    
    [scrlAddNewPoint setContentOffset:CGPointMake(0, 0) animated:NO];
    [UIView animateWithDuration:0.3 animations:^{
        viewAddNewPoint.alpha = 1.0;
    }];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newPlaceCoordinate, 10000, 10000);
    region.span = MKCoordinateSpanMake(0.04, 0.04);
    [mkMapView setRegion:region animated:NO];
    
    CGPoint touchPoint = CGPointMake(viewGridNewPlace.center.x + (viewGridNewPlace.frame.size.width/2 - 42), viewGridNewPlace.center.y - (viewGridNewPlace.frame.size.height/2+10));
    CLLocationCoordinate2D touchMapCoordinate =
    [mkMapView convertPoint:touchPoint toCoordinateFromView:mkMapView];
    
    region = MKCoordinateRegionMakeWithDistance(touchMapCoordinate, 10000, 10000);
    region.span = MKCoordinateSpanMake(0.04, 0.04);
    [mkMapView setRegion:region animated:YES];
    
    for (CustomPointAnnotation * annotation in mkMapView.annotations)
    {
        if (annotation.isAddNewPoint) {
            [mkMapView deselectAnnotation:annotation animated:YES];
        }
    }
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
    
    viewController.mainInfo = currentInfo;
    viewController.pointCategoryInfo = categoryInfo;
    [centerViewController pushViewController:viewController animated:YES];
}

- (IBAction)btnHideNewAnnotationViewPressed:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        viewAddNewPoint.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        isAddNewPoint = NO;
        newPlaceCoordinate = mkMapView.userLocation.coordinate;
        [self setMapViewInfo];
        [self btnHideKeyBoardPressed:nil];
    }];
}

- (IBAction)btnNextPressed:(id)sender {
    if (btnNext.tag == 1) {
        if (scrlAddNewPoint.contentOffset.x == 0 & txtName.text.length == 0) {
            [AppManager showMessageBox:@"Please enter name!"];
            return;
        }
        
        [self btnHideKeyBoardPressed:nil];
        btnNext.userInteractionEnabled = NO;
        
        [scrlAddNewPoint setContentOffset:CGPointMake(scrlAddNewPoint.bounds.origin.x + scrlAddNewPoint.frame.size.width, 0) animated:NO];
    } else {
        [self sendRequest];
    }
    
}

-(void)sendRequest {
    if ([AppManager sharedInstance].isLogOut) {
        LoginViewController * viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        viewController.isFavorites = NO;
        [self.navigationController pushViewController:viewController animated:NO];
        return;
    }
    if (lblCategory.text.length == 0) {
        [AppManager showMessageBox:@"Please select the category first!"];
        return;
    }
    NSString * lng =[NSString stringWithFormat:@"%f",newPlaceCoordinate.longitude];
    NSString * lat =[NSString stringWithFormat:@"%f",newPlaceCoordinate.latitude];
    NSDictionary * userInfo = [[AppManager sharedInstance].userInfo valueForKey:@"user"];
    NSString * email = [userInfo valueForKey:@"email"];
    NSString * zip = @"";
    NSString * state = @"";
    if (placemark) {
        if (placemark.addressDictionary) {
            if ([placemark.addressDictionary valueForKey:@"ZIP"]) {
                if (![[placemark.addressDictionary valueForKey:@"ZIP"] isKindOfClass:[NSNull class]]) {
                    zip = [placemark.addressDictionary valueForKey:@"ZIP"];
                }
            }
            if ([placemark.addressDictionary valueForKey:@"State"]) {
                if (![[placemark.addressDictionary valueForKey:@"State"] isKindOfClass:[NSNull class]]) {
                    state = [placemark.addressDictionary valueForKey:@"State"];
                }
            }
        }
    }
    loading.hidden = NO;
    self.view.userInteractionEnabled = NO;
    [WebServiceManager add_new_point_name:txtName.text tags:txtTags.text category:lblCategory.text lng:lng lat:lat city:txtCity.text state:state address:txtAddress.text zip:zip email:email weburl:txtWeb.text description:txtDescription.text paypal:txtPaypal.text photos:photosArray completion:^(id response, NSError *error) {
        loading.hidden = YES;
        self.view.userInteractionEnabled = YES;
        if (!error) {
            if (response) {
                if ([response valueForKey:@"success"]) {
                    if ([[response valueForKey:@"success"] boolValue]) {
                        [AppManager showMessageBox:@"Your point add successfully"];
                        [self btnHideNewAnnotationViewPressed:nil];
                    }
                    else {
                        [AppManager showMessageBox:@"Something has gone wrong, please try again!"];
                    }
                } else {
                    [AppManager showMessageBox:@"Something has gone wrong, please try again!"];
                }
            } else {
                [AppManager showMessageBox:@"Something has gone wrong, please try again!"];
            }
        } else {
            [AppManager showMessageBox:error.localizedDescription];
        }
    }];
}

- (IBAction)btnAddNewPhotoPressed:(id)sender {
    NSString *actionSheetTitle = @"Choose Image";
    NSString *other1 = @"Take a Photo";
    NSString *other2 = @"Load from Photos Library";
    NSString *cancelTitle = @"Cancel";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other1, other2, nil];
    
    [actionSheet showInView:self.view];
}

- (IBAction)btnDeletePhotoPressed:(id)sender {
    [photosArray removeObjectAtIndex:[sender tag]];
    [collectionPhotos reloadData];
}

- (IBAction)btnHideKeyBoardPressed:(id)sender {
    btnHideKeyboard.hidden = YES;
    btnHideKeyboard1.hidden = YES;
    [txtName resignFirstResponder];
    [txtCity resignFirstResponder];
    [txtAddress resignFirstResponder];
    [txtWeb resignFirstResponder];
    [txtDescription resignFirstResponder];
    [txtTags resignFirstResponder];
    [txtPaypal resignFirstResponder];
    
    [scrlMain setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)btnCategoryPressed:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        tblCategories.alpha = 1;
    }];
}


#pragma mark MKMapVewDelegate methods

- (void)mapViewWillStartRenderingMap:(MKMapView *)mapView {
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotationPoint
{
    CustomPointAnnotation *annotation = (CustomPointAnnotation*)annotationPoint;
    MKAnnotationView *pinView = nil;
    
    
    if(annotationPoint != mkMapView.userLocation) {
        NSDictionary * dict =annotation.pointInfo;
        pinView = (MKAnnotationView *)[mkMapView dequeueReusableAnnotationViewWithIdentifier:[[dict valueForKey:@"id"]stringValue]];
        
        if(!pinView){
            
            if (annotation.isAddNewPoint) {
                pinView = [[MKAnnotationView alloc]  initWithAnnotation:annotation reuseIdentifier:@"AddNewPoint"];
            } else {
                pinView = [[MKAnnotationView alloc]  initWithAnnotation:annotation reuseIdentifier:[[dict valueForKey:@"id"]stringValue]];
            }
            
            
            [pinView setLeftCalloutAccessoryView:[self getAnontationView:annotation]];
            pinView.canShowCallout = YES;
            [pinView setEnabled:YES];
            
            NSDictionary * categoryInfo;
            for (int i = 0; i < [AppManager sharedInstance].categoriesArray.count; i ++) {
                NSDictionary * info = [AppManager sharedInstance].categoriesArray[i];
                if ([[[dict valueForKey:@"category"] valueForKey:@"id"] isEqual:[info valueForKey:@"id"]]) {
                    categoryInfo = info;
                    break;
                }
            }
            if (annotation.isAddNewPoint) {
                pinView.image = [UIImage imageNamed:@"mapLocationIcon.png"];
            } else {
                WebImage * categoryImg =[[WebImage alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
                [categoryImg setImageURL:[NSString stringWithFormat:@"http://partam.partam.com%@",[categoryInfo valueForKey:@"icon_url"]] completion:^(UIImage *image) {
                    pinView.image = [WebImage imageByScalingAndCropping:image forSize:CGSizeMake(27, 27)];
                }];
                
                [categoryImg hideActivityIndicator];
                categoryImg.backgroundColor = [UIColor clearColor];
            }
            annotation.title = @" ";
            annotation.subtitle = @" ";
            
        } else  {
            annotation.title = @" ";
            annotation.subtitle = @" ";
        }
        return pinView;
    } else {
        return nil;
    }
    return nil;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
}

-(UIView*)getAnontationView:(CustomPointAnnotation*)annotation {
    if (annotation.isAddNewPoint) {
        UIView * annotationView = [[UIView alloc]initWithFrame:CGRectMake(5, 0, 170, 100)];
        annotationView.backgroundColor = [UIColor clearColor];
        UILabel * lblTitle =[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 160, 30)];
        lblTitle.text = @"CONFIRM THE PLACE";
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.textColor =[UIColor colorWithRed:193.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:1.0];
        lblTitle.font =[UIFont fontWithName:@"Helvetica-Bold" size:15.0];
        [annotationView addSubview:lblTitle];
        UILabel * lblSubTitle =[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 160, 20)];
        lblSubTitle.text = @"OR DOUBLECLCIK ANY OTHER PLACE ON THE MAP";
        lblSubTitle.textAlignment = NSTextAlignmentCenter;
        lblSubTitle.textColor =[UIColor colorWithRed:194.0/255.0 green:122.0/255.0 blue:115.0/255.0 alpha:1.0];
        lblSubTitle.font =[UIFont fontWithName:@"Helvetica-Bold" size:6.0];
        [annotationView addSubview:lblSubTitle];
        
        UIButton * btn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 160, 100)];
        [btn addTarget:self action:@selector(btnAddNewPointSelected:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        [annotationView addSubview:btn];
        
        return annotationView;
    }
    int tag,index;
    NSDictionary * dict =annotation.pointInfo;
    NSArray * array;
    if ([AppManager sharedInstance].isFilter) {
        array = self.webInfoArray;
    } else {
        array =[AppManager sharedInstance].allPoints;
    }
    
    
    for (int i = 0; i < array.count; i++) {
        if ([dict isEqualToDictionary:array[i]]) {
            tag = [[dict valueForKey:@"id"] integerValue];
            index = i;
            break;
        }
    }
    
    
    UIView * annotationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 160, 100)];
    annotationView.backgroundColor = [UIColor clearColor];
    UIImageView * defoultImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 35, 35)];
    [defoultImg setImage:[UIImage imageNamed:@"defaultProfileImage.png"]];
    [annotationView addSubview:defoultImg];
    
    
    WebImage *img = [[WebImage alloc] initWithFrame:CGRectMake(5, 5 , 35, 35)];
    
    __weak WebImage * webImage = img;
    [webImage setImageURL:[dict valueForKey:@"picture"] completion:^(UIImage *image) {
        webImage.image = image;
    }];
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
    return annotationView;
}

#pragma mark - get Address
-(void)getAddressFromLatLon:(double)pdblLatitude withLongitude:(double)pdblLongitude
{
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:pdblLatitude/*40.164752*/ longitude:pdblLongitude/*44.461924*/]; //insert your coordinates
    
    [ceo reverseGeocodeLocation: loc completionHandler:^(NSArray *placemarks, NSError *error) {
        
        placemark = [placemarks objectAtIndex:0];
        NSLog(@"placemark %@",placemark);
        //String to hold address
        NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
        NSLog(@"addressDictionary %@", placemark.addressDictionary);
        
        NSLog(@"placemark %@",placemark.region);
        NSLog(@"placemark %@",placemark.country);  // Give Country Name
        NSLog(@"placemark %@",placemark.locality); // Extract the city name
        NSLog(@"location %@",placemark.name);
        NSLog(@"location %@",placemark.ocean);
        NSLog(@"location %@",placemark.postalCode);
        NSLog(@"location %@",placemark.subLocality);
        
        NSLog(@"location %@",placemark.location);
        //Print the location to console
        NSLog(@"I am currently at %@",locatedAt);
        txtCity.text = [placemark.addressDictionary valueForKey:@"City"];
        txtAddress.text = [placemark.addressDictionary valueForKey:@"Street"];
    }];
}

#pragma mark UICollectionView Delegate methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return photosArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MapPhotoCell";
    
    MapPhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell setPhotoInfo:photosArray[indexPath.row] indexPath:indexPath];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self loadPhoto];
            break;
        default:
            break;
    }
}

- (void) loadPhoto {
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    // imagePicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (void)takePhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        cameraPicker = [[UIImagePickerController alloc] init];
        cameraPicker.delegate = self;
        cameraPicker.allowsEditing = YES;
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraPicker.showsCameraControls = YES;
        
        if ([AppManager sharedInstance].isiPhone5) {
            cameraPicker.cameraViewTransform = CGAffineTransformScale(cameraPicker.cameraViewTransform, 1.66, 1.66);
        }
        else
        {
            cameraPicker.cameraViewTransform = CGAffineTransformScale(cameraPicker.cameraViewTransform, 1.26, 1.26);
        }
        cameraPicker.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self presentViewController:cameraPicker animated:YES completion:nil];
    }
    
    
}

#pragma mark UIImagePickerViewController methods

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [scrlAddNewPoint setContentOffset:CGPointMake(285, 0) animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    [photosArray addObject:image];
    [scrlAddNewPoint setContentOffset:CGPointMake(285, 0) animated:NO];
    [collectionPhotos reloadData];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [[UINavigationBar appearance] setBarTintColor:navBarColor];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [navigationController.navigationBar setBarTintColor:navBarColor];
    [navigationController.navigationBar setTranslucent:NO];
    [navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
}

#pragma mark - UIScrolllViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == scrlAddNewPoint) {
        float currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
        if(currentPage==2){
            [btnNext setTitle:@"ADD PLACE" forState:UIControlStateNormal];
            btnNext.tag = 2;
        } else {
            [btnNext setTitle:@"NEXT STEP" forState:UIControlStateNormal];
            btnNext.tag = 1;
        }
        btnNext.userInteractionEnabled = YES;
    }
}

#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    btnHideKeyboard.hidden = NO;
    btnHideKeyboard1.hidden = NO;
    [scrlMain setContentOffset:CGPointMake(0, textField.frame.origin.y -45 + scrlAddNewPoint.frame.origin.y) animated:YES];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    btnHideKeyboard.hidden = YES;
    btnHideKeyboard1.hidden = YES;
    [scrlMain setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    
    return YES;
}


#pragma mark - UITextView Delegate
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    
    [scrlMain setContentOffset:CGPointMake(0, textView.frame.origin.y -45 + scrlAddNewPoint.frame.origin.y) animated:YES];
    btnHideKeyboard.hidden = NO;
    btnHideKeyboard1.hidden = NO;
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.text.length > 149 && text.length != 0) {
        return NO;
    }
    if([text isEqualToString:@"\n"]) {
        [scrlMain setContentOffset:CGPointMake(0, 0) animated:YES];
        
        btnHideKeyboard.hidden = YES;
        btnHideKeyboard1.hidden = YES;
        return NO;
    }
    
    return YES;
}

-(void) textViewDidEndEditing:(UITextView *)textView {
    
    [textView resignFirstResponder];
}

#pragma mark UITableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.textLabel.textColor = lblCategory.textColor;
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    
    
    NSDictionary * category = categories[indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    if ([category valueForKey:@"title"]) {
        if (![[category valueForKey:@"title"] isKindOfClass:[NSNull class]]) {
            cell.textLabel.text = [category valueForKey:@"title"];
        }
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [UIView animateWithDuration:0.3 animations:^{
        tblCategories.alpha = 0;
    }];
    NSDictionary * category = categories[indexPath.row];
    lblCategory.text = @"";
    if ([category valueForKey:@"title"]) {
        if (![[category valueForKey:@"title"] isKindOfClass:[NSNull class]]) {
            lblCategory.text = [category valueForKey:@"title"];
        }
    }
    if ([category valueForKey:@"is_business"]) {
        if ([[category valueForKey:@"is_business"] boolValue]) {
            lblInfo.hidden = NO;
            lblType.hidden = NO;
            viewIsBusiness.hidden = YES;
            txtPaypal.userInteractionEnabled = YES;
        } else {
            lblType.hidden = YES;
            lblInfo.hidden = YES;
            txtPaypal.userInteractionEnabled = NO;
            viewIsBusiness.hidden = NO;
        }
    } else {
        lblType.hidden = YES;
        lblInfo.hidden = YES;
        txtPaypal.userInteractionEnabled = NO;
        viewIsBusiness.hidden = NO;
    }
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0000001;
}
@end
