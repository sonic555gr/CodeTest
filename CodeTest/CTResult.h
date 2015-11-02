//
//  CTResult.h
//  CodeTest
//
//  Created by Alkiviadis Papadakis on 29/10/2015.
//  Copyright © 2015 Alkimo Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTResult : NSObject
@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *trackName;
@property (nonatomic, strong) NSURL *artworkUrl;
@property (nonatomic, strong) NSString *albumName;
@property (nonatomic, strong) NSDate *releaseDate;
@property (nonatomic) float price;
@end
