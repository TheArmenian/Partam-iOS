//
//  DetailViewController.m
//  Partam
//
//  Created by Sargis Gevorgyan on 3/3/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import "DetailViewController.h"
#import <Twitter/Twitter.h>
#import <QuartzCore/QuartzCore.h>
#import "VKSdk.h"
#import "CheckinsViewController.h"

static NSString *const TOKEN_KEY = @"my_application_access_token";
static NSArray  * SCOPE = nil;

@interface DetailViewController ()<UIWebViewDelegate,UIActionSheetDelegate,VKSdkDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    __weak IBOutlet UILabel *lblCheckin;
    __weak IBOutlet UIButton *btnSelfie;
    NSArray *checkinsArray;
}

@end

@implementation DetailViewController
@synthesize category;
@synthesize webInfo;

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
    loadingView.hidden =NO;
    loadingView.layer.cornerRadius = 10;
    btnHideKeyBoard.hidden = YES;
    isCommentAdded = NO;
    lblCategory.text = @"";
    lblcity.text = @"";
    lblCommentCount.text = @"";
    lblName.text = @"";
    imgPageControll.numberOfPages = 0;
    mainScrollView.scrollEnabled = NO;
    if (![[self.mainInfo valueForKey:@"category"]isKindOfClass:[NSNull class]]) {
        if (![[[self.mainInfo valueForKey:@"category"] valueForKey:@"title"]isKindOfClass:[NSNull class]]) {
            category =  [[self.mainInfo valueForKey:@"category"] valueForKey:@"title"];
        }
    }
    
//    height = 0;
    if (IOS_VERSION >= 7.0) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:193.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:1.0]];
        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btnBack.png"] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonPress:)];
        
        self.navigationItem.leftBarButtonItem = leftButton;
        rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 0, 27, 27);
        [rightButton setImage:[UIImage imageNamed:@"btnFavoritesEmpty.png"] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:@"btnFavoritesFull.png"] forState:UIControlStateSelected];
        [rightButton addTarget:self action:@selector(rightButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        //        rightBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"locationIcon.png"] style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonPress:)];
        //
        UIBarButtonItem * shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(btnSharePressed:)];
        self.navigationItem.rightBarButtonItems = @[shareButton,rightBarButton];
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:193.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:1.0]];
        //        [self.navigationController.navigationBar setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgNavigationBar"]]];
        rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 0, 27, 27);
        [rightButton setImage:[UIImage imageNamed:@"btnFavoritesEmpty.png"] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:@"btnFavoritesFull.png"] forState:UIControlStateSelected];
        [rightButton addTarget:self action:@selector(rightButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, 27, 27);
        [leftButton setImage:[UIImage imageNamed:@"btnBack.png"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    }
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logotxt.png"]];
    
    detailMapView.delegate = self;
    gbImageDetailMapView.backgroundColor = bgWebImageColor;
    mapGridView.hidden = YES;
    [self performSelector:@selector(sendDetailRequest) withObject:nil afterDelay:0.1];
    
    
    btnSelfie.layer.cornerRadius = 5;
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if ([AppManager sharedInstance].userFavorites) {
        
        NSArray * filter = [[[AppManager sharedInstance].userFavorites valueForKey:@"favorites"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id = %@",[webInfo valueForKey:@"id"]]];
        if (filter.count > 0) {
            rightButton.selected = YES;
        } else {
            rightButton.selected = NO;
        }
    }else {
        rightButton.selected = NO;
    }
    
    if (![AppManager sharedInstance].isLogOut) {
        btnLogin.hidden = YES;
        NSDictionary* userInfo = [[AppManager sharedInstance].userInfo valueForKey:@"user"];
        if ([userInfo isKindOfClass:[NSDictionary class]]) {
            WebImage* img =[[WebImage alloc]initWithFrame:CGRectMake(3, 6, 42, 42)];
            __weak WebImage * userImage = img;
            [userImage setImageURL:[userInfo valueForKey:@"picture"] completion:^(UIImage *image) {
                CGRect cropFrame = CGRectMake(0, 0, userImage.frame.size.width, userImage.frame.size.height);
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
                userImage.image = coverImg;
            }];
            userImage.layer.cornerRadius = 5;
            [bgButtons addSubview:userImage];
        }
        
        
    }
}

-(void)sendDetailRequest {
    self.webInfo =[[NSMutableDictionary alloc] initWithDictionary:[[AppManager sharedInstance] loadDetailInfo:[[self.mainInfo valueForKey:@"id"] intValue]]];
    loadingView.hidden = YES;
    if ([AppManager sharedInstance].userFavorites) {
        
        NSArray * filter = [[[AppManager sharedInstance].userFavorites valueForKey:@"favorites"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id = %@",[webInfo valueForKey:@"id"]]];
        if (filter.count > 0) {
            rightButton.selected = YES;
        } else {
            rightButton.selected = NO;
        }
    }else {
        rightButton.selected = NO;
    }
    
    if (![AppManager sharedInstance].isLogOut) {
        btnLogin.hidden = YES;
        NSDictionary* userInfo = [[AppManager sharedInstance].userInfo valueForKey:@"user"];
        if ([userInfo isKindOfClass:[NSDictionary class]]) {
            WebImage* img =[[WebImage alloc]initWithFrame:CGRectMake(3, 6, 42, 42)];
            __weak WebImage * userImage = img;
            [userImage setImageURL:[userInfo valueForKey:@"picture"] completion:^(UIImage *image) {
                CGRect cropFrame = CGRectMake(0, 0, userImage.frame.size.width, userImage.frame.size.height);
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
                userImage.image = coverImg;
            }];

            userImage.layer.cornerRadius = 5;
            [bgButtons addSubview:userImage];
        }
        
        
    }
    [self showDetailInfo];
    [self showMap];
    detailTableView.delegate = self;
    detailTableView.dataSource = self;
    [detailTableView reloadData];
    mainScrollView.scrollEnabled = YES;
}

- (void) showDetailInfo {
    images = [NSMutableArray new];
    
    [gbImageDetailMapView setImage:[UIImage imageNamed:@"defaultProfileImage.png"]];
    WebImage *webImage = [[WebImage alloc] initWithFrame:CGRectMake(0, 0 , 320, 320)];
    __weak WebImage * imgWeb = webImage;
    sharedImgUrl = [webInfo valueForKey:@"picture"];
    sharedUrl = @"https://itunes.apple.com/app/id838868932";
    [imgWeb setImageURL:[webInfo valueForKey:@"picture"] completion:^(UIImage *image) {
        imgWeb.image = image;
        shareImage = image;
    }];
    [gbImageDetailMapView addSubview:imgWeb];
    
    lblName.text = [webInfo valueForKey:@"name"];
    lblcity.text = [webInfo valueForKey:@"city"];
    lblCategory.text = category;
    
    picturesArray = [webInfo valueForKey:@"pictures"];
    videosArray = [webInfo valueForKey:@"videos"];
    commentsArray = [webInfo valueForKey:@"comments"];
    checkinsArray = [webInfo valueForKey:@"checkins"];
    height = [self getCellHeight];
    lblCommentCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)commentsArray.count];
    lblCheckin.text = [NSString stringWithFormat:@"%lu",(unsigned long)checkinsArray.count];
    if (picturesArray.count <= 1) {
        imgPageControll.numberOfPages = 0;
        
    } else {
        imgPageControll.numberOfPages = picturesArray.count+videosArray.count;
    }
    
    imagesScrollView.contentSize = CGSizeMake(self.view.frame.size.width*(picturesArray.count+videosArray.count), imagesScrollView.frame.size.height);
    
    for (int i = 0; i < picturesArray.count; i ++) {
        NSString * currentUrl = picturesArray[i];
        UIImageView * currentImg = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.width)];
        [currentImg setImage:[UIImage imageNamed:@"defaultProfileImage.png"]];
        WebImage *img = [[WebImage alloc] initWithFrame:CGRectMake(0, 0 , 320, 320)];
        __weak WebImage * imgWeb = img;
        [imgWeb setImageURL:currentUrl completion:^(UIImage *image) {
            imgWeb.image = image;
            [images addObject:image];
        }];
        [currentImg addSubview:imgWeb];
        [imagesScrollView addSubview:currentImg];
    }
    
    for (int i = 0; i < videosArray.count; i ++) {
        
        NSDictionary * currentVideoInfo = videosArray[i];
        
        UIImageView * currentImg = [[UIImageView alloc]initWithFrame:CGRectMake((picturesArray.count+i)*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.width)];
        [currentImg setImage:[UIImage imageNamed:@"defaultProfileImage.png"]];
        NSString * tmbUrl = [currentVideoInfo valueForKey:@"thumb"];
                
        WebImage *webImage = [[WebImage alloc] initWithFrame:CGRectMake(0, 0 , 320, 320)];
        __weak WebImage * imgWeb = webImage;
        [imgWeb setImageURL:tmbUrl completion:^(UIImage *image) {
            imgWeb.image = image;
            [images addObject:image];
        }];
        [currentImg addSubview:imgWeb];
        [imagesScrollView addSubview:currentImg];
        [imagesScrollView addSubview:[self embedYouTube:[currentVideoInfo valueForKey:@"id"] frame:CGRectMake((picturesArray.count+i)*self.view.frame.size.width, 0, 320, 320)]];
        
    }
    
    [webDescriptionView loadHTMLString:[webInfo valueForKey:@"description"] baseURL:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(windowNowVisible:)
     name:UIWindowDidBecomeVisibleNotification
     object:self.view.window
     ];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(windowNowHidden:)
     name:UIWindowDidBecomeHiddenNotification
     object:self.view.window
     ];
}

- (void)windowNowVisible:(NSNotification *)notification
{
    
    NSLog(@"Youtube/ Media window appears");
}


- (void)windowNowHidden:(NSNotification *)notification
{
    NSLog(@"Youtube/ Media window disappears.");
}

- (UIWebView*)embedYouTube:(NSString *)urlString frame:(CGRect)frame {

//    https://www.youtube.com/watch?v=SDc3V_rA-pU
    NSString* embedHTML = [NSString stringWithFormat:@"\
                           <html>\
                           <body style='margin:0px;padding:0px;'>\
                           <script type='text/javascript' src='http://www.youtube.com/iframe_api'></script>\
                           <script type='text/javascript'>\
                           function onYouTubeIframeAPIReady()\
                           {\
                           ytplayer=new YT.Player('playerId',{events:{onReady:onPlayerReady}})\
                           }\
                           function onPlayerReady(a)\
                           { \
                           a.target.playVideo(); \
                           }\
                           </script>\
                           <iframe id='playerId' type='text/html' width='%d' height='%d' src='https://www.youtube.com/embed/%@?autoplay=0&controls=0&loop=0&modestbranding=0&rel=0&showinfo=0&color=white&iv_load_policy=3' frameborder='0'>\
                           </body>\
                           </html>", 320, 320,urlString];
//    <html><head><title>Video</title><style type="text/css">    html {
//    overflow: auto;
//    }
//    </style>
//    </head>
//    <body bgcolor="#000000">
//    <iframe id="ytplayer" type="text/html" width="100%" height="100%"
//    src="https://www.youtube.com/embed/sS1TY725lL0?autoplay=1&controls=0&loop=1&modestbranding=1&rel=0&showinfo=0&color=white&iv_load_policy=3"
//    frameborder="0" allowfullscreen>a
//    </object>
//    </body>
//    </html>
    UIWebView *videoView = [[UIWebView alloc] initWithFrame:frame];
    videoView.scrollView.scrollEnabled = NO;
    videoView.backgroundColor = [UIColor clearColor];
    videoView.scrollView.backgroundColor =bgWebImageColor;
    [videoView loadHTMLString:embedHTML baseURL:[[NSBundle mainBundle] resourceURL]];
    videoView.tag = 1;
    videoView.delegate = self;
    videoView.hidden = YES;
    return videoView;
}

-(int)getCellHeight {
    int cellHeight = 0;
    for (int i = 0; i < commentsArray.count; i ++) {
        
        UILabel * lblMessage = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        lblMessage.textColor =[UIColor colorWithRed:191.0/255.0 green:192.0/255.0 blue:193.0/255.0 alpha:1];
        lblMessage.backgroundColor = [UIColor clearColor];
        lblMessage.numberOfLines = 0;
        lblMessage.font = [UIFont systemFontOfSize:12];
        NSDictionary * currentMessage = commentsArray[i];
        lblMessage.text = [currentMessage valueForKey:@"message"];
        CGSize maximumLabelSize = CGSizeMake(215,9999);
        
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:lblMessage.text
                                                                             attributes:@{ NSFontAttributeName: lblMessage.font }];
        
        CGRect rect = [attributedText boundingRectWithSize:maximumLabelSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize expectedLabelSize = rect.size;
        
        //adjust the label the the new height.
        CGRect newFrame = lblMessage.frame;
        newFrame.size.height = expectedLabelSize.height;
        lblMessage.frame = newFrame;
        
      
        if (expectedLabelSize.height>48) {
            cellHeight+=expectedLabelSize.height+18;
        } else {
            cellHeight+=70;
        }
        
    }
    
    
    
    if (cellHeight > 0) {
        cellHeight+=13;
    }
    return cellHeight;
}





-(void)showMap {
    if ((![webInfo valueForKey:@"lat"] ||![webInfo valueForKey:@"lng"])||([[webInfo valueForKey:@"lat"]floatValue] ==0 || [[webInfo valueForKey:@"lng"]floatValue] == 0)) {
        for (UIView * view in [mainScrollView subviews]) {
            if (view.frame.origin.y > detailMapView.frame.origin.y) {
                view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y - detailMapView.frame.size.height, view.frame.size.width, view.frame.size.height);
            }
        }
        btnSelectMap.hidden = YES;
        bgMapDetailView.frame = CGRectMake(bgMapDetailView.frame.origin.x, bgMapDetailView.frame.origin.y - detailMapView.frame.size.height, bgMapDetailView.frame.size.width, bgMapDetailView.frame.size.height);
        detailMapView.hidden = YES;
        return;
    }
        NSMutableArray * annotations =[NSMutableArray new];
        CLLocationCoordinate2D annotationCoord;
    
        annotationCoord.latitude = [[webInfo valueForKey:@"lat"]floatValue];
        annotationCoord.longitude = [[webInfo valueForKey:@"lng"]floatValue];
        
        CustomPointAnnotation *annotationPoint = [[CustomPointAnnotation alloc] init];
        annotationPoint.coordinate = annotationCoord;
        annotationPoint.title = [webInfo valueForKey:@"name"];
        annotationPoint.pointInfo = webInfo;
        annotationPoint.subtitle = category;
        
        [annotations addObject:annotationPoint];
        [detailMapView addAnnotation:annotationPoint];
                MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotationCoord, 3000, 3000);
        [detailMapView setRegion:region animated:YES];
        annotationPoint = nil;

    
}

#pragma mark - Button Handlers

- (IBAction)btnCheckinTap:(id)sender {
    
    CheckinsViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckinsViewController"];
    viewController.category = category;
    viewController.webInfo = self.webInfo;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)btnSelfieTap:(id)sender {
    
    if ([AppManager sharedInstance].token.length == 0) {
        UINavigationController* centerViewController = (UINavigationController*)self.mm_drawerController.centerViewController;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        LoginViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        viewController.isFavorites = NO;
        [centerViewController pushViewController:viewController animated:NO];
        loadingView.hidden = YES;
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)leftButtonPress:(id)sender{
    UINavigationController* centerViewController = (UINavigationController*)self.mm_drawerController.centerViewController;
    MainViewController * viewController;
    for (int i = 0; i < centerViewController.viewControllers.count;i++) {
        UIViewController * vc = centerViewController.viewControllers[i];
        if ([vc isKindOfClass:[MainViewController class]]) {
            viewController = (MainViewController*)vc;
            break;
        }
    }
    for (int i = 0; i < viewController.webInfoArray.count; i++) {
        NSMutableDictionary * currentInfo =[[NSMutableDictionary alloc]initWithDictionary:viewController.webInfoArray[i]];
        if (![[currentInfo valueForKey:@"id"]isKindOfClass:[NSNull class]] && ![[webInfo valueForKey:@"id"] isKindOfClass:[NSNull class]] && [webInfo valueForKey:@"id"] && [currentInfo valueForKey:@"id"]) {
            if ([[currentInfo valueForKey:@"id"]isEqualToValue:[webInfo valueForKey:@"id"]]) {
                
                [currentInfo setValue:[NSNumber numberWithInt:commentsArray.count] forKey:@"comment_count"];
                [viewController.webInfoArray replaceObjectAtIndex:i withObject:currentInfo];
                break;
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightButtonPress:(id)sender{
    loadingView.hidden = NO;
    [self performSelector:@selector(sendFavRequest) withObject:nil afterDelay:0.1];
}

-(void)sendFavRequest {
    if (![AppManager sharedInstance].userFavorites) {
        UINavigationController* centerViewController = (UINavigationController*)self.mm_drawerController.centerViewController;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        LoginViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        viewController.isFavorites = NO;
        [centerViewController pushViewController:viewController animated:NO];
        loadingView.hidden = YES;
        return;
    }
    NSDictionary * dict;
    if (rightButton.selected) {
        dict=  [[AppManager sharedInstance] addOrRemoveFavorites:[[webInfo valueForKey:@"id"]integerValue] method:@"UNLINK"];
    } else {
        dict= [[AppManager sharedInstance] addOrRemoveFavorites:[[webInfo valueForKey:@"id"]integerValue] method:@"LINK"];
    }
    if ([[dict valueForKey:@"success"]integerValue] == 1) {
        rightButton.selected = !rightButton.selected;
        [[AppManager sharedInstance] loadUserFavorites];
    }
    loadingView.hidden = YES;
}

-(void)showDetailMap:(id)sender {
    if ((![webInfo valueForKey:@"lat"] ||![webInfo valueForKey:@"lng"])||([[webInfo valueForKey:@"lat"]floatValue] ==0 || [[webInfo valueForKey:@"lng"]floatValue] == 0)) {
        return;
    }
    UINavigationController* centerViewController = (UINavigationController*)self.mm_drawerController.centerViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RouteMapViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"RouteMapViewController"];
       viewController.category = category;
    viewController.webInfo =webInfo;
    viewController.pointCategoryInfo = self.pointCategoryInfo;
    [centerViewController pushViewController:viewController animated:YES];
}


- (void) sendViaEmail {
    if ([MFMailComposeViewController canSendMail]) {
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:193.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
    [mailComposeViewController.navigationBar setTintColor:[UIColor whiteColor]];
    mailComposeViewController.mailComposeDelegate = self;

    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:193.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    NSMutableArray *recipents = [NSMutableArray arrayWithObject:[webInfo valueForKey:@"email"]];
    [mailComposeViewController setToRecipients:recipents];
    [self presentViewController:mailComposeViewController animated:YES completion:nil];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"You do not have an e-mail account set up on your device"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];

        [alert show];
    }
}

-(void)btnSharePressed:(id)sendert {
    
    NSString *other1 = @"Facebook";
    NSString *other2 = @"Pinterest";
    NSString *other3 = @"Twitter";
    NSString *other4 = @"Vkontakte";
    NSString *cancelTitle = @"Cancel";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other1,other2,other3,other4, nil];

    [actionSheet showInView:self.view];

}

#pragma mark UIImagePickerController 

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];

    loadingView.hidden = NO;
    [WebServiceManager addSelfie:image point:[[webInfo valueForKey:@"id"] stringValue] completion:^(id response, NSError *error) {
        loadingView.hidden = YES;
        [self btnCheckinTap:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark  TableView Delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * cellInfo = detailInfoArray[indexPath.row];
    NSString * type = [cellInfo valueForKey:@"type"];
    
    if ([type isEqual:@"comments"]) {

            return height;
       
    }
    
   
    return 48;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self getNumberOfRowsInSection];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    NSDictionary * cellInfo = detailInfoArray[indexPath.row];
    NSString * type = [cellInfo valueForKey:@"type"];
    if (![type isEqual:@"comments"]) {
        
        if ([type isEqualToString:@"checkins"]) {

            UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btnAllChekins.png"]];
            [cell.contentView addSubview:image];
            image = nil;
            
        } else {
        
            cell.textLabel.text =[cellInfo valueForKey:@"info"];
            cell.textLabel.textColor =[UIColor colorWithRed:44.0/255.0 green:153.0/255.0 blue:215.0/255.0 alpha:1];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.minimumScaleFactor = 0.5;
            cell.imageView.image =[self getCellImageViewImage:type];
            
            if ([type isEqual:@"address"]) {
                UIButton *btnshowMap = [[UIButton alloc]initWithFrame:CGRectMake(260, 1, 60, 46)];
                [btnshowMap setImage:[UIImage imageNamed:@"imgShowMap"] forState:UIControlStateNormal];
                [btnshowMap addTarget:self action:@selector(showDetailMap:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btnshowMap];
                //            cell.accessoryView = btnshowMap;
            }
        }
    } else {
        
        height = 0;
        
        UIView * cellGrid = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, commentsArray.count*70)];
        
        for (int i = 0; i < commentsArray.count; i ++) {
            
            
            UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bgDetailViewCell"]];
            [img sizeToFit];
            img.frame = CGRectMake(45,13+ height, img.frame.size.width, img.frame.size.height);
            UILabel * lblMessage = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 215, 40)];
            lblMessage.textColor =[UIColor darkGrayColor];
            lblMessage.backgroundColor = [UIColor clearColor];
            lblMessage.numberOfLines = 0;
            lblMessage.font = [UIFont systemFontOfSize:12];
            NSDictionary * currentMessage = commentsArray[i];
            lblMessage.text = [currentMessage valueForKey:@"message"];
            [img addSubview:lblMessage];
            CGSize maximumLabelSize = CGSizeMake(215,9999);
            
            NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:lblMessage.text
                                                                                 attributes:@{ NSFontAttributeName: lblMessage.font }];
            
            CGRect rect = [attributedText boundingRectWithSize:maximumLabelSize
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
            CGSize expectedLabelSize = rect.size;
            
            //adjust the label the the new height.
            CGRect newFrame = lblMessage.frame;
            newFrame.size.height = expectedLabelSize.height;
            lblMessage.frame = newFrame;
            
            UILabel * lblDate = [[UILabel alloc]initWithFrame:CGRectMake(235, 5, 40, 20)];
            lblDate.textColor =[UIColor darkGrayColor];
            lblDate.backgroundColor = [UIColor clearColor];
            lblDate.numberOfLines = 0;
            lblDate.font = [UIFont systemFontOfSize:12];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ'"];
            NSDate *date = [dateFormat dateFromString:[currentMessage valueForKey:@"created"]];
            [dateFormat setDateFormat:@"HH:mm"];
            lblDate.text =[dateFormat stringFromDate:date];
            [img addSubview:lblDate];
            
            UIImageView * currentImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 13+ height, 40, 40)];
            [currentImg setImage:[UIImage imageNamed:@"userDefaultImg"]];
            UIImageView * clock = [[UIImageView alloc]initWithFrame:CGRectMake(223, 11, 9, 9)];
            [clock setImage:[UIImage imageNamed:@"Clocksmall"]];
            [img addSubview:clock];
            NSDictionary * user = [currentMessage valueForKey:@"user"];
            WebImage * userimage = [[WebImage alloc] initWithFrame:CGRectMake(0, 0 , 40, 40)];
            __weak WebImage * imgWeb = userimage;
            [imgWeb setImageURL:[user valueForKey:@"picture"] completion:^(UIImage *image) {
                imgWeb.image = image;
            }];
            userimage.image =[UIImage imageNamed:@"userDefaultImg"];
            userimage.backgroundColor = [UIColor clearColor];
            userimage.layer.cornerRadius = 5;
            UILabel * lblUserName = [[UILabel alloc]initWithFrame:CGRectMake(2, 53+height, 48, 20)];
            lblUserName.textColor =[UIColor darkGrayColor];
            lblUserName.backgroundColor = [UIColor clearColor];
            lblUserName.numberOfLines = 2;
            lblUserName.textAlignment = NSTextAlignmentCenter;
            lblUserName.font = [UIFont boldSystemFontOfSize:8];
            lblUserName.text = [currentMessage valueForKey:@"name"];
            if (expectedLabelSize.height>48) {
                height+=expectedLabelSize.height+18;
                img.frame = CGRectMake(img.frame.origin.x, img.frame.origin.y, img.frame.size.width, expectedLabelSize.height+8);
                
                UIImage *stretchedBackground = [img.image stretchableImageWithLeftCapWidth:30 topCapHeight:30];
                img.image = stretchedBackground;
            } else {
                height+=70;
            }
            
            
            
            [currentImg addSubview:userimage];
            [cellGrid addSubview:currentImg];
            [cellGrid addSubview:img];
            [cellGrid addSubview:lblUserName];
        }
        height+=13;
        cellGrid.frame = CGRectMake(0, 0, 320, height);
        
        [cell addSubview:cellGrid];
        cell.frame = CGRectMake(0, 0, 320, height);
    }
    
    detailTableView.frame = CGRectMake(0, detailTableView.frame.origin.y, detailTableView.frame.size.width, 48*cellCount+height);
    [self webViewDidFinishLoad:webDescriptionView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * cellInfo = detailInfoArray[indexPath.row];
    NSString * type = [cellInfo valueForKey:@"type"];
    [self didSelectCurrentCell:type info:[cellInfo valueForKey:@"info"]];
    
}

-(void)didSelectCurrentCell:(NSString*)type info:(NSString*)info{
    
    if ([type isEqualToString:@"checkins"]) {
        [self btnCheckinTap:nil];
    }
    
    if ([type isEqual:@"address"]) {
       [self showDetailMap:nil];
    }
    if ([type isEqual:@"tel"]) {
        NSString *cleanedString = [[info componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
        NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", cleanedString]];
        [[UIApplication sharedApplication] openURL:telURL];
    }
    if ([type isEqual:@"website"] || [type isEqual:@"facebook_url"] || [type isEqual:@"twitter_url"]|| [type isEqual:@"instagram_url"]) {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:info]];
    }
    if ([type isEqual:@"email"]) {
       [self sendViaEmail];
    }
  
}

#pragma mark -
-(NSInteger)getNumberOfRowsInSection {
    detailInfoArray = [NSMutableArray new];
    NSInteger count = 0;
    if ([webInfo valueForKey:@"address"]) {
        NSDictionary * address =@{@"type": @"address",@"info":[webInfo valueForKey:@"address"]};
        [detailInfoArray addObject:address];
        count ++;
    }
    if ([webInfo valueForKey:@"tel"]) {
        NSDictionary * tel =@{@"type": @"tel",@"info":[webInfo valueForKey:@"tel"]};
        [detailInfoArray addObject:tel];
        count ++;
    }
    if ([webInfo valueForKey:@"website"]) {
        NSDictionary * website =@{@"type": @"website",@"info":[webInfo valueForKey:@"website"]};
        [detailInfoArray addObject:website];
        count ++;
    }
    if ([webInfo valueForKey:@"email"]) {
        NSDictionary * email =@{@"type": @"email",@"info":[webInfo valueForKey:@"email"]};
        [detailInfoArray addObject:email];
        count ++;
    }
    if ([webInfo valueForKey:@"facebook_url"]) {
        NSDictionary * facebook_url =@{@"type": @"facebook_url",@"info":[webInfo valueForKey:@"facebook_url"]};
        [detailInfoArray addObject:facebook_url];
        count ++;
    }
    if ([webInfo valueForKey:@"twitter_url"]) {
        NSDictionary * twitter_url =@{@"type": @"twitter_url",@"info":[webInfo valueForKey:@"twitter_url"]};
        [detailInfoArray addObject:twitter_url];
        count ++;
    }
    if ([webInfo valueForKey:@"instagram_url"]) {
        NSDictionary * instagram_url =@{@"type": @"instagram_url",@"info":[webInfo valueForKey:@"instagram_url"]};
        [detailInfoArray addObject:instagram_url];
        count ++;
    }
    
    [detailInfoArray addObject:@{@"type":@"checkins"}];
    count ++;
    
    cellCount = count;
    if (commentsArray.count > 0) {
        NSDictionary * comments =@{@"type": @"comments",@"info":commentsArray};
        [detailInfoArray addObject:comments];
        count ++;
    }
    detailTableView.frame = CGRectMake(0, detailTableView.frame.origin.y, detailTableView.frame.size.width, 48*cellCount+height);
    return count;
}

-(UIImage*)getCellImageViewImage:(NSString*)type {
    UIImage * image;
    if ([type isEqual:@"address"]) {
       image = [UIImage imageNamed:@"detailLocation"];
    }
    if ([type isEqual:@"tel"]) {
        image = [UIImage imageNamed:@"bgPhone"];
    }
    if ([type isEqual:@"website"]) {
        image = [UIImage imageNamed:@"bgOpenWeb"];
    }
    if ([type isEqual:@"email"]) {
        image = [UIImage imageNamed:@"bgemail"];
    }
    if ([type isEqual:@"facebook_url"]) {
        image = [UIImage imageNamed:@"bgFacebookIcon"];
    }
    if ([type isEqual:@"twitter_url"]) {
        image = [UIImage imageNamed:@"bgTwitterIcon"];
    }
    if ([type isEqual:@"instagram_url"]) {
        image = [UIImage imageNamed:@"bgInstagramIcon"];
    }
    
    return image;
}

#pragma mark UIWebView methods

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView.tag == 1) {
        webView.hidden = NO;
        return;
    }
    NSString *_height = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
    webViewHeight = [_height floatValue]+20;
    if ([_height floatValue] == 0) {
        webViewHeight = 1;
    }
    webDescriptionView.scrollView.scrollEnabled = NO;
    webDescriptionView.backgroundColor = [UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:1];
    webDescriptionView.opaque=NO;
    webDescriptionView.frame = CGRectMake(0, webDescriptionView.frame.origin.y, webDescriptionView.frame.size.width, webViewHeight);
    detailTableView.frame = CGRectMake(0, webDescriptionView.frame.origin.y + webDescriptionView.frame.size.height-1, detailTableView.frame.size.width, detailTableView.frame.size.height);
    bgButtons.frame = CGRectMake(0, detailTableView.frame.origin.y + detailTableView.frame.size.height-1, bgButtons.frame.size.width, bgButtons.frame.size.height);
    mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, bgButtons.frame.origin.y + bgButtons.frame.size.height-1);
    if (isCommentAdded) {
        [mainScrollView setContentOffset:CGPointMake(0, mainScrollView.contentSize.height - mainScrollView.bounds.size.height) animated:YES];
    }
    
}

#pragma mark UIScrollViewDelegate method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
 
    imgPageControll.currentPage = imagesScrollView.contentOffset.x / imagesScrollView.frame.size.width;
    if (imgPageControll.currentPage >= picturesArray.count) {
        int index =imgPageControll.currentPage - picturesArray.count;
        if (index < videosArray.count) {
            NSDictionary * currentVideoInfo = videosArray[index];
            if ([currentVideoInfo valueForKey:@"thumb"]) {
                if (![[currentVideoInfo valueForKey:@"thumb"] isKindOfClass:[NSNull class]]) {
                    sharedImgUrl = [currentVideoInfo valueForKey:@"thumb"];
                }
            }
//            if ([currentVideoInfo valueForKey:@"id"]) {
//                if (![[currentVideoInfo valueForKey:@"id"] isKindOfClass:[NSNull class]]) {
//                    //sharedUrl = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@",[currentVideoInfo valueForKey:@"id"]];
//                }
//            }
        }
    } else {
        sharedImgUrl = picturesArray[imgPageControll.currentPage];
    }
    if (imgPageControll.currentPage < images.count) {
        shareImage = images[imgPageControll.currentPage];
    }
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
   
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
   
    if(annotationPoint != detailMapView.userLocation) {
       
        pinView = (MKAnnotationView *)[detailMapView dequeueReusableAnnotationViewWithIdentifier:@"123"];
        if(!pinView){
            
            pinView = [[MKAnnotationView alloc]  initWithAnnotation:annotation reuseIdentifier:@"123"];
            pinView.canShowCallout = YES;
            [pinView setEnabled:YES];
            
            WebImage * categoryImg =[[WebImage alloc] initWithFrame:CGRectMake(0, 0, 27, 27)];
            [categoryImg setImageURL:[NSString stringWithFormat:@"http://partam.partam.com%@",[self.pointCategoryInfo valueForKey:@"icon_url"]] completion:^(UIImage *image) {
                pinView.image = [WebImage imageByScalingAndCropping:image forSize:CGSizeMake(27, 27)];
            }];
            
            [categoryImg hideActivityIndicator];
            categoryImg.backgroundColor = [UIColor clearColor];
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

#pragma mark MFMailComposeViewController

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (result != MFMailComposeResultCancelled) {
       
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark UITextFieldDelegate methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    btnHideKeyBoard.hidden = NO;
    
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    mainScrollView.contentOffset = CGPointMake(0, mainScrollView.contentSize.height -([AppManager sharedInstance].isiPhone5?288:200));
//    mainScrollView.scrollEnabled = NO;
//    [UIView animateWithDuration:0.3 animations:^{
//        self.view.frame = CGRectMake(0, -214, self.view.frame.size.width, self.view.frame.size.height);
//    }];
    
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
     mainScrollView.contentOffset = CGPointMake(0, mainScrollView.contentSize.height - self.view.frame.size.height);
//    mainScrollView.scrollEnabled = YES;
//    [UIView animateWithDuration:0.3 animations:^{
//        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    }];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
   
     btnHideKeyBoard.hidden = YES;
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)btnLoginPressed:(id)sender {
    
    UINavigationController* centerViewController = (UINavigationController*)self.mm_drawerController.centerViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    LoginViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    viewController.isFavorites = NO;
    [centerViewController pushViewController:viewController animated:NO];
    
}

- (IBAction)btnPostPressed:(id)sender {
    if (txtComment.text.length > 0) {
        [txtComment resignFirstResponder];
        loadingView.hidden = NO;
        [self performSelector:@selector(sendRequest) withObject:nil afterDelay:0];
    }
}
-(void)sendRequest {
    
    int pointId =[[webInfo valueForKey:@"id"] integerValue];
    NSDictionary * dict = [[AppManager sharedInstance] addComment:txtComment.text :pointId];
    if ([[dict valueForKey:@"success"]integerValue] == 1) {
        webInfo =[[NSMutableDictionary alloc]initWithDictionary:[[AppManager sharedInstance] loadDetailInfo:pointId]];
        
        commentsArray = nil;
        commentsArray = [[NSMutableArray alloc]init];
        commentsArray = [webInfo valueForKey:@"comments"];
        lblCommentCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)commentsArray.count];
        height = [self getCellHeight];
        [detailTableView reloadData];
        isCommentAdded = YES;
        [self webViewDidFinishLoad:webDescriptionView];
//        mainScrollView.contentOffset = CGPointMake(0, mainScrollView.bounds.size.height);
        
    }
    loadingView.hidden = YES;
    txtComment.text = @"";
    

}

- (IBAction)btnHideKeyBoardPressed:(id)sender {
    btnHideKeyBoard.hidden = YES;
    [txtComment resignFirstResponder];
}

- (IBAction)btnSelectMap:(id)sender {
    [self showDetailMap:nil];
}


- (IBAction)btnBackPressed:(id)sender {
    mapGridView.hidden = YES;
}

#pragma mark UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self shareFB:self.webInfo];
            break;
        case 1:
            [self sharePinterest:self.webInfo];
            break;
        case 2:
            [self shareTwitter:self.webInfo];
            break;
        case 3:
            [self shareVK:self.webInfo];
            break;
        default:
            break;
    }
}

#pragma mark - FB Share
-(void)shareFB:(id)info {
    
    if ([[FBSession activeSession] isOpen]) {
        [self publishFB:info];
    } else {
        [FBSession openActiveSessionWithPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            if (error) {
                [AppManager showMessageBox:@"Sorry, unable to login via Facebook."];
            } else  {
                if (status != FBSessionStateClosed) {
                    [self publishFB:info];
                }
            }
        }];
        
    }
}

- (void)publishFB:(id)info {
    NSString * desc = @" ";
    NSString * name = @"";
    
    if ([info valueForKey:@"name"]) {
        if (![[info valueForKey:@"name"] isKindOfClass:[NSNull class]]) {
            name = [NSString stringWithFormat:@"%@",[info valueForKey:@"name"]];
        }
    }
    //description
    if ([info valueForKey:@"description"]) {
        if (![[info valueForKey:@"description"] isKindOfClass:[NSNull class]]) {
            desc = [info valueForKey:@"description"];
            desc = [self flattenHTML:desc];
        }
    }
    
    NSDictionary* params = @{@"name": name,
                             @"caption":@"PARTAM",
                             @"description":desc,
                             @"link":sharedUrl,
                             @"picture":sharedImgUrl
                             };
    
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                  if (!error) {
                                                      
                                                  }
                                              }];
}

#pragma mark - Pinterest Share
-(void)sharePinterest:(id)info {
    NSString * desc = @" ";
    NSString * name = @"";
    
    if ([info valueForKey:@"name"]) {
        if (![[info valueForKey:@"name"] isKindOfClass:[NSNull class]]) {
            name = [info valueForKey:@"name"];
        }
    }
    //description
    if ([info valueForKey:@"description"]) {
        if (![[info valueForKey:@"description"] isKindOfClass:[NSNull class]]) {
            desc = [info valueForKey:@"description"];
            desc = [self flattenHTML:desc];
            name = [NSString stringWithFormat:@"%@\n %@",name,desc];
        }
    }    
    _pinterest = [[Pinterest alloc] initWithClientId:@"1440219" urlSchemeSuffix:@"prod"];
    [_pinterest createPinWithImageURL:[NSURL URLWithString:sharedImgUrl]
                            sourceURL:[NSURL URLWithString:sharedUrl]
                          description:[NSString stringWithFormat:@"%@",name]];
}


#pragma mark - Twitther Share
-(void)shareTwitter:(id)info {
    NSString * desc = @" ";
    NSString * name = @"";
    
    if ([info valueForKey:@"name"]) {
        if (![[info valueForKey:@"name"] isKindOfClass:[NSNull class]]) {
            name = [info valueForKey:@"name"];
        }
    }
    //description
//    if ([info valueForKey:@"description"]) {
//        if (![[info valueForKey:@"description"] isKindOfClass:[NSNull class]]) {
//            desc = [info valueForKey:@"description"];
//            desc = [self flattenHTML:desc];
//            name = [NSString stringWithFormat:@"%@\n %@",name,desc];
//        }
//    }
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheetOBJ = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheetOBJ setInitialText:[NSString stringWithFormat:@"%@",name]];
        [tweetSheetOBJ addURL:[NSURL URLWithString:sharedUrl]];
        
        [tweetSheetOBJ addImage:shareImage];
        [self presentViewController:tweetSheetOBJ animated:YES completion:^{
            
        }];
        [tweetSheetOBJ setCompletionHandler:^(SLComposeViewControllerResult result){
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Cancled");
                    break;
                case SLComposeViewControllerResultDone:
                    
                default:
                    break;
            }
        }];
    } else {
        [AppManager showMessageBox:@"Sorry, unable to login via Twitter."];
    }
}

#pragma mark - VK Share
-(void)shareVK:(id)info {
    SCOPE = @[VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS, VK_PER_EMAIL, VK_PER_MESSAGES];
    [VKSdk initializeWithDelegate:self andAppId:@"4553914"];
    if ([VKSdk wakeUpSession])
    {
        [self startWorking];
    } else {
        [self authorize:nil];
    }
}
- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
	VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
	[vc presentIn:self];
}
- (void)startWorking {
    NSDictionary * info = self.webInfo;
    NSString * desc = @" ";
    NSString * name = @"";
    
    if ([info valueForKey:@"name"]) {
        if (![[info valueForKey:@"name"] isKindOfClass:[NSNull class]]) {
            name = [info valueForKey:@"name"];
        }
    }
    //description
    if ([info valueForKey:@"description"]) {
        if (![[info valueForKey:@"description"] isKindOfClass:[NSNull class]]) {
            desc = [info valueForKey:@"description"];
            desc = [self flattenHTML:desc];
            name = [NSString stringWithFormat:@"%@\n %@",name,desc];
        }
    }
    
    VKShareDialogController * shareDialog = [VKShareDialogController new];
    shareDialog.text = [NSString stringWithFormat:@"%@",name];
        if (shareImage) {
        shareDialog.uploadImages = @[[VKUploadImage uploadImageWithImage:shareImage  andParams:[VKImageParameters jpegImageWithQuality:1]]];
    }
    shareDialog.otherAttachmentsStrings =sharedUrl.length == 0?nil:@[sharedUrl];
    [shareDialog performSelector:@selector(presentIn:) withObject:self afterDelay:0.9];
}
- (IBAction)authorize:(id)sender {
	[VKSdk authorize:SCOPE revokeAccess:YES];
}
- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {
	[self authorize:nil];
}

- (void)vkSdkReceivedNewToken:(VKAccessToken *)newToken {
    [self startWorking];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
	[self presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkAcceptedUserToken:(VKAccessToken *)token {
    [self startWorking];
}
- (void)vkSdkUserDeniedAccess:(VKError *)authorizationError {
	[[[UIAlertView alloc] initWithTitle:nil message:@"Access denied" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}


- (NSString *)flattenHTML:(NSString *)html {
    
   NSString* desc = [webDescriptionView stringByEvaluatingJavaScriptFromString:@"document.body.getElementsByTagName('article')[0].innerText;"];
    desc = [webDescriptionView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
    return desc;
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    //
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}
@end