//
//  MenuViewController.m
//  Partam
//
//  Created by Sargis Gevorgyan on 2/25/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import "MenuViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

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
    locations = [[NSMutableDictionary alloc]initWithDictionary:[[AppManager sharedInstance] loadLocationsInfo:@"locations"]];
    categories = [[NSMutableArray alloc]initWithArray:[[AppManager sharedInstance] loadCategoriesInfo:@"categories"]];
    countiesArray = [NSMutableArray new];
    
    NSArray * countries =[locations valueForKey:@"countries"];
    NSSortDescriptor* sortDesctriptor =[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray * sortArray=[[NSArray alloc]initWithObjects:sortDesctriptor, nil];
    countries = [countries sortedArrayUsingDescriptors:sortArray];
    countiesArray = [NSMutableArray new];// [cities valueForKey:@"cities"];
    for (int i = 0; i < countries.count; i ++) {
        NSMutableDictionary * cities = [[NSMutableDictionary alloc] initWithDictionary:countries[i] copyItems:YES];
        NSSortDescriptor* sortDesctriptor =[NSSortDescriptor sortDescriptorWithKey:@"city" ascending:YES];
        NSArray * sortArray=[[NSArray alloc]initWithObjects:sortDesctriptor, nil];
        NSArray * sortingCitiesArray = [cities valueForKey:@"cities"];
        sortingCitiesArray = [sortingCitiesArray sortedArrayUsingDescriptors:sortArray];
        [cities setValue:sortingCitiesArray forKey:@"cities"];
       [countiesArray addObject:cities];
    }
    sortDesctriptor =[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    sortArray=[[NSArray alloc]initWithObjects:sortDesctriptor, nil];
    categories =[[NSMutableArray alloc]initWithArray:[categories sortedArrayUsingDescriptors:sortArray]];
    if (IOS_VERSION >= 7.0) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        mainView.frame = CGRectMake(0, 22, mainView.frame.size.width, mainView.frame.size.height);
        [searchBar setBarTintColor:[UIColor whiteColor]];
    } else {
     
        [self.searchDisplayController.searchBar setBackgroundImage:[UIImage imageNamed:@"bgSearchBar"] forBarPosition:0 barMetrics:UIBarMetricsDefault];
        
        [[searchBar.subviews objectAtIndex:1] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgSearchBar"]]];
        [[searchBar.subviews objectAtIndex:1] setBorderStyle:UITextBorderStyleRoundedRect];
        [[searchBar.subviews objectAtIndex:0] removeFromSuperview];
    }
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    
    // Change search bar text color
    searchField.textColor = [UIColor whiteColor];
    searchField.textAlignment = NSTextAlignmentLeft;
    // Change the search bar placeholder text color
    [searchField setTintColor:[UIColor whiteColor]];
    [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    UIImage *image = [UIImage imageNamed: @"searchIcon.png"];
    UIImageView *iView = [[UIImageView alloc] initWithImage:image];
    searchField.leftView = iView;
    
   
    tblCategory.allowsMultipleSelectionDuringEditing = YES;
    selectedCategoriesArray = [NSMutableArray new];
    [tblCategory reloadData];
    [tblCity reloadData];
    [self initAccordeonView];
    
    userImage.layer.cornerRadius = 5;
    btnKeyBoardHide.hidden = YES;
    NSString* version = [NSString stringWithFormat:@"Version %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    lblVersion.text = version;
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar.layer removeAllAnimations];
   
    if (![AppManager sharedInstance].isLogOut) {
       NSDictionary* userInfo = [[AppManager sharedInstance].userInfo valueForKey:@"user"];
        if ([userInfo isKindOfClass:[NSDictionary class]]) {
            [btnLogin setImage:[UIImage imageNamed:@"btnLoginSelected"] forState:UIControlStateNormal];
            btnLogin.selected = YES;
            btnSignOut.hidden = NO;
            lblUserName.text = [userInfo valueForKey:@"display_name"];
            [userImage setImageURL:[userInfo valueForKey:@"picture"] completion:^(UIImage *image) {
                userImage.image = image;
            }];
           [userImage setHidden:NO];
            if (!userImage) {
                //userImage =[[WebImage alloc]initWithFrame:CGRectMake(6, 3, 35, 35) imageURL:[userInfo valueForKey:@"picture"]];
                
                userImage.layer.cornerRadius = 5;
                
            }
            
        } else {
            btnSignOut.hidden = YES;
            btnLogin.selected = NO;
            [btnLogin setImage:[UIImage imageNamed:@"btnLogin"] forState:UIControlStateNormal];
            lblUserName.text = @"";
            [userImage setHidden:YES];
            
        }
    
    } else {
        btnSignOut.hidden = YES;
         btnLogin.selected = NO;
        [btnLogin setImage:[UIImage imageNamed:@"btnLogin"] forState:UIControlStateNormal];
        lblUserName.text = @"";
        [userImage setHidden:YES];
        
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [searchBar resignFirstResponder];
}

- (void)initAccordeonView {
    accordion = [[AccordionView alloc] initWithFrame:CGRectMake(0, 170, 267, [[UIScreen mainScreen] bounds].size.height-130)];
    
    [mainView addSubview:accordion];
    self.view.backgroundColor = [UIColor colorWithRed:0.925 green:0.941 blue:0.945 alpha:1.000];
    
    // Only height is taken into account, so other parameters are just dummy
    btnSelectCounty = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 42)];
    btnSelectCounty.tintColor = [UIColor clearColor];
    btnSelectCounty.tag = 0;
    [btnSelectCounty setImage:[UIImage imageNamed:@"btnSelectCounty"] forState:UIControlStateNormal];
    [btnSelectCounty setImage:[UIImage imageNamed:@"btnSelectCountySelected"] forState:UIControlStateSelected];
    viewCity = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 160)];
    viewCity.backgroundColor = [UIColor clearColor];
    tblCity =[[UITableView alloc]init];
    tblCity.delegate = self;
    tblCity.tag = 1;
    tblCity.dataSource = self;
    tblCity.backgroundColor = [UIColor clearColor];
    tblCity.frame =CGRectMake(0, 0, 263, 160);
    [viewCity addSubview:tblCity];
    [accordion addHeader:btnSelectCounty withView:viewCity];
    
    
    btnCategory = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 42)];
    btnCategory.tintColor = [UIColor clearColor];
    btnCategory.tag = 1;
    [btnCategory setImage:[UIImage imageNamed:@"btnCategory"] forState:UIControlStateNormal];
    [btnCategory setImage:[UIImage imageNamed:@"btnCategorySelected"] forState:UIControlStateSelected];
    viewCategory = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 160)];
    viewCategory.backgroundColor = [UIColor clearColor];
    tblCategory =[[UITableView alloc]init];
    tblCategory.delegate = self;
    tblCategory.dataSource = self;
    tblCategory.tag = 2;
    tblCategory.allowsMultipleSelectionDuringEditing = YES;
    tblCategory.backgroundColor = [UIColor clearColor];
    tblCategory.frame =CGRectMake(0, 0, 263, 160);
    [viewCategory addSubview:tblCategory];
    [accordion addHeader:btnCategory withView:viewCategory];
    
    btnFavorites = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 42)];
    btnFavorites.tag = 2;
    [btnFavorites setImage:[UIImage imageNamed:@"btnFavorites"] forState:UIControlStateNormal];
    [btnFavorites addTarget:self action:@selector(btnFavoritPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIView *viewFavorites = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    viewFavorites.backgroundColor = [UIColor clearColor];
    [accordion addHeader:btnFavorites withView:viewFavorites];
    
    btnAboutApp = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 42)];
    [btnAboutApp setImage:[UIImage imageNamed:@"btnAboutApp"] forState:UIControlStateNormal];
    btnAboutApp.tag = 3;
    [btnAboutApp addTarget:self action:@selector(btnAboutAppPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIView *viewboutApp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    viewboutApp.backgroundColor = [UIColor clearColor];
    [accordion addHeader:btnAboutApp withView:viewboutApp];
    btnSignOut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 42)];
    [btnSignOut setImage:[UIImage imageNamed:@"btnSignOut"] forState:UIControlStateNormal];
    [btnSignOut addTarget:self action:@selector(btnLoginPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIView *viewSignOut = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    viewSignOut.backgroundColor = [UIColor clearColor];
    [accordion addHeader:btnSignOut withView:viewSignOut];
    btnSignOut.hidden = YES;
    btnSignOut.tag = 4;
    if (![AppManager sharedInstance].isLogOut) {
        btnSignOut.hidden = NO;
    }
    
    
    
    
    [accordion setNeedsLayout];
    
    // Set this if you want to allow multiple selection
    [accordion setAllowsMultipleSelection:YES];
    
    // Set this to NO if you want to have at least one open section at all times
    [accordion setAllowsEmptySelection:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnLoginPressed:(id)sender {
    
    if ([sender tag] == 4) {
         [userImage setHidden:YES];
        
        [[AppManager sharedInstance] performSelectorInBackground:@selector(userLogout) withObject:nil];
    }
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    [(UINavigationController*)self.mm_drawerController.centerViewController popToRootViewControllerAnimated:NO];
    UINavigationController* centerViewController = (UINavigationController*)self.mm_drawerController.centerViewController;
       UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (btnLogin.selected && [sender tag] == 0) {
        EditViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"EditViewController"];
        
        [centerViewController pushViewController:viewController animated:NO];
    } else {
        LoginViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        viewController.isFavorites = NO;
        [centerViewController pushViewController:viewController animated:NO];
    }
    
}

- (IBAction)btnFavoritPressed:(id)sender{

    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
    UINavigationController* centerViewController = (UINavigationController*)self.mm_drawerController.centerViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FavoritesViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"FavoritesViewController"];
    [centerViewController pushViewController:viewController animated:NO];
}

- (IBAction)btnKeyBoardHidePressed:(id)sender {
    [searchBar resignFirstResponder];
}

- (IBAction)btnAboutAppPressed:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    UINavigationController* centerViewController = (UINavigationController*)self.mm_drawerController.centerViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AboutViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
    
    [centerViewController pushViewController:viewController animated:NO];
}

- (IBAction)btnHideMenuPressed:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    [(UINavigationController*)self.mm_drawerController.centerViewController popToRootViewControllerAnimated:YES];
}

#pragma mark UITableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 1) {
    return countiesArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    if (tableView.tag == 1) {
        NSArray * cities = [countiesArray[section] valueForKey:@"cities"];
        return [cities count];
    }
    return categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgTblViewCell"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
//    [tableView setTintColor:[UIColor clearColor]];
    UIImageView * checkMark =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    checkMark.userInteractionEnabled = YES;
    if (tableView.tag == 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [checkMark setImage:[UIImage imageNamed:@""]];
        
        NSDictionary * city = [countiesArray[indexPath.section] valueForKey:@"cities"][indexPath.row];
        if ([city isEqualToDictionary:selectedCity]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [checkMark setImage:[UIImage imageNamed:@"checkBox.png"]];
        }
        cell.textLabel.text = [city valueForKey:@"city"];
    } else {
        NSDictionary * category = categories[indexPath.row];
        [checkMark setImage:[UIImage imageNamed:@""]];
         cell.accessoryType = UITableViewCellAccessoryNone;
        for (int i = 0; i < selectedCategoriesArray.count; i++) {
            if ([category isEqualToDictionary:selectedCategoriesArray[i]]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [checkMark setImage:[UIImage imageNamed:@"checkBox.png"]];
            }
        }
    
        cell.textLabel.text = [category valueForKey:@"title"];
       
    }

     cell.accessoryView = checkMark;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
     UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (tableView.tag == 1) {
            selectedCity = nil;
            [tblCity reloadData];
        } else {
            selectedCategory = nil;
            [selectedCategoriesArray removeObject:categories[indexPath.row]];
            [tblCategory reloadData];
        }
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        if (tableView.tag == 1) {
            selectedCity = [countiesArray[indexPath.section] valueForKey:@"cities"][indexPath.row];
            [tblCity reloadData];
        } else {
            selectedCategory = categories[indexPath.row];
            [selectedCategoriesArray addObject:categories[indexPath.row]];
            [tblCategory reloadData];
        }
    }
    [self sendRequest];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 265, 30)];
        view.backgroundColor =[UIColor colorWithRed:116.0/255.0 green:101.0/255.0 blue:110.0/255.0 alpha:1.0];
        UILabel * lblCity = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 245, 20)];
        lblCity.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
        lblCity.textColor = [UIColor whiteColor];
        lblCity.text = [countiesArray[section] valueForKey:@"name"];
        [view addSubview:lblCity];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        return 20;
    }
    return 0;
}

-(void)sendRequest {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    UINavigationController* centerViewController = (UINavigationController*)self.mm_drawerController.centerViewController;
    MainViewController * viewController;
    for (int i = 0; i < centerViewController.viewControllers.count;i++) {
        UIViewController * vc = centerViewController.viewControllers[i];
        if ([vc isKindOfClass:[MainViewController class]]) {
            viewController = (MainViewController*)vc;
            break;
        }
    }
//    NSArray * loadingInfo;
    if (selectedCity && selectedCategoriesArray.count == 0) {
//        loadingInfo = [[AppManager sharedInstance] loadPointByCity_latitude:[selectedCity valueForKey:@"lat"] longitude:[selectedCity valueForKey:@"lng"] limit:10 offSet:0];
        viewController.isCanLoaded = YES;
        viewController.selectedCitylimit = 0;
        viewController.city = selectedCity;
        viewController.isCanLoadedPointByCity = YES;
        viewController.isCanLoadedPointByCityAndCategory = NO;
        viewController.isCanLoadedPointByCategory = NO;
    }
    else if (selectedCity && selectedCategoriesArray.count > 0){
        NSString * categoriesID = [NSString stringWithFormat:@"%@",[selectedCategoriesArray[0] valueForKey:@"id"]];
        for (int i = 1; i < selectedCategoriesArray.count ; i ++) {
            categoriesID =[NSString stringWithFormat:@"%@,%@",categoriesID,[selectedCategoriesArray[i] valueForKey:@"id"]];
        }
//        loadingInfo = [[AppManager sharedInstance] loadPointByCategoriesAndCity:categoriesID latitude:[selectedCity valueForKey:@"lat"] longitude:[selectedCity valueForKey:@"lng"] limit:10 offSet:0];
        
        viewController.isCanLoaded = YES;
        viewController.city = selectedCity;
        viewController.categoriresID = categoriesID;
        viewController.selectedCityCategorylimit = 0;
        viewController.isCanLoadedPointByCity = NO;
        viewController.isCanLoadedPointByCityAndCategory = YES;
        viewController.isCanLoadedPointByCategory = NO;
    }
    else if (!selectedCity && selectedCategoriesArray.count > 0) {
        NSString * categoriesID = [NSString stringWithFormat:@"%@",[selectedCategoriesArray[0] valueForKey:@"id"]];
        for (int i = 1; i < selectedCategoriesArray.count ; i ++) {
            categoriesID =[NSString stringWithFormat:@"%@,%@",categoriesID,[selectedCategoriesArray[i] valueForKey:@"id"]];
        }
//        loadingInfo = [[AppManager sharedInstance] loadPointByCategory:categoriesID limit:0];
        viewController.isCanLoaded = YES;
        viewController.city = selectedCity;
        viewController.categoriresID = categoriesID;
        viewController.selectedCategorylimit = 0;
        viewController.isCanLoadedPointByCity = NO;
        viewController.isCanLoadedPointByCityAndCategory = NO;
        viewController.isCanLoadedPointByCategory = YES;
    }
    else if (!selectedCity && selectedCategoriesArray.count == 0) {
        
//        int count = viewController.count;
//        int limit = 0;
        viewController.limit = -10;
//        viewController.webInfoArray =[[NSMutableArray alloc]initWithArray:[[AppManager sharedInstance] loadWebInfo:count :limit]];
        viewController.isCanLoaded = YES;
        viewController.isCanLoadedPointByCity = NO;
        viewController.isCanLoadedPointByCityAndCategory = NO;
        viewController.isCanLoadedPointByCategory = NO;
//        [viewController.mainTblView reloadData];
//        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//        return;
    }
    
    viewController.webInfoArray =[[NSMutableArray alloc]init];
//    [viewController.mainTblView performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];
   viewController.loadingView.hidden = NO;
   viewController.lblWarning.hidden = YES;
    
 [viewController sendLoadPointsRequest];
}

-(void)sendSearchRequest:(NSString*)string {
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    UINavigationController* centerViewController = (UINavigationController*)self.mm_drawerController.centerViewController;
    MainViewController * viewController;
    for (int i = 0; i < centerViewController.viewControllers.count;i++) {
        UIViewController * vc = centerViewController.viewControllers[i];
        if ([vc isKindOfClass:[MainViewController class]]) {
            viewController = (MainViewController*)vc;
            break;
        }
    }
    [AppManager sharedInstance].isFilter = YES;
    viewController.isCanLoaded = YES;
    viewController.loadingView.hidden = NO;
    viewController.lblWarning.hidden = YES;
    [WebServiceManager loadSearchPoints:searchBar.text completion:^(id response, NSError *error) {
        viewController.loadingView.hidden = YES;
        if (!error) {
            viewController.webInfoArray =[[NSMutableArray alloc]initWithArray:response];
            viewController.isCanLoaded = NO;
            [viewController.mainTblView reloadData];
        }
        NSArray * points = response;
        
        if ([points count] == 0) {
            viewController.lblWarning.hidden = NO;
        }
    }];
}

#pragma mark UISearchBareDelegate methods
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    btnKeyBoardHide.hidden = NO;
//    [self.view addSubview:btnKeyBoardHide];
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)tsearchBar {
    searchBar.showsCancelButton = YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)tsearchBar {
    searchBar.showsCancelButton = NO;
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)tsearchBar {
   
     [(UINavigationController*)self.mm_drawerController.centerViewController popViewControllerAnimated:YES];
    btnKeyBoardHide.hidden = YES;
    UINavigationController* centerViewController = (UINavigationController*)self.mm_drawerController.centerViewController;
    MainViewController * viewController;
    for (int i = 0; i < centerViewController.viewControllers.count;i++) {
        UIViewController * vc = centerViewController.viewControllers[i];
        if ([vc isKindOfClass:[MainViewController class]]) {
           viewController = (MainViewController*)vc;
            break;
        }
    }
    if (searchBar.text.length == 0 && viewController.isCanLoaded) {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        return;
    } else if (searchBar.text.length == 0) {
        int count = viewController.count;
        int limit = 0;
        [AppManager sharedInstance].isFilter = NO;
        [WebServiceManager loadPointInfo:count :limit completion:^(id response, NSError *error) {
            if (!error) {
                viewController.webInfoArray =response;
            }
            viewController.webInfoArray = response;
            viewController.isCanLoaded = YES;
            [viewController.mainTblView reloadData];
        }];
       
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        return;
    }
    [self sendSearchRequest:searchBar.text];
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0) {
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)tsearchBar {
    
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) tsearchBar {
    tsearchBar.text = @"";
    [searchBar resignFirstResponder];
}
@end
