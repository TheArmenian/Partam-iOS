//
//  PlayerImage.m
//  WordStreak
//
//  Created by Asatur Galstyan on 12/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebImage.h"


@implementation WebImage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityIndicator.hidesWhenStopped = YES;
    [self.activityIndicator startAnimating];
    self.activityIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    [self addSubview:self.activityIndicator];
    return self;
}

-(id)init {
    self = [super init];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityIndicator.hidesWhenStopped = YES;
    [self.activityIndicator startAnimating];
    self.activityIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    [self addSubview:self.activityIndicator];
    return self;
}

- (id)initWithFrame:(CGRect)frame imageURL:(NSString*)url {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        imageURL = url;
        imgName = [url stringByReplacingOccurrencesOfString:@"/" withString:@""];
        imgName = [imgName stringByAppendingString:@".png"];
        imgName = [imgName stringByReplacingOccurrencesOfString:@"/" withString:@""];
//        self.image = [UIImage imageNamed:@"defaultProfileImage.png"];
        self.backgroundColor = bgWebImageColor;
        [self.layer setMasksToBounds:YES];

        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.activityIndicator.hidesWhenStopped = YES;
        [self.activityIndicator startAnimating];
        self.activityIndicator.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        
        [self addSubview:self.activityIndicator];

        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *img = [self loadImage:imgName];
            if (img) {
                
                self.image = img;
                [self hideActivityIndicator];
            } else {
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self getImage];
                });
            }
        });
    }
    return self;
}

-(void)imageURL:(NSString*)url {
    imageURL = url;
    imgName = [url stringByReplacingOccurrencesOfString:@"/" withString:@""];
    imgName = [imgName stringByAppendingString:@".png"];
    imgName = [imgName stringByReplacingOccurrencesOfString:@"/" withString:@""];
    //        self.image = [UIImage imageNamed:@"defaultProfileImage.png"];
    self.backgroundColor = bgWebImageColor;
    [self.layer setMasksToBounds:YES];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityIndicator.hidesWhenStopped = YES;
    [self.activityIndicator startAnimating];
    self.activityIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    [self addSubview:self.activityIndicator];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *img = [self loadImage:imgName];
        if (img) {
            
            self.image = img;
            
            [self hideActivityIndicator];
        } else {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self getImage];
            });
        }
    });
  
}


-(void)setImageURL:(NSString*)url completion:( void (^) (UIImage *image))handler {
    imageURL = url;
    imgName = [url stringByReplacingOccurrencesOfString:@"/" withString:@""];
    imgName = [imgName stringByAppendingString:@".png"];
    imgName = [imgName stringByReplacingOccurrencesOfString:@"/" withString:@""];
    //        self.image = [UIImage imageNamed:@"defaultProfileImage.png"];
    self.backgroundColor = bgWebImageColor;
    [self.layer setMasksToBounds:YES];
    
    [self showActivtyIndicator];
    [self sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil options:SDWebImageContinueInBackground completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.alpha = 0;
        self.image = image;
        handler(self.image);
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1;
        }];
        [self hideActivityIndicator];
    }
     ];
    return;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *img = [self loadImage:imgName];
        if (img) {
            
            self.image = img;
            
        } else {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSHTTPURLResponse* response;
                
                imageURL = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageURL]
                                                                       cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
                
                NSError * error = 0;
                NSData* data  = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error ];
                if (data) {
                    
                    UIImage *img = [UIImage imageWithData:data];
                    [self hideActivityIndicator];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.alpha = 0;
                        self.image = img;
                        handler(self.image);
                        [UIView animateWithDuration:0.3 animations:^{
                            self.alpha = 1;
                        }];
                        
                    });
                    
                    [self saveImage:UIImagePNGRepresentation(img) withFileName:imgName];
                    
                } else {
                    self.backgroundColor = [UIColor clearColor];
                    handler(self.image);
                }

            });
        }
    });
 
    
}
- (void) getImage {
    
    NSHTTPURLResponse* response;
    
    imageURL = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageURL]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    
    NSError * error = 0;
    NSData* data  = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error ];
    if (data) {
        
        UIImage *img = [UIImage imageWithData:data];
        [self hideActivityIndicator];
       
        dispatch_async(dispatch_get_main_queue(), ^{
            self.alpha = 0;
            self.image = img;
            [UIView animateWithDuration:0.3 animations:^{
                self.alpha = 1;
            }];
            
        });
        
        [self saveImage:UIImagePNGRepresentation(img) withFileName:imgName];
        
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
    
}

-(UIImage *) loadImage:(NSString *)fileName
{
    NSString * tmpDirectoryPath = NSTemporaryDirectory();
    
    NSData * data = [NSData dataWithContentsOfFile:[tmpDirectoryPath stringByAppendingPathComponent:fileName] ];
    if (data)
    {
        return [UIImage imageWithData:data];
        [self hideActivityIndicator];
    }
    return  nil;
}

-(void) saveImage:(NSData *)data withFileName:(NSString *)imageName
{
    NSString * tmpDirectoryPath = NSTemporaryDirectory();
    [data writeToFile:[tmpDirectoryPath stringByAppendingPathComponent:imageName] atomically:YES];
    [self.delegate imageSaved:data];
}

-(void)showActivtyIndicator {
    self.activityIndicator.hidden = NO;
    [self addSubview:self.activityIndicator];
}

- (void)hideActivityIndicator {
    self.activityIndicator.hidden = YES;
    [self.activityIndicator removeFromSuperview];
}

+ (UIImage*)imageByScalingAndCropping:(UIImage*)image forSize:(CGSize)targetSize {
    
    UIImage *newImg = image;
    UIImage *tempImage = nil;
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectMake(0, 0, 0, 0);
    thumbnailRect.origin = CGPointMake(0.0,0.0);
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    
    [newImg drawInRect:thumbnailRect];
    
    tempImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tempImage;
    /*
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        //        if (widthFactor > heightFactor)
        //            scaleFactor = widthFactor; // scale to fit height
        //        else
        //            scaleFactor = heightFactor; // scale to fit width
        //
        
        scaleFactor = MAX(widthFactor, heightFactor);
        
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) {
        NSLog(@"could not scale image");
        return image;
    }
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;*/
}

@end
