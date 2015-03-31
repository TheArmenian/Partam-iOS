//
//  RegisterViewController.m
//  Partam
//
//  Created by Sargis Gevorgyan on 2/27/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

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
    loadingView.hidden = YES;
    loadingView.layer.cornerRadius = 10;
    btnHideKeyBoards.hidden = YES;
    btnHideKeyBoard.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if ([AppManager sharedInstance].isiPhone5) {

        [bgRegisterView setImage:[UIImage imageNamed:@"bgRegisterView-568h@2x"]];
    }
	// Do any additional setup after loading the view.
}

- (IBAction)btnRegisterPressed:(id)sender {
    if (txtRegConfimPassword.text.length < 4 ||txtRegPassword.text.length < 4 || [txtRegEmail.text isEqual:@""] || [txtRegName.text isEqual:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"Your information is incomplete"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if ((![txtRegEmail.text isEqualToString:@""] && txtRegEmail.text != nil)) {
        if (![[AppManager sharedInstance] validateEmail:txtRegEmail.text]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                            message:@"Your email address is not valid"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            return;
        }
    }
    if (![txtRegConfimPassword.text isEqual:txtRegPassword.text]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"These passwords don't match."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
   
    loadingView.hidden = NO;
    [self btnHideKeyBoardsPressed:nil];
    [self performSelector:@selector(sendRegisterRequest) withObject:nil afterDelay:0];
}

-(void)sendRegisterRequest {
    
    NSString* url = [NSString stringWithFormat:@"%@/user/register", [AppManager sharedInstance].apiURL];
    
    NSString *postString = [NSString stringWithFormat:@"fos_user_registration_form[email]=%@&fos_user_registration_form[plainPassword]=%@&fos_user_registration_form[firstName]=&fos_user_registration_form[lastName]=&fos_user_registration_form[displayName]=%@",txtRegEmail.text, txtRegPassword.text,txtRegName.text];
    
    
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
        loadingView.hidden = YES;
        return;
    }
    NSDictionary* regInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ([[regInfo valueForKey:@"success"]integerValue] == 0) {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"ERROR!" message:@"The email is already used" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
    } else {
        [AppManager sharedInstance].token = [regInfo valueForKey:@"token"];
        [AppManager sharedInstance].isLogOut = NO;
        [[AppManager sharedInstance] loadUserInfo];
        [[AppManager sharedInstance] saveSettings];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
loadingView.hidden = YES;
}
    
- (IBAction)btnBackPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnHideKeyBoardsPressed:(id)sender {
    btnHideKeyBoards.hidden = YES;
    btnHideKeyBoard.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
    [txtRegName resignFirstResponder];
    [txtRegEmail resignFirstResponder];
    [txtRegPassword resignFirstResponder];
    [txtRegConfimPassword resignFirstResponder];
}

#pragma mark UITextFieldDelegate methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    btnHideKeyBoards.hidden = NO;
    btnHideKeyBoard.hidden = NO;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    int height = 0;
    if (textField.tag == 2) {
        height = -50;
    }
    if (textField.tag == 3) {
        height = -100;
    }if (textField.tag == 4) {
        height = -120;
    }
    if ([AppManager sharedInstance].isiPhone5) {
        height = 0;
        if (textField.tag == 3) {
            height = -100;
        }if (textField.tag == 4) {
            height = -100;
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, height, self.view.frame.size.width, self.view.frame.size.height);
    }];
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
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning
    {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

@end
