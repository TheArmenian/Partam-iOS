//
//  CustomPointAnnotation.h
//  Partam
//
//  Created by Sargis Gevorgyan on 3/17/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CustomPointAnnotation : MKPointAnnotation {
    
}
@property(nonatomic,assign)NSInteger tag;
@property(nonatomic,assign)BOOL isAddNewPoint;
@property(nonatomic,strong)NSDictionary* pointInfo;
@end
