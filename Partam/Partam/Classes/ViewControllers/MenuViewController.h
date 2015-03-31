//
//  MenuViewController.h
//  Partam
//
//  Created by Sargis Gevorgyan on 2/25/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccordionView.h"
#import "AboutViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "FavoritesViewController.h"
#import "EditViewController.h"
#import "MainViewController.h"


@interface MenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate> {
    
    IBOutlet UIImageView *imgLogo;
    
    IBOutlet UIView *mainView;
             UIView *viewCity;
             UIView *viewCategory;
    
    IBOutlet UISearchBar *searchBar;
    
    AccordionView * accordion;
    
    IBOutlet UIButton *btnLogin;
             UIButton *btnSelectCounty;
             UIButton *btnCategory;
             UIButton *btnFavorites;
             UIButton *btnAboutApp;
             UIButton *btnSignOut;
    IBOutlet UIButton *btnKeyBoardHide;
    
    UITableView * tblCity;
    UITableView * tblCategory;
    
    
    NSMutableDictionary * locations;
    NSDictionary* selectedCity;
    NSDictionary* selectedCategory;
    
    NSMutableArray * countiesArray;
    NSMutableArray * selectedCategoriesArray;
    NSMutableArray * categories;
    
   __weak IBOutlet WebImage *userImage;
    IBOutlet UILabel *lblUserName;
    IBOutlet UILabel *lblVersion;
}
- (IBAction)btnLoginPressed:(id)sender;
- (IBAction)btnAboutAppPressed:(id)sender;
- (IBAction)btnHideMenuPressed:(id)sender;
- (IBAction)btnFavoritPressed:(id)sender;
- (IBAction)btnKeyBoardHidePressed:(id)sender;

@end
