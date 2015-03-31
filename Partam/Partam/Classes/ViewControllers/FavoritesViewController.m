//
//  FavoritesViewController.m
//  Partam
//
//  Created by Sargis Gevorgyan on 3/6/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import "FavoritesViewController.h"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

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
    
    if (![AppManager sharedInstance].userFavorites) {
        UINavigationController* centerViewController = (UINavigationController*)self.mm_drawerController.centerViewController;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        LoginViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        viewController.isFavorites = YES;
        [centerViewController pushViewController:viewController animated:NO];
    }
    btnKeyBoardHide.hidden = YES;
    
     	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (IOS_VERSION >= 7.0) {
        
        
       
        [favSearchBar setBarTintColor:[UIColor redColor]];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:193.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:1.0]];
        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menuIcon.png"] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonPress:)];
        
        self.navigationItem.leftBarButtonItem = leftButton;
        rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 0, 27, 27);
        [rightButton setImage:[UIImage imageNamed:@"btnEdit.png"] forState:UIControlStateNormal];
        
        [rightButton addTarget:self action:@selector(rightButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        //        rightBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"locationIcon.png"] style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonPress:)];
        //
        
        self.navigationItem.rightBarButtonItem = rightBarButton;
    } else {
        [self.searchDisplayController.searchBar setBackgroundImage:[UIImage imageNamed:@"bgSearchBar"] forBarPosition:0 barMetrics:UIBarMetricsDefault];
        
        [[favSearchBar.subviews objectAtIndex:1] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgSearchBar"]]];
        [[favSearchBar.subviews objectAtIndex:1] setBorderStyle:UITextBorderStyleRoundedRect];
        [[favSearchBar.subviews objectAtIndex:0] removeFromSuperview];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:193.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:1.0]];
        //        [self.navigationController.navigationBar setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgNavigationBar"]]];
        rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 0, 27, 27);
        [rightButton setImage:[UIImage imageNamed:@"btnEdit.png"] forState:UIControlStateNormal];
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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"Favorites";
    if ([AppManager sharedInstance].userFavorites) {
    
    webInfoArray = [[NSMutableArray alloc]initWithArray:[AppManager sharedInstance].userLocalFavorites];
        tblFavorites.dataSource = self;
        tblFavorites.delegate = self;
        [tblFavorites reloadData];
         [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}

#pragma mark  TableView Delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return webInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    NSDictionary * currentInfo = webInfoArray[indexPath.row];
    FavoritesView * currrentView = [[FavoritesView alloc]initWithFrame:CGRectMake(0, 0, 320, 110) pointInfo:currentInfo];
    [cell addSubview:currrentView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UINavigationController* centerViewController = (UINavigationController*)self.mm_drawerController.centerViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    NSDictionary * currentInfo = webInfoArray[indexPath.row];
    viewController.mainInfo = currentInfo;
    
    viewController.category = [[currentInfo valueForKey:@"category"] valueForKey:@"title"];

    [centerViewController pushViewController:viewController animated:YES];
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
    if (fromIndexPath!=toIndexPath) {
        NSDictionary * dict = webInfoArray[fromIndexPath.row];
        [webInfoArray removeObject:dict];
        [webInfoArray insertObject:dict atIndex:toIndexPath.row];
        [[AppManager sharedInstance].userLocalFavorites removeObject:dict];
        [[AppManager sharedInstance].userLocalFavorites insertObject:dict atIndex:toIndexPath.row];
        [[AppManager sharedInstance] saveSettings];
    }
    
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary * dict = webInfoArray[indexPath.row];
       NSDictionary* webdict=  [[AppManager sharedInstance] addOrRemoveFavorites:[[dict valueForKey:@"id"]integerValue] method:@"UNLINK"];
        if ([[webdict valueForKey:@"success"]integerValue] == 1) {
            [webInfoArray removeObject:dict];
            [[AppManager sharedInstance].userLocalFavorites removeObject:dict];
            [[AppManager sharedInstance] loadUserFavorites];
            [[AppManager sharedInstance] saveSettings];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

#pragma mark - Button Handlers

-(void)leftButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightButtonPress:(id)sender{
    
    [tblFavorites setEditing:!tblFavorites.editing animated:YES];
}

#pragma mark UISearchBareDelegate methods
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    btnKeyBoardHide.hidden = NO;
    [self.view addSubview:btnKeyBoardHide];
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    favSearchBar.showsCancelButton = YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    favSearchBar.showsCancelButton = YES;
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    favSearchBar.showsCancelButton = NO;
    btnKeyBoardHide.hidden = YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        webInfoArray =[[NSMutableArray alloc]initWithArray:[AppManager sharedInstance].userLocalFavorites];
        [tblFavorites reloadData];
        return;
    }
    webInfoArray =[[NSMutableArray alloc]initWithArray:[[AppManager sharedInstance].userLocalFavorites filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name contains[cd]%@",searchText]]];
    [tblFavorites reloadData];
    
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0) {
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)tsearchBar {
    
    [favSearchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) tsearchBar {
    [favSearchBar resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnKeyBoardHidePressed:(id)sender {
    [favSearchBar resignFirstResponder];
}
@end
