//
//  CheckinCell.m
//  Partam
//
//  Created by Asatur Galstyan on 1/20/15.
//  Copyright (c) 2015 Zanazan Systems. All rights reserved.
//

#import "CheckinCell.h"

@interface CheckinCell() {
    
    __weak IBOutlet UIView *mainView;
    __weak IBOutlet UIImageView *imgSelfie;
    __weak IBOutlet UIImageView *imgUser;
    __weak IBOutlet UILabel *lblName;
    __weak IBOutlet UIView *dateView;
    __weak IBOutlet UILabel *lblDate;
    __weak IBOutlet UIButton *btnDelete;
}

@end

@implementation CheckinCell

- (void)prepareForReuse {

    lblName.text = nil;
    imgSelfie.image = nil;
    imgUser.image = nil;
}

- (void)awakeFromNib {
    
    mainView.layer.cornerRadius = 10;
    mainView.clipsToBounds = YES;
    
    imgUser.layer.cornerRadius = imgUser.frame.size.width/2;
    imgUser.clipsToBounds = YES;
    
    dateView.layer.cornerRadius = 7;
}

-(void)setInfo:(NSDictionary*)info {

    [imgSelfie sd_setImageWithURL:[NSURL URLWithString:info[@"image"]] placeholderImage:[UIImage imageNamed:@"defaultProfileImage"]];
    
    NSDictionary *user = info[@"user"];
    [imgUser sd_setImageWithURL:[NSURL URLWithString:user[@"picture"]] placeholderImage:[UIImage imageNamed:@"defaultProfileImage"]];
    lblName.text = user[@"displayname"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormat setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ'"];
    NSDate *date = [dateFormat dateFromString:info[@"created"]];
    [dateFormat setDateFormat:@"MMM dd"];
    lblDate.text =[dateFormat stringFromDate:date];
    
    btnDelete.hidden = YES;
    if ([AppManager sharedInstance].userInfo) {
        NSString* userID = [[AppManager sharedInstance].userInfo[@"user"][@"id"] stringValue];

        if ([[user[@"id"] stringValue] isEqualToString:userID]) {
            btnDelete.hidden = NO;
        }
        
    }
    
    
    
}

- (IBAction)btnDeteleTap:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(deleteCheckinAtIndex:)]) {
        [self.delegate deleteCheckinAtIndex:self.tag];
    }
}

@end
