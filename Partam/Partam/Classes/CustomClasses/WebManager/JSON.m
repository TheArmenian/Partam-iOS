//
//  JSON.m
//  Listar
//
//  Created by Asatur Galstyan on 4/24/14.
//  Copyright (c) 2014 Zanazan Systems. All rights reserved.
//

#import "JSON.h"

#pragma mark Deserializing methods

@implementation NSString (JSONKitDeserializing)

- (id)objectFromJSONString
{
    NSData *jsonData = [self JSONData];
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
}

@end


@implementation NSData (JSONDeserializing)

- (id)objectFromJSONData
{
    return [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:nil];
}

@end


#pragma mark Serializing methods

@implementation NSString (JSONSerializing)

- (NSData *)JSONData
{
    return [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
}

- (NSString *)JSONString
{
    
    NSString* jsonString = [[NSString alloc] initWithData:[self JSONData] encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end

@implementation NSArray (JSONSerializing)

- (NSData *)JSONData
{
    return [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
}

- (NSString *)JSONString
{
    NSString* jsonString = [[NSString alloc] initWithData:[self JSONData] encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end

@implementation NSDictionary (JSONKitSerializing)

- (NSData *)JSONData
{
    return [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
}

- (NSString *)JSONString
{
    NSString* jsonString = [[NSString alloc] initWithData:[self JSONData] encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end