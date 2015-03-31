//
//  FavoritesView.m
//  Partam
//
//  Created by Sargis Gevorgyan on 3/6/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import "FavoritesView.h"

@implementation FavoritesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame pointInfo:(NSDictionary*)info {
    self = [super initWithFrame:frame];
    if (self) {
        pointView = [[WebImage alloc]initWithFrame:CGRectMake(3, 5, 93, 93)];
        pointView.image = [UIImage imageNamed:@"defaultProfileImage.png"];
        [self addSubview:pointView];
        
        __weak  WebImage * imgWeb = pointView;
        [imgWeb setImageURL:[info valueForKey:@"picture"] completion:^(UIImage *image) {
            imgWeb.image = image;
        }];
        UILabel* lblName = [[UILabel alloc]initWithFrame:CGRectMake(99, 0, 230, 40)];
        lblName.text = [info valueForKey:@"name"];
        lblName.textColor = [UIColor blackColor];
        lblName.textAlignment = NSTextAlignmentLeft;
        lblName.font = [UIFont boldSystemFontOfSize:14.0];
        lblName.numberOfLines = 0;
        lblName.backgroundColor = [UIColor clearColor];
        [self addSubview:lblName];
        
        UIImageView * memorial = [[UIImageView alloc]initWithFrame:CGRectMake(99, 50, 11, 8)];
        [memorial setImage:[UIImage imageNamed:@"memorial.png"]];
        [self addSubview:memorial];
        
        UILabel* lblCategory = [[UILabel alloc]initWithFrame:CGRectMake(115, 40, 210, 25)];
        lblCategory.text = [[info valueForKey:@"category"] valueForKey:@"title"];
        lblCategory.textColor = [UIColor colorWithRed:44.0/255.0 green:153.0/255.0 blue:215.0/255.0 alpha:1];
        lblCategory.textAlignment = NSTextAlignmentLeft;
        lblCategory.font = [UIFont boldSystemFontOfSize:10.0];
        lblCategory.numberOfLines = 0;
        lblCategory.backgroundColor = [UIColor clearColor];
        [self addSubview:lblCategory];
        
        UIImageView * bluePin = [[UIImageView alloc]initWithFrame:CGRectMake(99, 70, 14, 17)];
        [bluePin setImage:[UIImage imageNamed:@"blue_pin.png"]];
        [self addSubview:bluePin];
        
        UILabel* lblAdress = [[UILabel alloc]initWithFrame:CGRectMake(115, 65, 210, 25)];
        lblAdress.text = [info valueForKey:@"address"];
        lblAdress.textColor = [UIColor colorWithRed:44.0/255.0 green:153.0/255.0 blue:215.0/255.0 alpha:1];
        lblAdress.textAlignment = NSTextAlignmentLeft;
        lblAdress.font = [UIFont boldSystemFontOfSize:10.0];
        lblAdress.numberOfLines = 0;
        lblAdress.backgroundColor = [UIColor clearColor];
        [self addSubview:lblAdress];
    }
    return self;
 
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
