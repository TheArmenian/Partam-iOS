//
//  GridView.m
//  Partam
//
//  Created by Sargis Gevorgyan on 2/25/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import "GridView.h"

@implementation GridView

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
        bgImageView = [[WebImage alloc]initWithFrame:self.frame];
        bgImageView.image = [UIImage imageNamed:@"mainDefaultProfileImage.png"];
        [self addSubview:bgImageView];
        self.backgroundColor =[UIColor darkGrayColor];
//        [self performSelector:@selector(setInfo:) withObject:info];
//        [bgImageView imageURL:[info valueForKey:@"picture"]];
        __weak WebImage * imgWeb = bgImageView;
        [imgWeb setImageURL:[info valueForKey:@"picture"] completion:^(UIImage *image) {
            [imgWeb setImage:image];
        }];
        UIImageView * bgTop =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 71)];
        bgTop.image = [UIImage imageNamed:@"bgTopGridView"];
        if ([[info valueForKey:@"promoted"] integerValue] == 1) {
            [self addSubview:bgTop];
        }
        
        lblComment = [[UILabel alloc]init];
        bgComment = [[UIImageView alloc]initWithFrame:CGRectMake(250, 15, 55, 28)];
        if ([[info valueForKey:@"comment_count"] integerValue] == 0) {
            bgComment.image = [UIImage imageNamed:@"bgCommentEmpty.png"];
        } else {
            bgComment.image = [UIImage imageNamed:@"bgComment.png"];
        }
        lblComment.frame = CGRectMake(25, 0, 30, 28);
        if (![[info valueForKey:@"comment_count"] isKindOfClass:[NSNull class]]) {
            lblComment.text = [NSString stringWithFormat:@"%d",[[info valueForKey:@"comment_count"] integerValue]];
        } else {
            lblComment.text = @"";
        }
        
        lblComment.backgroundColor = [UIColor clearColor];
        lblComment.textColor = [UIColor whiteColor];
        lblComment.textAlignment = NSTextAlignmentCenter;
        [bgComment addSubview:lblComment];
        [self addSubview:bgComment];
        
        bgCity = [[UIImageView alloc]initWithFrame:CGRectMake(-1, 247, 321, 74)];
        bgCity.image = [UIImage imageNamed:@"bgCityLabel"];
        [self addSubview:bgCity];
        
        lblName = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, 316, 50)];
        if (![[info valueForKey:@"name"] isKindOfClass:[NSNull class]]) {
            lblName.text = [info valueForKey:@"name"];
        } else {
            lblName.text = @"";
        }
        
        lblName.textColor = [UIColor whiteColor];
        lblName.textAlignment = NSTextAlignmentCenter;
        lblName.font = [UIFont boldSystemFontOfSize:18.0];
        lblName.numberOfLines = 0;
        lblName.backgroundColor = [UIColor clearColor];
        [bgCity addSubview:lblName];
        
        lblCity = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, 320, 24)];
        if (![[info valueForKey:@"city"] isKindOfClass:[NSNull class]]) {
            lblCity.text = [info valueForKey:@"city"];
        } else {
            lblCity.text = @"";
        }
        
        lblCity.textColor = [UIColor whiteColor];
        lblCity.textAlignment = NSTextAlignmentCenter;
        lblCity.font = [UIFont boldSystemFontOfSize:10.0];
        lblCity.numberOfLines = 0;
        lblCity.backgroundColor = [UIColor clearColor];
        [bgCity addSubview:lblCity];
        
}
    return self;
}

-(void)setInfo:(NSDictionary*)info {
    
}

@end
