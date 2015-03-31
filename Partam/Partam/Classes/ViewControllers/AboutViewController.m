//
//  AboutViewController.m
//  Partam
//
//  Created by Sargis Gevorgyan on 2/27/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    if ([AppManager sharedInstance].isiPhone5) {
        [bgImage setImage:[UIImage imageNamed:@"bgAbout-568h@2x"]];
    }
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
