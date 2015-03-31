//
//  CheckinCell.h
//  Partam
//
//  Created by Asatur Galstyan on 1/20/15.
//  Copyright (c) 2015 Zanazan Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CheckinViewDelegate <NSObject>

@optional
- (void)deleteCheckinAtIndex:(NSInteger)index;

@end

@interface CheckinCell : UITableViewCell

@property (nonatomic, assign) id<CheckinViewDelegate> delegate;

-(void)setInfo:(NSDictionary*)info;

@end
