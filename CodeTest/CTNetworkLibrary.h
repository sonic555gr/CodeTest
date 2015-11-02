//
//  CTNetworkLibrary.h
//  CodeTest
//
//  Created by Alkiviadis Papadakis on 29/10/2015.
//  Copyright © 2015 Alkimo Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CTNetworkLibrarySearchResultsCompletionBlock) (NSArray *results, NSError *error);
typedef void (^CTNetworkLibraryImageCompletionBlock) (UIImage *image, NSError *error);
@interface CTNetworkLibrary : NSObject

+ (instancetype)sharedLibrary;

- (void)searchResultsForQuery:(NSString *)query completion:(CTNetworkLibrarySearchResultsCompletionBlock)completion;

- (NSURL *)urlForQuery:(NSString *)query;

- (void)asyncronousImageWithURL:(NSURL *)url completion:(CTNetworkLibraryImageCompletionBlock)completion;

@end
