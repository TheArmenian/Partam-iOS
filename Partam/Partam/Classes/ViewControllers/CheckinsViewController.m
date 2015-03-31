//
//  CheckinsViewController.m
//  Partam
//
//  Created by Asatur Galstyan on 1/20/15.
//  Copyright (c) 2015 Zanazan Systems. All rights reserved.
//

#import "CheckinsViewController.h"
#import "CheckinCell.h"
#import "LoginViewController.h"


@interface CheckinsViewController() <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CheckinViewDelegate> {
    
    __weak IBOutlet UITableView *tblCheckin;
    __weak IBOutlet UIView *loadingView;
    
    __weak IBOutlet UILabel *lblName;
    __weak IBOutlet UILabel *lblcity;
    __weak IBOutlet UILabel *lblCategory;
    __weak IBOutlet UILabel *lblCheckins;
    __weak IBOutlet UILabel *lblComments;
    
    NSArray *checkins;
    
}

@end

@implementation CheckinsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btnBack.png"] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonPress:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logotxt.png"]];
    
    loadingView.layer.cornerRadius = 10;
    
    lblName.text = [self.webInfo valueForKey:@"name"];
    lblcity.text = [self.webInfo valueForKey:@"city"];
    lblCategory.text = self.category;
    
    NSArray *commentsArray = [self.webInfo valueForKey:@"comments"];
    lblComments.text = [NSString stringWithFormat:@"%lu",(unsigned long)commentsArray.count];
    
    [self loadCheckins];
    
}

- (void)loadCheckins {
    loadingView.hidden = NO;
    NSString* pointID = [self.webInfo[@"id"] stringValue];
    [WebServiceManager checkinsForPoint:pointID completion:^(id response, NSError *error) {
        
        loadingView.hidden = YES;
        
        if (response) {
            checkins = response;
            lblCheckins.text = [NSString stringWithFormat:@"%lu",(unsigned long)checkins.count];
            [tblCheckin reloadData];
        }
    }];
}

-(void)leftButtonPress:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnCheckinTap:(id)sender {
    
    if (![AppManager sharedInstance].userFavorites) {
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

#pragma mark CheckinViewDelegate 

- (void)deleteCheckinAtIndex:(NSInteger)index {
    
    NSDictionary *checkin = checkins[index];
    
    loadingView.hidden = NO;
    [WebServiceManager deleteCheckin:checkin[@"id"] completion:^(id response, NSError *error) {
        loadingView.hidden = YES;
        [self loadCheckins];
    }];
}

#pragma mark UIImagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    loadingView.hidden = NO;
    [WebServiceManager addSelfie:image point:[[self.webInfo valueForKey:@"id"] stringValue] completion:^(id response, NSError *error) {
        loadingView.hidden = YES;
        [self loadCheckins];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableView Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 350;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [checkins count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CheckinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckinCell"];
    cell.tag = indexPath.row;
    cell.delegate = self;
    [cell setInfo:checkins[indexPath.row]];
    
    return cell;
}

@end
