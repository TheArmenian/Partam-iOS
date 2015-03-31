//
//  WebServiceManage.h
//  ShiftList
//
//  Created by Asatur Galstyan on 4/24/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServiceManager : NSObject

#pragma mark - Products
+ (void)loadPointInfo:(int)count :(int)limit completion:( void (^) (id response, NSError *error))handler;
+ (void)loadPointByCategory:(NSString*)categories limit:(int)limit completion:( void (^) (id response, NSError *error))handler;
+ (void)loadPointByCity_latitude:(NSString*)lats longitude:(NSString*)longs limit:(int)limit offSet:(int)offSet completion:( void (^) (id response, NSError *error))handler;
+ (void)loadPointByCategoriesAndCity:(NSString*)categories latitude:(NSString*)lats longitude:(NSString*)longs limit:(int)limit offSet:(int)offSet completion:( void (^) (id response, NSError *error))handler;
+(void)loadSearchPoints :(NSString*) searchTxt completion:( void (^) (id response, NSError *error))handler;
+(void)add_new_point_name:(NSString*)name tags:(NSString*)tags category:(NSString*)category lng:(NSString*)lng lat:(NSString*)lat city:(NSString*)city state:(NSString*)state address:(NSString*)address zip:(NSString*)zip email:(NSString*)email weburl:(NSString*)weburl description:(NSString*)description paypal:(NSString*)paypal photos:(NSArray*)photos completion:(void(^)(id response, NSError *error))handler;

+ (void)addSelfie:(UIImage*)image point:(NSString*)pointId completion:(void(^)(id response, NSError *error))handler;
+ (void)checkinsForPoint:(NSString*)pointId completion:(void(^)(id response, NSError *error))handler;
+ (void)deleteCheckin:(NSString *)checkinId completion:(void(^)(id response, NSError *error))handler;
@end
