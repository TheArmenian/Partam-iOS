//
//  GridView.h
//  Partam
//
//  Created by Sargis Gevorgyan on 2/25/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridView : UIView {
    UILabel * lblComment;
    UILabel * lblCity;
    UILabel * lblName;
    
    UIImageView * bgComment;
    UIImageView * bgCity;
    WebImage * bgImageView;
}

- (id)initWithFrame:(CGRect)frame pointInfo:(NSDictionary*)info;

@end
