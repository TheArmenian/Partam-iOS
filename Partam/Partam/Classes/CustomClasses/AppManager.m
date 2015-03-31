//
//  AppManager.m
//  Partam
//
//  Created by Sargis Gevorgyan on 2/24/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import "AppManager.h"
static AppManager * instance = nil;
@implementation AppManager
@synthesize isIpad;
@synthesize isiPhone5;
@synthesize apiURL;
@synthesize isLogOut;
@synthesize token;

+(AppManager*)sharedInstance {
    if (!instance) {
        instance = [[AppManager alloc]init];
    }
    return instance;
}
- (id)init {
    self = [super init];
    if (self) {
        isIpad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
        isiPhone5 = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568.0);

        [self loadSettings];       
    }
    return self;
}

-(void)loadSettings {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"NotFirst"]) {
		[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"NotFirst"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogOut"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"token"];
    }

    apiURL = @"http://partam.partam.com/api/v1";
    isLogOut = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogOut"];
    token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
    self.userInfo = [[NSUserDefaults standardUserDefaults]valueForKey:@"userInfo"];
    self.userFavorites = [[NSUserDefaults standardUserDefaults]valueForKey:@"userFavorites"];
    self.userLocalFavorites =[[NSUserDefaults standardUserDefaults]valueForKey:@"userLocalFavorites"];
    self.isFilter = NO;
    [self loadAllMapPoints];
}

-(void)saveSettings {
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"NotFirst"];
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] setBool:isLogOut forKey:@"isLogOut"];
    [[NSUserDefaults standardUserDefaults] setObject:self.userFavorites forKey:@"userFavorites"];
    [[NSUserDefaults standardUserDefaults] setObject:self.userLocalFavorites forKey:@"userLocalFavorites"];
    [[NSUserDefaults standardUserDefaults] setObject:self.userInfo forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (UIImage*)captureView:(UIView *)view {
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return img;
}

-(UIImage*)getMapCategoryImage:(NSString*)title
{
    // Business
    if ([title isEqualToString:@"Hotels"] ||
        [title isEqualToString:@"Travel Agencies"] ||
        [title isEqualToString:@"Markets"] ||
        [title isEqualToString:@"Attorneys"] ||
        [title isEqualToString:@"Restaurants"] ||
        [title isEqualToString:@"Events"] ||
        [title isEqualToString:@"Entertainers"] ||
        [title isEqualToString:@"Wedding Planning"] ||
        [title isEqualToString:@"Bakeries & Wedding Cakes"] ||
        [title isEqualToString:@"Banquet Halls"] ||
        [title isEqualToString:@"Doctors"] ||
        [title isEqualToString:@"Catering"] ||
        [title isEqualToString:@"Architect"] ||
        [title isEqualToString:@"Photographers & Videographers"] ||
        [title isEqualToString:@"Jewelry"] ||
        [title isEqualToString:@"Hair Salons"] ||
        [title isEqualToString:@"Media"] ||
        [title isEqualToString:@"Makeup Artists"])
    {
        return [UIImage imageNamed:@"cat_bussines.png"];
    }
    
    // Contributuion
    if ([title isEqualToString:@"Contributions"])
    {
        return [UIImage imageNamed:@"cat_contributionst.png"];
    }
    
    // Culture
    if ([title isEqualToString:@"Museums"] ||
        [title isEqualToString:@"Memorials"] ||
        [title isEqualToString:@"Schools"] ||
        [title isEqualToString:@"Cultural Centers"] ||
        [title isEqualToString:@"Organizations"])
    {
        return [UIImage imageNamed:@"cat_culture.png"];
    }
    
    // Government
    if ([title isEqualToString:@"Embassies & Consulates"] ||
        [title isEqualToString:@"Campgrounds"])
    {
        return [UIImage imageNamed:@"cat_government.png"];
    }
    
    // Landmark
    if ([title isEqualToString:@"Cities & Street Names"] ||
        [title isEqualToString:@"Sister Cities"]||
        [title isEqualToString:@"Genocide Memorials"] ||
        [title isEqualToString:@"Monuments"])
    {
        return [UIImage imageNamed:@"cat_landmark.png"];
    }
    
    // Religious
    if ([title isEqualToString:@"Churches"] ||
        [title isEqualToString:@"Khachkars"])
    {
        return [UIImage imageNamed:@"cat_religious.png"];
    }
    
    // If this is a new category then return business type by default
    return [UIImage imageNamed:@"cat_bussines.png"];
}

-(BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//- (NSArray*) loadWebInfo:(int)count :(int)limit {
//    NSHTTPURLResponse* response;
//    NSString *url =[NSString stringWithFormat:@"%@/mains/%d/limits/%d/offset",[AppManager sharedInstance].apiURL,count,limit];
//    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
//                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
//    
//    NSError * error = 0;
//    NSData* data  = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error ];
//    if (error || !data) {
//        return nil;
//    }
//    if ([response statusCode] == 0) {
//        
//        return nil;
//    }
//    
//    NSArray* webInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//    if (webInfo.count == 0) {
//        [self.delegate upDateFailed];
//    } else {
//        [self.delegate upDateCompleted];
//        
//        for (NSDictionary * currentInfo in webInfo) {
//            WebImage *image = [[WebImage alloc] initWithFrame:CGRectMake(0, 0 , 320, 320) imageURL:[currentInfo valueForKey:@"picture"]];
//            image = nil;
//        }
//        
//    }
//    
//    return webInfo;
//}
/*
 - (NSArray*) loadPointByCategory:(NSString*)categories limit:(int)limit {
    NSHTTPURLResponse* response;

    NSString *url =[NSString stringWithFormat:@"%@/mains/%@/points/%d/starts/10/limits/name/orders/asc/direction",[AppManager sharedInstance].apiURL,categories,limit];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    
    NSError * error = 0;
    NSData* data  = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error ];
    if (error || !data) {
        return nil;
    }
    if ([response statusCode] == 0) {
        
        return nil;
    }
    
    NSArray* webInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (webInfo.count == 0) {
        [self.delegate upDateFailed];
    } else {
        [self.delegate upDateCompleted];
        
        for (NSDictionary * currentInfo in webInfo) {
            WebImage *image = [[WebImage alloc] initWithFrame:CGRectMake(0, 0 , 320, 320) imageURL:[currentInfo valueForKey:@"picture"]];
            image = nil;
        }
        
    }
    return webInfo;

}*/

/*
- (NSArray*) loadPointByCity_latitude:(NSString*)lats longitude:(NSString*)longs limit:(int)limit offSet:(int)offSet {
    NSHTTPURLResponse* response;
    //    /api/v1/mains/{latitude}/lats/{longitude}/longs/{limit}/limits/{offset}/offsets/{distance}/distance
    NSString *url =[NSString stringWithFormat:@"%@/mains/%@/lats/%@/longs/%d/limits/%d/offsets/50/distance", [AppManager sharedInstance].apiURL,lats,longs,limit,offSet];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    
    NSError * error = 0;
    NSData* data  = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error ];
    if (error || !data) {
        return nil;
    }
    if ([response statusCode] == 0) {
        
        return nil;
    }
    
    NSArray* webInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (webInfo.count == 0) {
        [self.delegate upDateFailed];
    } else {
        [self.delegate upDateCompleted];
        
        for (NSDictionary * currentInfo in webInfo) {
            WebImage *image = [[WebImage alloc] initWithFrame:CGRectMake(0, 0 , 320, 320) imageURL:[currentInfo valueForKey:@"picture"]];
            image = nil;
        }
        
    }
    return webInfo;
}
*/

/*
- (NSArray*) loadPointByCategoriesAndCity:(NSString*)categories latitude:(NSString*)lats longitude:(NSString*)longs limit:(int)limit offSet:(int)offSet; {
    NSHTTPURLResponse* response;
 
    NSString *url =[NSString stringWithFormat:@"%@/mains/%@/cats/%@/lats/%@/longs/%d/limits/%d/offsets/50/distance", [AppManager sharedInstance].apiURL,categories,lats,longs,limit,offSet];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    
    NSError * error = 0;
    NSData* data  = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error ];
    if (error || !data) {
        return nil;
    }
    if ([response statusCode] == 0) {
        
        return nil;
    }
    
    NSArray* webInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (webInfo.count == 0) {
        [self.delegate upDateFailed];
    } else {
        [self.delegate upDateCompleted];
        
        for (NSDictionary * currentInfo in webInfo) {
            WebImage *image = [[WebImage alloc] initWithFrame:CGRectMake(0, 0 , 320, 320) imageURL:[currentInfo valueForKey:@"picture"]];
            image = nil;
        }
        
    }
    return webInfo;

}
 */

//- (NSArray*) loadSearchPoints :(NSString*) searchTxt {
//    NSHTTPURLResponse* response;
//    NSString *url =[NSString stringWithFormat:@"%@/mains/%@/search/point",[AppManager sharedInstance].apiURL,searchTxt];
//    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
//                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
//    
//    NSError * error = 0;
//    NSData* data  = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error ];
//    if (error || !data) {
//        return nil;
//    }
//    if ([response statusCode] == 0) {
//        
//        return nil;
//    }
//    
//    NSArray* webInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//    if (webInfo.count == 0) {
//        [self.delegate upDateFailed];
//    } else {
//        [self.delegate upDateCompleted];
//        
//        for (NSDictionary * currentInfo in webInfo) {
//            WebImage *image = [[WebImage alloc] initWithFrame:CGRectMake(0, 0 , 320, 320) imageURL:[currentInfo valueForKey:@"picture"]];
//            image = nil;
//        }
//        
//    }
//    return webInfo;
//
//}

- (NSArray*) loadCategoriesInfo :(NSString*) categories {
    NSHTTPURLResponse* response;
    NSString *url =[NSString stringWithFormat:@"%@/main/%@",[AppManager sharedInstance].apiURL,categories];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    
    NSError * error = 0;
    NSData* data  = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error ];
    if (error || !data) {
        return nil;
    }
    if ([response statusCode] == 0) {
        
        return nil;
    }
    
    self.categoriesArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    return self.categoriesArray;
}

- (NSDictionary*) loadLocationsInfo :(NSString*) locations {
    NSHTTPURLResponse* response;
    NSString *url =[NSString stringWithFormat:@"%@/main/%@",[AppManager sharedInstance].apiURL,locations];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    
    NSError * error = 0;
    NSData* data  = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error ];
    if (error || !data) {
        return nil;
    }
    if ([response statusCode] == 0) {
        
        return nil;
    }
    
    NSDictionary* webInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    return webInfo;
}

- (NSDictionary*) loadDetailInfo :(int) detailID {
    NSHTTPURLResponse* response;
    NSString *url =[NSString stringWithFormat:@"%@/mains/%d/point",[AppManager sharedInstance].apiURL,detailID];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    
    NSError * error = 0;
    NSData* data  = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error ];
    if (error || !data) {
        return nil;
    }
    if ([response statusCode] == 0) {
        
        return nil;
    }
    
    NSDictionary* webInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    return webInfo;
}

- (NSDictionary*) loadUserInfo {
    NSHTTPURLResponse* response;
    NSString *url =[NSString stringWithFormat:@"%@/users/%@/profile",self.apiURL, self.token];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
       [request setHTTPMethod:@"GET"];
    NSError * error = 0;
    NSData* data  = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error ];
    if (error || !data) {
         self.token = nil;
        return nil;
    }
    if ([response statusCode] == 0) {
        
        return nil;
    }
    
    self.userInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
   
    if (![[self.userInfo valueForKey:@"user"] isKindOfClass:[NSDictionary class]]) {
        self.token = nil;
        return nil;
    }
    [self saveSettings];
    [self loadUserFavorites];
    return self.userInfo;
    
}


- (NSDictionary*) loadUserFavorites {
    NSHTTPURLResponse* response;
    NSString *url =[NSString stringWithFormat:@"%@/mains/%@/favorites/user",self.apiURL, self.token];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    NSError * error = 0;
    NSData* data  = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error ];
    if (error || !data) {
        
        return nil;
    }
    if ([response statusCode] == 0) {
        
        return nil;
    }
    
    self.userFavorites = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (self.userLocalFavorites.count == 0) {
        self.userLocalFavorites = [[NSMutableArray alloc]initWithArray:[self.userFavorites valueForKey:@"favorites"]];
    } else {
        NSMutableArray * favorites = [[NSMutableArray alloc]initWithArray:[self.userFavorites valueForKey:@"favorites"]];
        NSMutableArray * localFavorites = [[NSMutableArray alloc]initWithArray:self.userLocalFavorites];
        if (self.userLocalFavorites.count > favorites.count) {
            [localFavorites removeObjectsInArray:favorites];
            [self.userLocalFavorites removeObjectsInArray:localFavorites];
        } else if(self.userLocalFavorites.count < favorites.count){
            [favorites removeObjectsInArray:localFavorites];
            [self.userLocalFavorites addObjectsFromArray:favorites];
        }
    }
    [self saveSettings];
    return self.userFavorites;
}

- (NSDictionary*) addOrRemoveFavorites:(int)point method:(NSString*)method{
    NSHTTPURLResponse* response;
    
    NSString *url =[NSString stringWithFormat:@"%@/mains/%d/favorites/%@/user", self.apiURL,point,self.token];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:method];
    NSError * error = 0;
    NSData* data  = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error ];
    if (error || !data) {
        
        return nil;
    }
    if ([response statusCode] == 0) {
        
        return nil;
    }
    
    NSDictionary* webInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    //[self userFavorites];
    return webInfo;

}


- (NSArray*) userLogout {
    self.userInfo = nil;
    self.userFavorites = nil;
    [self saveSettings];
    NSHTTPURLResponse* response;
    NSString *url =[NSString stringWithFormat:@"%@/users/%@/logout", self.apiURL, self.token];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    NSError * error = 0;
    NSData* data  = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error ];
    if (error || !data) {
        
        return nil;
    }
    if ([response statusCode] == 0) {
        
        return nil;
    }
    
    NSArray* webInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if ([[webInfo valueForKey:@"success"] integerValue] == 1) {
        token = nil;
        isLogOut = YES;
        [self saveSettings];
    }
    self.userInfo = nil;
    self.userFavorites = nil;
    [self saveSettings];
    return webInfo;

}

- (NSDictionary*) changeUserInfo:(NSString*)format {
    NSHTTPURLResponse* response;
    NSString *url =[NSString stringWithFormat:@"%@/users/%@/profile",self.apiURL, self.token];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PATCH"];
     NSData* formatData = [format dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:formatData];
    NSError * error = 0;
    NSData* data  = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ([response statusCode] == 0) {
        
        return nil;
    }
    
    NSDictionary* webInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    return webInfo;
}

- (NSDictionary*) changeUserPass:(NSString *)format {
    NSHTTPURLResponse* response;
    NSString *url =[NSString stringWithFormat:@"%@/users/%@/password/reset", self.apiURL, self.token];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    NSData* formatData = [format dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:formatData];
    NSError * error = 0;
    NSData* data  = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ([response statusCode] == 0) {
        
        return nil;
    }
    
    NSDictionary* webInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    return webInfo;
}

- (NSDictionary*) changeUserAvatar:(NSData*)format {
    NSHTTPURLResponse* response;
    NSString *url =[NSString stringWithFormat:@"%@/users/%@/images", self.apiURL, self.token];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
//    NSData* formatData = [format dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:format];
    NSError * error = 0;
    NSData* data  = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ([response statusCode] == 0) {
        
        return nil;
    }
    
   NSDictionary* webInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    return webInfo;
}

- (NSDictionary*) addComment:(NSString*)comment :(int)pointId {
    NSHTTPURLResponse* response;
   
    NSString *url =[NSString stringWithFormat:@"%@/comments/%@/points/%d",self.apiURL, self.token, pointId];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    comment = [NSString stringWithFormat:@"comment[name]=%@&comment[message]=%@",[[self.userInfo valueForKey:@"user"] valueForKey:@"display_name"], comment];
    NSData* formatData = [comment dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:formatData];
    NSError * error = 0;
    NSData* data  = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ([response statusCode] == 0) {
        
        return nil;
    }
    
    NSDictionary* webInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    return webInfo;

}

-(void)loadAllMapPoints {
    NSHTTPURLResponse* response;
    NSString *url =[NSString stringWithFormat:@"%@/main/map/points",apiURL];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    
    NSError * error = 0;
    NSData* data  = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error ];
    if (error || !data) {
        return ;
    }
    
   self.allPoints = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
   
}

+(UIImage *)cropImage_cropFrame:(CGRect)cropFrame latestFrame:(CGRect)latestFrame originalImage:(UIImage*)originalImage {
    CGRect squareFrame = cropFrame;
    CGFloat scaleRatio = latestFrame.size.width / originalImage.size.width;
    CGFloat x = (squareFrame.origin.x - latestFrame.origin.x) / scaleRatio;
    CGFloat y = (squareFrame.origin.y - latestFrame.origin.y) / scaleRatio;
    CGFloat w = squareFrame.size.width / scaleRatio;
    CGFloat h = squareFrame.size.height / scaleRatio;
    if (latestFrame.size.width < cropFrame.size.width) {
        CGFloat newW = originalImage.size.width;
        CGFloat newH = newW * (cropFrame.size.height / cropFrame.size.width);
        x = 0; y = y + (h - newH) / 2;
        w = newH; h = newH;
    }
    if (latestFrame.size.height < cropFrame.size.height) {
        CGFloat newH = originalImage.size.height;
        CGFloat newW = newH * (cropFrame.size.width / cropFrame.size.height);
        x = x + (w - newW) / 2; y = 0;
        w = newH; h = newH;
    }
    CGRect myImageRect = CGRectMake(x, y, w, h);
    CGImageRef imageRef = originalImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size;
    size.width = myImageRect.size.width;
    size.height = myImageRect.size.height;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    return smallImage;
}

+ (void)showMessageBox:(NSString*)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView* alert = [[UIAlertView alloc] init];
        alert.title = @"Partam";
        alert.message = message;
        
        [alert addButtonWithTitle:@"OK"];
        [alert show];
        alert = nil;
    });
}
@end
