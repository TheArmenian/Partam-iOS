//
//  DetailViewController.h
//  Partam
//
//  Created by Sargis Gevorgyan on 3/3/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "UIViewController+MMDrawerController.h"
#import "WebImage.h"
#import "RouteMapViewController.h"
#import "MainViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface DetailViewController : UIViewController<MKMapViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,UINavigationControllerDelegate> {
    
    IBOutlet UIScrollView *mainScrollView;
    IBOutlet UIScrollView *imagesScrollView;
    
    IBOutlet MKMapView *detailMapView;
    
    UIBarButtonItem *rightBarButton;
    UIButton * rightButton;

    NSMutableDictionary * webInfo;
    NSMutableArray * detailInfoArray;
    
    __weak IBOutlet UIButton *btnSelectMap;
    __weak IBOutlet UIImageView *bgMapDetailView;
    
    IBOutlet UIImageView *gbImageDetailMapView;
    
    IBOutlet UIPageControl *imgPageControll;
    
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblcity;
    
    NSInteger cellCount;
    float webViewHeight;
    
    NSArray * picturesArray;
    NSArray * videosArray;
    NSMutableArray * commentsArray;
    
    IBOutlet UIWebView *webDescriptionView;
    
    IBOutlet UITableView *detailTableView;
    
    IBOutlet UILabel *lblCommentCount;
    IBOutlet UILabel *lblCategory;
    
    IBOutlet UIButton *btnLogin;
    
    IBOutlet UIView *mapGridView;
    IBOutlet UIView *bgButtons;
    
    IBOutlet UITextField *txtComment;
    
    IBOutlet UIView *loadingView;
    IBOutlet UIButton *btnHideKeyBoard;
    BOOL isCommentAdded;
    
    int height;
    
    Pinterest*  _pinterest;
    
    NSString * sharedUrl;
    NSString * sharedImgUrl;
    UIImage * shareImage;
    
    NSMutableArray * images;
    
}

@property(nonatomic,assign)int detailId;
@property(nonatomic,strong)NSMutableDictionary * webInfo;
@property(nonatomic,strong)NSDictionary * mainInfo;
@property(nonatomic,strong)NSDictionary * pointCategoryInfo;
@property(nonatomic,strong)NSString * category;

- (IBAction)btnLoginPressed:(id)sender;
- (IBAction)btnPostPressed:(id)sender;
- (IBAction)btnHideKeyBoardPressed:(id)sender;
- (IBAction)btnSelectMap:(id)sender;
- (int)getCellHeight;

@end
