//
//  AppManager.h
//  Partam
//
//  Created by Sargis Gevorgyan on 2/24/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "WebImage.h"

@protocol AppManagerDelegate
-(void) upDateCompleted;
-(void)upDateFailed;
@end
@interface AppManager : NSObject {
    
}
+(AppManager*)sharedInstance;
@property(nonatomic,strong)id <AppManagerDelegate> delegate;
@property(nonatomic)BOOL isIpad;
@property(nonatomic)BOOL isiPhone5;
@property(nonatomic)BOOL isLogOut;
@property(nonatomic,strong)NSString * apiURL;
@property(nonatomic,strong)NSString * token;
@property(nonatomic,strong)NSDictionary* userInfo;
@property(nonatomic,strong)NSDictionary* userFavorites;
@property(nonatomic,strong)NSMutableArray* userLocalFavorites;
@property(nonatomic,strong)NSArray * allPoints;
@property(nonatomic,assign)BOOL isFilter;
@property(nonatomic,strong)NSArray * categoriesArray;
@property(nonatomic,strong)CLLocation * currentLocation;
- (void) loadSettings;
- (void) saveSettings;
//- (NSArray*) loadWebInfo:(int)count :(int)limit;
//- (NSArray*) loadPointByCategory:(NSString*)categories limit:(int)limit;
//- (NSArray*) loadPointByCity_latitude:(NSString*)lats longitude:(NSString*)longs limit:(int)limit offSet:(int)offSet;
//- (NSArray*) loadPointByCategoriesAndCity:(NSString*)categories latitude:(NSString*)lats longitude:(NSString*)longs limit:(int)limit offSet:(int)offSet;
- (NSArray*) loadCategoriesInfo :(NSString*) categories;
- (NSDictionary*) loadLocationsInfo :(NSString*) locations;
//- (NSArray*) loadSearchPoints :(NSString*) searchTxt;
- (NSDictionary*) loadDetailInfo :(int) detailID;
- (NSDictionary*) loadUserInfo;
- (NSDictionary*) changeUserInfo:(NSString*)format;
- (NSDictionary*) changeUserPass:(NSString*)format;
- (NSDictionary*) changeUserAvatar:(NSData*)format;
- (NSDictionary*) addComment:(NSString*)comment :(int)PointId;
- (NSDictionary*) loadUserFavorites;
- (NSDictionary*) addOrRemoveFavorites:(int)point method:(NSString*)method;
- (NSArray*) userLogout;
-(void)loadAllMapPoints;
- (BOOL) validateEmail:(NSString *)email;
+ (UIImage*)captureView:(UIView *)view;
-(UIImage*)getMapCategoryImage:(NSString*)title;

+(UIImage *)cropImage_cropFrame:(CGRect)cropFrame latestFrame:(CGRect)latestFrame originalImage:(UIImage*)originalImage;

+ (void)showMessageBox:(NSString*)message;
@end
