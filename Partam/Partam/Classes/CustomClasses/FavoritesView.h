//
//  FavoritesView.h
//  Partam
//
//  Created by Sargis Gevorgyan on 3/6/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritesView : UIView {
    WebImage * pointView;
    
}
- (id)initWithFrame:(CGRect)frame pointInfo:(NSDictionary*)info;
@end
