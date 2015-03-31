//
//  LoginViewController.h
//  Partam
//
//  Created by Sargis Gevorgyan on 2/24/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterViewController.h"
#import <FacebookSDK/FacebookSDK.h>


@interface LoginViewController : UIViewController<UITextFieldDelegate,WebImageDelegate> {
    
    IBOutlet UIView *viewFBLogin;
    IBOutlet UIView *viewSignIn;
    IBOutlet UIView *signButtonsView;
    IBOutlet UIView *viewForgottPass;
    IBOutlet UIView *loadingVIew;
    
    IBOutlet UIButton *btnViaFB;
    IBOutlet UIButton *btnSIgnIn;
    IBOutlet UIButton *btnForgotPass;
    IBOutlet UIButton *btnContinue;
    IBOutlet UIButton *btnHideKeyBoards;
    IBOutlet UIButton *btnHideKeyBoard;
    IBOutlet UIButton *btnHideKeyBoardInForgottPass;
    IBOutlet UIButton *btnHideKeyBoardFPass;

    
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtPassWord;
    IBOutlet UITextField *txtForgottEmal;
    
    
    IBOutlet UIImageView *bgLoginView;
    IBOutlet UIImageView *bgSignIn;
    IBOutlet UIImageView *bgFbLogin;
    IBOutlet UIImageView *bgRegisterView;
    
    __weak IBOutlet UIImageView *userImg;
}

@property(nonatomic,assign)BOOL isFavorites;

- (IBAction)btnFBContinuePressed:(id)sender;
- (IBAction)btnViaFBPressed:(id)sender;
- (IBAction)btnForgottPassPressed:(id)sender;
- (IBAction)btnSignInSelect:(id)sender;
- (IBAction)btnSignInPressed:(id)sender;
- (IBAction)btnRegisterPressed:(id)sender;
- (IBAction)btnHideKeyBoardsPressed:(id)sender;
- (IBAction)btnSendForgottEmailPressed:(id)sender;
- (IBAction)btnBackPressed:(id)sender;

@end
