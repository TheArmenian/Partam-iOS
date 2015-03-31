//
//  LoginViewController.m
//  Partam
//
//  Created by Sargis Gevorgyan on 2/24/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    loadingVIew.hidden = YES;
    loadingVIew.layer.cornerRadius = 10;
    [self btnHideKeyBoardsPressed:nil];
    if (IOS_VERSION >= 7.0) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        
    }
    //    else {
    //       [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
    //    }
    
    
    txtEmail.delegate = self;
    txtPassWord.delegate = self;
    [self performSelector:@selector(settingsView) withObject:nil afterDelay:0.0];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
   
}


-(void)settingsView {
    if ([AppManager sharedInstance].isiPhone5) {
        [bgLoginView setImage:[UIImage imageNamed:@"bgLogin-568h@2x"]];
        [bgSignIn setImage:[UIImage imageNamed:@"bgSignIn-568h@2x"]];
        [bgFbLogin setImage:[UIImage imageNamed:@"bgFBLogin-568h@2x"]];
        [bgRegisterView setImage:[UIImage imageNamed:@"bgRegisterView-568h@2x"]];
        btnContinue.frame = CGRectMake(btnContinue.frame.origin.x, btnContinue.frame.origin.y + 40, btnContinue.frame.size.width, btnContinue.frame.size.height);
        bgFbLogin.frame = CGRectMake(bgFbLogin.frame.origin.x, bgFbLogin.frame.origin.y, bgFbLogin.frame.size.width, 288);
        bgSignIn.frame = CGRectMake(bgSignIn.frame.origin.x, bgSignIn.frame.origin.y, bgSignIn.frame.size.width, 313);
        signButtonsView.frame = CGRectMake(signButtonsView.frame.origin.x, signButtonsView.frame.origin.y + 38, signButtonsView.frame.size.width, signButtonsView.frame.size.height);
        btnForgotPass.frame = CGRectMake(btnForgotPass.frame.origin.x, btnForgotPass.frame.origin.y + 20, btnForgotPass.frame.size.width, btnForgotPass.frame.size.height);
        txtEmail.frame = CGRectMake(txtEmail.frame.origin.x, txtEmail.frame.origin.y - 8, txtEmail.frame.size.width, txtEmail.frame.size.height);
    }
    viewFBLogin.center = CGPointMake(self.view.center.x, self.view.frame.size.height+self.view.center.y);
    viewSignIn.center = CGPointMake(self.view.center.x, self.view.frame.size.height+self.view.center.y);
    viewForgottPass.center = CGPointMake(self.view.center.x, self.view.frame.size.height+self.view.center.y);
}

- (IBAction)btnFBContinuePressed:(id)sender {
    loadingVIew.hidden = NO;
    
    if ([[FBSession activeSession] isOpen]) {
        FBRequest *meRequest = [FBRequest requestForMe];
        [meRequest.parameters setValue:@"id,name,last_name,email,first_name,picture" forKey:@"fields"];
        
        [meRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            NSLog(@"user %@", result);
            if (error) {
                loadingVIew.hidden = YES;
            } else  {
            [self performSelector:@selector(sendFBLoginRequest:) withObject:result afterDelay:0];
            }
        }];
    } else {
        [FBSession openActiveSessionWithReadPermissions:@[@"email"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            if (error) {
                UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"Partam" message:@"Sorry, unable to login via Facebook." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                loadingVIew.hidden = YES;
            } else  {
                FBRequest *meRequest = [FBRequest requestForMe];
                [meRequest.parameters setValue:@"id,name,last_name,email,first_name,picture" forKey:@"fields"];
                
                [meRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    NSLog(@"user %@", result);
                    if (!error) {
                      [self performSelector:@selector(sendFBLoginRequest:) withObject:result afterDelay:0];  
                    }
                    
                }];
                
            }
        }];
    }
}

-(void)sendFBLoginRequest:(NSDictionary*)user {
    
    NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
    NSString *postString = [NSString stringWithFormat:@"user[token]=%@",fbAccessToken];
    NSString* url = [NSString stringWithFormat:@"%@/user/login", [AppManager sharedInstance].apiURL];
    NSData* postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error = 0;
    NSHTTPURLResponse* response;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    [request setHTTPMethod:@"PUT"];
    
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"ERROR!" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
        loadingVIew.hidden = YES;
        return;
    }
    NSDictionary* regInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (![[regInfo valueForKey:@"token"] isKindOfClass:[NSString class]]) {
        [self sendFBRegisterRequest:user];
    } else {
        [AppManager sharedInstance].token = [regInfo valueForKey:@"token"];
        [[AppManager sharedInstance] loadUserInfo];
        [AppManager sharedInstance].isLogOut = NO;
        [[AppManager sharedInstance] saveSettings];
        [self.navigationController popViewControllerAnimated:YES];
        loadingVIew.hidden = YES;
    }
    
}

-(void)sendFBRegisterRequest:(NSDictionary*)user {
    
    NSString* url = [NSString stringWithFormat:@"%@/user/register", [AppManager sharedInstance].apiURL];
    NSError *error;
    NSString * passWord = [self genRandPass:6];
    NSString *postString = [NSString stringWithFormat:@"fos_user_registration_form[email]=%@&fos_user_registration_form[plainPassword]=%@&fos_user_registration_form[displayName]=%@&fos_user_registration_form[facebookId]=%@",[user valueForKey:@"email"],passWord,[user valueForKey:@"name"],[user valueForKey:@"id"]];
    
    
    NSData* postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSHTTPURLResponse* response;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    [request setHTTPMethod:@"PUT"];
    
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"ERROR!" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
        loadingVIew.hidden = YES;
        return;
    }
    NSDictionary* regInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (![[regInfo valueForKey:@"token"] isKindOfClass:[NSString class]]) {
        
    } else {
        
        [AppManager sharedInstance].token = [regInfo valueForKey:@"token"];
        
        [AppManager sharedInstance].isLogOut = NO;
        
        NSString * imgUrl =[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?redirect=1&height=200&type=normal&width=200", [user valueForKey:@"id"]];
        WebImage * img = [[WebImage alloc]initWithFrame:CGRectMake(0, 0, 100, 100) imageURL:imgUrl];
        __weak WebImage * userFBImg = img;
        [userFBImg setImageURL:imgUrl completion:^(UIImage *image) {
            CGRect cropFrame = CGRectMake(0, 0, userFBImg.frame.size.width, userFBImg.frame.size.height);
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
            userFBImg.image = coverImg;
        }];
        userFBImg.activityIndicator.hidden = YES;
        userFBImg.delegate = self;
    }
    
}

- (IBAction)btnViaFBPressed:(id)sender {
    if (btnViaFB.selected) {
        btnViaFB.selected = NO;
        [UIView animateWithDuration:0.5 animations:^{
            viewFBLogin.center = CGPointMake(self.view.center.x, self.view.frame.size.height+self.view.center.y);
        }];
        return;
    }
    btnViaFB.selected = YES;
    btnSIgnIn.selected = NO;
    [UIView animateWithDuration:0.5 animations:^{
        viewFBLogin.center = CGPointMake(self.view.center.x, (240-(IOS_VERSION >= 7.0?0:20)));
        viewSignIn.center = CGPointMake(self.view.center.x, self.view.frame.size.height+self.view.center.y);
    }];
}



- (IBAction)btnForgottPassPressed:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        viewForgottPass.center = CGPointMake(self.view.center.x, [AppManager sharedInstance].isiPhone5?243:(240-(IOS_VERSION >= 7.0?0:20)));
        viewSignIn.center = CGPointMake(self.view.center.x, self.view.frame.size.height+self.view.center.y);
    }];
    
}

- (IBAction)btnSignInSelect:(id)sender {
    if (txtPassWord.text.length < 4 || [txtEmail.text isEqual:@""] ) {
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
    
    [self btnHideKeyBoardsPressed:nil];
    loadingVIew.hidden = NO;
    [self performSelector:@selector(sendLoginRequest) withObject:nil afterDelay:0];
}

-(void)sendLoginRequest {
    NSString* url = [NSString stringWithFormat:@"%@/user/login", [AppManager sharedInstance].apiURL];
    
    NSString *postString = [NSString stringWithFormat:@"user[email]=%@&user[password]=%@",txtEmail.text, txtPassWord.text];
    
    
    NSData* postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error = 0;
    NSHTTPURLResponse* response;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    [request setHTTPMethod:@"PUT"];
    
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"ERROR!" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
        loadingVIew.hidden = YES;
        return;
    }
    NSDictionary* regInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (![[regInfo valueForKey:@"token"] isKindOfClass:[NSString class]]) {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"ERROR!" message:@"Invalid username or password" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
    } else {
        [AppManager sharedInstance].token = [regInfo valueForKey:@"token"];
        [[AppManager sharedInstance] loadUserInfo];
        [AppManager sharedInstance].isLogOut = NO;
        [[AppManager sharedInstance] saveSettings];
        [self.navigationController popViewControllerAnimated:YES];
    }
    loadingVIew.hidden = YES;
}

- (IBAction)btnSignInPressed:(id)sender {
    if (btnSIgnIn.selected) {
        btnSIgnIn.selected = NO;
        [UIView animateWithDuration:0.5 animations:^{
            viewSignIn.center = CGPointMake(self.view.center.x, self.view.frame.size.height+self.view.center.y );
            viewForgottPass.center = CGPointMake(self.view.center.x, self.view.frame.size.height+self.view.center.y);
        }];
        return;
    }
    btnViaFB.selected = NO;
    btnSIgnIn.selected = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        viewSignIn.center = CGPointMake(self.view.center.x, [AppManager sharedInstance].isiPhone5?243:(240-(IOS_VERSION >= 7.0?0:20)));
        viewFBLogin.center = CGPointMake(self.view.center.x, self.view.frame.size.height+self.view.center.y);
    }];
}

- (IBAction)btnRegisterPressed:(id)sender {
    btnViaFB.selected = NO;
    btnSIgnIn.selected = NO;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegisterViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
    [UIView animateWithDuration:0.5 animations:^{
        viewFBLogin.center = CGPointMake(self.view.center.x, self.view.frame.size.height+self.view.center.y);
        viewSignIn.center = CGPointMake(self.view.center.x, self.view.frame.size.height+self.view.center.y);
    }];
}

- (IBAction)btnHideKeyBoardsPressed:(id)sender {
    btnHideKeyBoards.hidden = YES;
    btnHideKeyBoard.hidden = YES;
    btnHideKeyBoardFPass.hidden = YES;
    btnHideKeyBoardInForgottPass.hidden = YES;
    [txtEmail resignFirstResponder];
    [txtPassWord resignFirstResponder];
    [txtForgottEmal resignFirstResponder];
    
}

- (IBAction)btnSendForgottEmailPressed:(id)sender {
    if ([txtForgottEmal.text isEqual:@""] ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"Your information is incomplete"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if ((![txtForgottEmal.text isEqualToString:@""] && txtForgottEmal.text != nil)) {
        if (![[AppManager sharedInstance] validateEmail:txtForgottEmal.text]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                            message:@"Your email address is not valid"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            return;
        }
    }
    loadingVIew.hidden = NO;
    [txtForgottEmal resignFirstResponder];
    [self performSelector:@selector(sendForgottPassRequest) withObject:nil afterDelay:0];
}

- (IBAction)btnBackPressed:(id)sender {
    if (self.isFavorites) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)sendForgottPassRequest {
    NSString* url = [NSString stringWithFormat:@"%@/users/resets", [AppManager sharedInstance].apiURL];
    
    NSString *postString = [NSString stringWithFormat:@"user[email]=%@",txtForgottEmal.text];
    
    
    NSData* postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error = 0;
    NSHTTPURLResponse* response;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    [request setHTTPMethod:@"POST"];
    
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"ERROR!" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
        loadingVIew.hidden = YES;
        return;
    }
    NSDictionary* regInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ([[regInfo valueForKey:@"success"] integerValue] == 1) {
    }
    
    [AppManager sharedInstance].token = nil;
    [AppManager sharedInstance].isLogOut = YES;
    [[AppManager sharedInstance] saveSettings];
    [self.navigationController popViewControllerAnimated:YES];
    
    loadingVIew.hidden = YES;
}



-(NSString *) genRandPass: (int) len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}

#pragma mark UITextFieldDelegate methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    btnHideKeyBoards.hidden = NO;
    btnHideKeyBoard.hidden = NO;
    btnHideKeyBoardFPass.hidden = NO;
    btnHideKeyBoardInForgottPass.hidden = NO;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    btnHideKeyBoards.hidden = YES;
    btnHideKeyBoard.hidden = YES;
    btnHideKeyBoardFPass.hidden = YES;
    btnHideKeyBoardInForgottPass.hidden = YES;
    [textField resignFirstResponder];
    
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark WebImageDelegate method

-(void)imageSaved:(NSData *)imgData {
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"user[file]\"; filename=userAvatar.png" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type:image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imgData]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [[AppManager sharedInstance] changeUserAvatar:body];
    [[AppManager sharedInstance] loadUserInfo];
    [[AppManager sharedInstance] saveSettings];
    loadingVIew.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
