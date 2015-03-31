//
//  WebServiceManage.m
//  Listar
//
//  Created by Asatur Galstyan on 4/24/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import "WebServiceManager.h"

static  NSString *wsUrl = @"http://partam.partam.com/api/v1/";

@implementation WebServiceManager


#pragma mark - Points
+ (void)loadPointInfo:(int)count :(int)limit completion:( void (^) (id response, NSError *error))handler {
  
    NSString *method = [NSString stringWithFormat:@"mains/%d/limits/%d/offset", count,limit];
    NSString *params = @"";
    
    NSMutableURLRequest *request = [self requestForGetMethod:method withParams:params];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURLResponse* response = nil;
        NSError *error = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSArray* webInfo = [data objectFromJSONData];
        if (webInfo.count == 0) {
        } else {
            for (NSDictionary * currentInfo in webInfo) {
                WebImage *image = [[WebImage alloc] initWithFrame:CGRectMake(0, 0 , 320, 320)];
                __weak WebImage * webImage = image;
                [webImage setImageURL:[currentInfo valueForKey:@"picture"] completion:^(UIImage *image) {
                   
                }];
                
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            handler([data objectFromJSONData], error);
        });
        
    });
}

+ (void)loadPointByCategory:(NSString*)categories limit:(int)limit completion:( void (^) (id response, NSError *error))handler {
    NSString *method = [NSString stringWithFormat:@"mains/%@/points/%d/starts/10/limits/name/orders/asc/direction",categories,limit];
    NSString *params = @"";
    
    NSMutableURLRequest *request = [self requestForGetMethod:method withParams:params];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURLResponse* response = nil;
        NSError *error = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSArray* webInfo = [data objectFromJSONData];
        if (webInfo.count == 0) {
        } else {
            for (NSDictionary * currentInfo in webInfo) {
                WebImage *image = [[WebImage alloc] initWithFrame:CGRectMake(0, 0 , 320, 320)];
                __weak WebImage * webImage = image;
                [webImage setImageURL:[currentInfo valueForKey:@"picture"] completion:^(UIImage *image) {
                    
                }];
                image = nil;
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            handler([data objectFromJSONData], error);
        });
        
    });
  
}

+ (void)loadPointByCity_latitude:(NSString*)lats longitude:(NSString*)longs limit:(int)limit offSet:(int)offSet completion:( void (^) (id response, NSError *error))handler {
    NSString *method = [NSString stringWithFormat:@"mains/%@/lats/%@/longs/%d/limits/%d/offsets/50/distance", lats,longs,limit,offSet];
    NSString *params = @"";
    
    NSMutableURLRequest *request = [self requestForGetMethod:method withParams:params];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURLResponse* response = nil;
        NSError *error = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSArray* webInfo = [data objectFromJSONData];
        if (webInfo.count == 0) {
        } else {
            for (NSDictionary * currentInfo in webInfo) {
                WebImage *image = [[WebImage alloc] initWithFrame:CGRectMake(0, 0 , 320, 320)];
                __weak WebImage * webImage = image;
                [webImage setImageURL:[currentInfo valueForKey:@"picture"] completion:^(UIImage *image) {
                    
                }];
                image = nil;
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            handler([data objectFromJSONData], error);
        });
        
    });

}

+ (void)loadPointByCategoriesAndCity:(NSString*)categories latitude:(NSString*)lats longitude:(NSString*)longs limit:(int)limit offSet:(int)offSet completion:( void (^) (id response, NSError *error))handler {
    NSString *method = [NSString stringWithFormat:@"mains/%@/cats/%@/lats/%@/longs/%d/limits/%d/offsets/50/distance", categories,lats,longs,limit,offSet];
    NSString *params = @"";
    
    NSMutableURLRequest *request = [self requestForGetMethod:method withParams:params];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURLResponse* response = nil;
        NSError *error = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSArray* webInfo = [data objectFromJSONData];
        if (webInfo.count == 0) {
        } else {
            for (NSDictionary * currentInfo in webInfo) {
                WebImage *image = [[WebImage alloc] initWithFrame:CGRectMake(0, 0 , 320, 320)];
                __weak WebImage * webImage = image;
                [webImage setImageURL:[currentInfo valueForKey:@"picture"] completion:^(UIImage *image) {
                    
                }];
                image = nil;
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            handler([data objectFromJSONData], error);
        });
        
    });

}

+(void)loadSearchPoints :(NSString*) searchTxt completion:( void (^) (id response, NSError *error))handler {
    NSString *method = [NSString stringWithFormat:@"mains/%@/search/point",searchTxt];
    NSString *params = @"";
    
    NSMutableURLRequest *request = [self requestForGetMethod:method withParams:params];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURLResponse* response = nil;
        NSError *error = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSArray* webInfo = [data objectFromJSONData];
        if (webInfo.count == 0) {
        } else {
            for (NSDictionary * currentInfo in webInfo) {
                WebImage *image = [[WebImage alloc] initWithFrame:CGRectMake(0, 0 , 320, 320)];
                __weak WebImage * webImage = image;
                [webImage setImageURL:[currentInfo valueForKey:@"picture"] completion:^(UIImage *image) {
                    
                }];
                image = nil;
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            handler([data objectFromJSONData], error);
        });
        
    });

}

+(void)add_new_point_name:(NSString*)name tags:(NSString*)tags category:(NSString*)category lng:(NSString*)lng lat:(NSString*)lat city:(NSString*)city state:(NSString*)state address:(NSString*)address zip:(NSString*)zip email:(NSString*)email weburl:(NSString*)weburl description:(NSString*)description paypal:(NSString*)paypal photos:(NSArray*)photos completion:(void(^)(id response, NSError *error))handler {
    NSString *method =@"mains/news/points";
    
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    
    //name
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"name\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[name dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //tags
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"tags\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[tags dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //category
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"category\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[category dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //lng
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"lng\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[lng dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //lat
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"lat\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[lat dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //city
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"city\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[city dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //state
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"state\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[state dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //address
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"address\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[address dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //zip
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"zip\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[zip dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //email
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"email\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[email dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //weburl
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"weburl\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[weburl dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //description
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"description\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[description dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //paypal
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"paypal\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[paypal dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    for (int i = 0; i < photos.count; i++) {
        UIImage * image = photos[i];
        
        NSString * photoName;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"YY_MM_dd_HH_mm_SS"];
        NSDate *date = [NSDate date];
        photoName = [dateFormat stringFromDate:date];
        
        NSData *imageData = UIImagePNGRepresentation(image);
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=photo_%@_%d.png\r\n", photoName,i] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type:image/png;\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [self requestForPostMethod:method withParams:body];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURLResponse* response = nil;
        NSError *error = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSString *respData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"respData %@", respData);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            handler([data objectFromJSONData], error);
        });
        
    });
}


+ (void)addSelfie:(UIImage*)image point:(NSString*)pointId completion:(void(^)(id response, NSError *error))handler {

    NSString *method =@"checkins/checks/ins";
    
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    
    //point
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"point\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[pointId dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    // token
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[AppManager sharedInstance].token dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    // user
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[[[[AppManager sharedInstance].userInfo valueForKey:@"user"] valueForKey:@"id"] stringValue] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    // message
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"message\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // photo
    NSString * photoName;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YY_MM_dd_HH_mm_SS"];
    NSDate *date = [NSDate date];
    photoName = [dateFormat stringFromDate:date];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"files\"; filename=photo_%@.png\r\n", photoName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type:image/png;\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [self requestForPostMethod:method withParams:body];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURLResponse* response = nil;
        NSError *error = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSString *respData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"respData %@", respData);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            handler([data objectFromJSONData], error);
        });
        
    });

}

+ (void)checkinsForPoint:(NSString*)pointId completion:(void(^)(id response, NSError *error))handler {
    NSString *method = [NSString stringWithFormat:@"mains/%@/point/checkins", pointId];
    NSString *params = @"";
    
    NSMutableURLRequest *request = [self requestForGetMethod:method withParams:params];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURLResponse* response = nil;
        NSError *error = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            handler([data objectFromJSONData], error);
        });
        
    });
}

+ (void)deleteCheckin:(NSString *)checkinId completion:(void(^)(id response, NSError *error))handler {
    NSString *method = [NSString stringWithFormat:@"checkins/%@", checkinId];
    NSString *params = @"";
    
    NSMutableURLRequest *request = [self requestForDeleteMethod:method withParams:params];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURLResponse* response = nil;
        NSError *error = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            handler([data objectFromJSONData], error);
        });
        
    });
}


#pragma mark - requests
+ (NSMutableURLRequest *) requestForGetMethod:(NSString *)method withParams:(NSString *)params {
    
    NSString* url = [NSString stringWithFormat:@"%@%@?%@", wsUrl, method, params];
    if (params.length == 0) {
        url = [NSString stringWithFormat:@"%@%@", wsUrl, method];
    }
    url =[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];
    [request setHTTPMethod:@"GET"];
    
    return request;
}

+ (NSMutableURLRequest *) requestForMethod:(NSString *)method withParams:(NSString *)params {
    
    NSString* url = [NSString stringWithFormat:@"%@%@", wsUrl, method];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];
    
    [request setHTTPMethod:@"POST"];
    
    params = [params stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [params dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:postData];
    
    
    return request;
}

+ (NSMutableURLRequest *) requestForPostMethod:(NSString *)method withParams:(NSData *)params {
    
    NSString* url = [NSString stringWithFormat:@"%@%@", wsUrl, method];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:300.0f];
    
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    
    [request addValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",boundary] forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"*/*" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody:params];
    
    return request;
}


+ (NSMutableURLRequest *) requestForDeleteMethod:(NSString *)method withParams:(NSString *)params {
    
    NSString* url = [NSString stringWithFormat:@"%@%@?%@", wsUrl, method, params];
    if (params.length == 0) {
        url = [NSString stringWithFormat:@"%@%@", wsUrl, method];
    }
    url =[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];
    [request setHTTPMethod:@"DELETE"];
    
    return request;
}

@end
