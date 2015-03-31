//
//  FavoritesViewController.h
//  Partam
//
//  Created by Sargis Gevorgyan on 3/6/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebImage.h"
#import "FavoritesView.h"
#import "UIViewController+MMDrawerController.h"
#import "DetailViewController.h"

@interface FavoritesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate> {
    
    IBOutlet UITableView *tblFavorites;
    IBOutlet UISearchBar *favSearchBar;
    
    NSMutableArray * webInfoArray;
    NSMutableDictionary * webInfoDict;
    
    UIBarButtonItem *rightBarButton;
    UIButton * rightButton;
    IBOutlet UIButton *btnKeyBoardHide;
}
- (IBAction)btnKeyBoardHidePressed:(id)sender;

@end
