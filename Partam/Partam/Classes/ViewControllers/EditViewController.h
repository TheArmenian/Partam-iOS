//
//  EditViewController.h
//  Partam
//
//  Created by Sargis Gevorgyan on 3/7/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MMDrawerController.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "WebImage.h"

@interface EditViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate> {
    UIBarButtonItem *rightBarButton;
    UIButton * rightButton;

    IBOutlet UIScrollView *mainScrollView;
    
    IBOutlet UITextField *txtFirstName;
    IBOutlet UITextField *txtLastName;
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtNewPass;
    IBOutlet UITextField *txtRepeatPass;
    IBOutlet UITextField *txtLocation;
    
    IBOutlet UIImageView *userImg;
    WebImage *userImage;
    
    UIImagePickerController *imagePicker;
    UIImagePickerController *cameraPicker;
    UIPopoverController *imagePickerPopover;
    
    NSDictionary * userInfo;
    
    IBOutlet UIView *loadingView;
    IBOutlet UIButton *btnHideKeyBoard;
    
    BOOL status;
}
- (IBAction)btnConnectFBPressed:(id)sender;
- (IBAction)btnLogOutPressed:(id)sender;
- (IBAction)btnChoosImagePressed:(id)sender;
- (IBAction)btnHideKeyBoardPressed:(id)sender;


@end
