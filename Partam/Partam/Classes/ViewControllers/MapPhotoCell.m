//
//  MapPhotoCell.m
//  Partam
//
//  Created by Sargis_Gevorgyan on 12.09.14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import "MapPhotoCell.h"

@interface MapPhotoCell () {
    
    __weak IBOutlet UIButton *btnDelete;
    __weak IBOutlet UIImageView *imgMain;
}

@end

@implementation MapPhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    CALayer * l = [imgMain layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:5.0];
}

-(void)prepareForReuse {
    [super prepareForReuse];
    imgMain.image = nil;
}

-(void)setPhotoInfo:(UIImage*)image indexPath:(NSIndexPath*)indexPath {
    CGRect cropFrame = CGRectMake(0, 0, imgMain.frame.size.width, imgMain.frame.size.height);
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
    imgMain.image = coverImg;
    btnDelete.tag = indexPath.row;
    
}

@end
