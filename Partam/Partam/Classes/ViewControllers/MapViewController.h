//
//  MapViewController.h
//  Partam
//
//  Created by Sargis_Gevorgyan on 12.09.14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController

@property(nonatomic,strong)NSArray * webInfoArray;
- (IBAction)btnHideNewAnnotationViewPressed:(id)sender;
- (IBAction)btnNextPressed:(id)sender;
- (IBAction)btnAddNewPhotoPressed:(id)sender;
- (IBAction)btnDeletePhotoPressed:(id)sender;
- (IBAction)btnHideKeyBoardPressed:(id)sender;
- (IBAction)btnCategoryPressed:(id)sender;
@end
