//
//  CTResultParser.m
//  CodeTest
//
//  Created by Alkiviadis Papadakis on 29/10/2015.
//  Copyright © 2015 Alkimo Ltd. All rights reserved.
//

#import "CTResultParser.h"

@implementation CTResultParser

- (instancetype)init
{
    self = [super init];
    if (self) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"YYYY-MM-dd'T'HH:mm:ssZ";
        //2008-10-07T07:00:00Z
    }
    return self;
}

- (NSArray *)resultsWithArrayOfDictionaries:(NSArray *)dictionaries
{
    if (!dictionaries || dictionaries.count == 0)
        return nil;

    NSMutableArray *resultsArray = @[].mutableCopy;
    for (NSDictionary *dictionary in dictionaries)
    {
        CTResult *result = [self resultWithDictionary:dictionary];
        [resultsArray addObject:result];
    }

    return resultsArray.copy;
}

- (CTResult *)resultWithDictionary:(NSDictionary *)dictionary
{
    if (!dictionary || dictionary.count == 0)
        return nil;
    
    CTResult *result = [[CTResult alloc] init];
    result.albumName = dictionary[@"collectionName"];
    result.artistName = dictionary[@"artistName"];
    result.artworkUrl = [NSURL URLWithString:dictionary[@"artworkUrl100"]];
    result.trackName = dictionary[@"trackName"];
    result.price = [(NSNumber *)dictionary[@"trackPrice"] floatValue];
    result.releaseDate = [_formatter dateFromString:dictionary[@"releaseDate"]];
    return result;
}


/*
 Error handling hasn't been done here due to time limitation.
 In Proper error handling there would be a list with error codes and a mechanism that generates NSError instances with the correct domain and code as well as message for the user."
 */

- (NSArray *)resultsDictionariesFromData:(NSData *)data
{
    if (!data) { return nil; }
    NSError *parsingError;
    NSDictionary *resultsDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
    if (parsingError) { return nil; }
    
    NSArray *resultsDictionariesArray = resultsDictionary[@"results"];
    
    return resultsDictionariesArray;
}

@end
