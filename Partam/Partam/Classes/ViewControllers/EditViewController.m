//
//  EditViewController.m
//  Partam
//
//  Created by Sargis Gevorgyan on 3/7/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()

@end

@implementation EditViewController

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
    btnHideKeyBoard.hidden = YES;
    loadingView.hidden = YES;
    loadingView.layer.cornerRadius = 10;
    if (IOS_VERSION >= 7.0) {
        
        
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:193.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:1.0]];
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:193.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:1.0]];
        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menuIcon.png"] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonPress:)];
        
        self.navigationItem.leftBarButtonItem = leftButton;
        rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 0, 27, 27);
        [rightButton setImage:[UIImage imageNamed:@"btnEditDone.png"] forState:UIControlStateNormal];
        
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
        [rightButton setImage:[UIImage imageNamed:@"btnEditDone.png"] forState:UIControlStateNormal];
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
    self.navigationItem.title = @"Edit Profile";
    
    mainScrollView.contentSize = CGSizeMake(320, 580);
    
    userInfo = [[AppManager sharedInstance].userInfo valueForKey:@"user"];
    txtEmail.text = [userInfo valueForKey:@"email"];
    txtFirstName.text = [userInfo valueForKey:@"display_name"];
    txtLastName.text = [userInfo valueForKey:@"lastname"];
    txtLocation.text = [userInfo valueForKey:@"current_city"];
    userImg.layer.cornerRadius = 10;
   userImage = [[WebImage alloc] initWithFrame:CGRectMake(0, 0 , userImg.frame.size.width, userImg.frame.size.height)];
    __weak WebImage * imgWeb = userImage;
    [imgWeb setImageURL:[userInfo valueForKey:@"picture"] completion:^(UIImage *image) {
        imgWeb.image = image;
    }];
    userImage.layer.cornerRadius = 10;
    
    [userImg addSubview:userImage];

	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
#pragma mark - Button Handlers

-(void)leftButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    //    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightButtonPress:(id)sender{
    if ([txtEmail.text isEqual:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"Your information is incomplete"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if ((![txtEmail.text isEqualToString:@""] && txtEmail.text != nil)) {
        if (![[AppManager sharedInstance] validateEmail:txtEmail.text]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                            message:@"Your email address is not valid"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            return;
        }
    }
    if ((![txtNewPass.text isEqual:txtRepeatPass.text]) && txtNewPass.text.length > 0 && txtRepeatPass.text.length > 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"These passwords don't match."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    loadingView.hidden = NO;
    [self btnHideKeyBoardPressed:nil];
    [self performSelector:@selector(sendRequest) withObject:nil afterDelay:0.1];
}

-(void)sendRequest {
    NSString * format = [NSString stringWithFormat:@"user[firstname]=%@&user[lastname]=%@&user[displayName]=%@&user[currentCity]=%@",[userInfo valueForKey:@"firstname"],txtLastName.text,txtFirstName.text,txtLocation.text];
    [[AppManager sharedInstance] changeUserInfo:format];
    if (txtNewPass.text.length > 0 && txtRepeatPass.text.length > 0) {
        format = [NSString stringWithFormat:@"password[new][first]=%@&password[new][first]=%@",txtNewPass.text,txtRepeatPass.text];
        [[AppManager sharedInstance] changeUserPass:format];
    }
    NSData *imageData = UIImagePNGRepresentation([AppManager captureView:userImg]);
    
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"user[file]\"; filename=userAvatar.png" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type:image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [[AppManager sharedInstance] changeUserAvatar:body];
    [[AppManager sharedInstance] loadUserInfo];
    loadingView.hidden = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnConnectFBPressed:(id)sender {
    UINavigationController* centerViewController = (UINavigationController*)self.mm_drawerController.centerViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    viewController.isFavorites = NO;
    [viewController performSelector:@selector(btnViaFBPressed:) withObject:nil afterDelay:0.5];
    [centerViewController pushViewController:viewController animated:YES];
}

- (IBAction)btnLogOutPressed:(id)sender {
    loadingView.hidden = NO;
    [self performSelector:@selector(sendLogoutRequest) withObject:nil afterDelay:0.1];
}

-(void)sendLogoutRequest {
    [[AppManager sharedInstance] performSelectorInBackground:@selector(userLogout) withObject:nil];
    loadingView.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnChoosImagePressed:(id)sender {
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



- (IBAction)btnHideKeyBoardPressed:(id)sender {
    btnHideKeyBoard.hidden = YES;
    [txtFirstName resignFirstResponder];
    [txtLastName resignFirstResponder];
    [txtEmail resignFirstResponder];
    [txtNewPass resignFirstResponder];
    [txtRepeatPass resignFirstResponder];
    [txtLocation resignFirstResponder];
}

#pragma mark UITextFieldDelegate methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    btnHideKeyBoard.hidden = NO;
    
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:txtFirstName]) {
        [mainScrollView setContentOffset:CGPointMake(0, [AppManager sharedInstance].isiPhone5?56:144) animated:YES];
    }
    if ([textField isEqual:txtEmail]) {
        [mainScrollView setContentOffset:CGPointMake(0, [AppManager sharedInstance].isiPhone5?112:200) animated:YES];
    }
    if ([textField isEqual:txtNewPass]) {
        [mainScrollView setContentOffset:CGPointMake(0, [AppManager sharedInstance].isiPhone5?168:256) animated:YES];
    }
    if ([textField isEqual:txtRepeatPass]) {
        [mainScrollView setContentOffset:CGPointMake(0, [AppManager sharedInstance].isiPhone5?222:310) animated:YES];
    }
    if ([textField isEqual:txtLocation]) {
        [mainScrollView setContentOffset:CGPointMake(0, [AppManager sharedInstance].isiPhone5?237:325) animated:YES];
    }
    
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
     [mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
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


#pragma mark UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self takePhoto];
    }
    if (buttonIndex == 1) {
        [self loadPhoto];
    }
}

- (void) loadPhoto {
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;

    [self presentViewController:imagePicker animated:YES completion:nil];
 
}

- (void)takePhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        cameraPicker = [[UIImagePickerController alloc] init];
        cameraPicker.delegate = self;
//        cameraPicker.wantsFullScreenLayout = YES;
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
    
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [picker dismissViewControllerAnimated:YES completion:nil];
   
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];

    userImage.image = image;
    userImage.layer.cornerRadius = 10;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [picker dismissViewControllerAnimated:YES completion:nil];

}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (IOS_VERSION >= 7.0) {
        
        
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:193.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:1.0]];
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:193.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:1.0]];
        [navigationController.navigationBar setTranslucent:NO];
        [navigationController.navigationBar setTintColor:[UIColor whiteColor]];
       
    } else {
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [navigationController.navigationBar setTintColor:[UIColor colorWithRed:193.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:1.0]];
        
    }
}

@end

