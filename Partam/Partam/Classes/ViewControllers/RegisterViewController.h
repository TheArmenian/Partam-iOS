//
//  RegisterViewController.h
//  Partam
//
//  Created by Sargis Gevorgyan on 2/27/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UITextFieldDelegate> {
    
    IBOutlet UIImageView *bgRegisterView;
    IBOutlet UIView *loadingView;
    
    IBOutlet UIButton *btnHideKeyBoards;
    IBOutlet UIButton *btnHideKeyBoard;

    IBOutlet UITextField *txtRegPassword;
    IBOutlet UITextField *txtRegConfimPassword;
    IBOutlet UITextField *txtRegName;
    IBOutlet UITextField *txtRegEmail;
}

- (IBAction)btnRegisterPressed:(id)sender;
- (IBAction)btnBackPressed:(id)sender;
- (IBAction)btnHideKeyBoardsPressed:(id)sender;

@end
