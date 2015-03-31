//
//  PlayerImage.h
//  WordStreak
//
//  Created by Asatur Galstyan on 12/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppManager.h"
#import <QuartzCore/QuartzCore.h>

@protocol WebImageDelegate <NSObject>

-(void)imageSaved:(NSData *)imgData;

@end

@interface WebImage : UIImageView {
    NSString *imageURL;
    NSString *imgName;
    
    //UIActivityIndicatorView *activityIndicator;
}
@property(nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property(nonatomic,assign) id<WebImageDelegate> delegate;

- (id)initWithFrame:(CGRect)frame imageURL:(NSString*)url;
-(void)imageURL:(NSString*)url;
-(void)setImageURL:(NSString*)url completion:( void (^) (UIImage *image))handler;
- (void)hideActivityIndicator;

+ (UIImage*)imageByScalingAndCropping:(UIImage*)image forSize:(CGSize)targetSize;
@end
