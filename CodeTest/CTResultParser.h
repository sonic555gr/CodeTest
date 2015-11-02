//
//  CTResultParser.h
//  CodeTest
//
//  Created by Alkiviadis Papadakis on 29/10/2015.
//  Copyright © 2015 Alkimo Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTResult.h"

@interface CTResultParser : NSObject
@property (nonatomic, readonly)NSDateFormatter *formatter;

- (CTResult *)resultWithDictionary:(NSDictionary *)dictionary;

- (NSArray *)resultsWithArrayOfDictionaries:(NSArray *)dictionaries;

- (NSArray *)resultsDictionariesFromData:(NSData *)data;
@end
