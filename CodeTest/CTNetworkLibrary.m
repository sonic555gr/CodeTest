//
//  CTNetworkLibrary.m
//  CodeTest
//
//  Created by Alkiviadis Papadakis on 29/10/2015.
//  Copyright © 2015 Alkimo Ltd. All rights reserved.
//

#import "CTNetworkLibrary.h"
#import "CTResultParser.h"
#define CTNetworkLibrarySongsBaseURL @"http://itunes.apple.com/search"



@interface CTNetworkLibrary()
@property(nonatomic, strong)NSURLSession *session;
@property(nonatomic, strong)NSURLSession *imageSession;
@end

@implementation CTNetworkLibrary

+ (instancetype)sharedLibrary
{
    static CTNetworkLibrary *_sharedLibrary;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLibrary = [[CTNetworkLibrary alloc] init];
    });
    return  _sharedLibrary;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _session = [NSURLSession sharedSession];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        // We could, at this stage listen for memory warnings and clear the cache explicitly. No time though.
        configuration.URLCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:50 * 1024 *1024 diskPath:nil];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:[NSOperationQueue mainQueue]usingBlock:^(NSNotification * _Nonnull note) {
            [_imageSession.configuration.URLCache removeAllCachedResponses];
        }];
        
        _imageSession = [NSURLSession sessionWithConfiguration:configuration];
    }
    return self;
}

- (void)searchResultsForQuery:(NSString *)query completion:(CTNetworkLibrarySearchResultsCompletionBlock)completion
{
    [self cancelAllOutstandingTasksWithCompletion:^(){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSURL *url = [self urlForQuery:query];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSURLSessionDataTask *dataTask = [_session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            /*
                Here we should devise a mechanism to handle response codes and potential errors.
             Due to time limitations, we assume that all errors are handled.
             if (error)
             {
                call completion with error here.
             }
             
             
             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
             switch(httpResponse.statusCode)
            {
                case 200:
             //success
             break;
             case 404:
             //notFound:
             break;
             case 500:
             //server error:
             break;
             }
             */

            CTResultParser *parser = [[CTResultParser alloc] init];
            NSArray *dictionariesArray = [parser resultsDictionariesFromData:data];
            NSArray *results = [parser resultsWithArrayOfDictionaries:dictionariesArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                if (completion)
                {
                    completion(results, error);
                }
            });
        }];
        [dataTask resume];
    }];
}

- (void)asyncronousImageWithURL:(NSURL *)url completion:(CTNetworkLibraryImageCompletionBlock)completion
{
    NSURLSessionDataTask *imageTask = [_imageSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *image = nil;
        if (data)
        {
            image = [UIImage imageWithData:data];
        }
        if (completion)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(image, error);
            });
        }
    }];
    [imageTask resume];
}

- (void)cancelAllOutstandingTasksWithCompletion:(dispatch_block_t)completion
{
    [_session getAllTasksWithCompletionHandler:^(NSArray<__kindof NSURLSessionTask *> * _Nonnull tasks) {
        for (NSURLSessionTask *task in tasks)
        {
            [task suspend];
            [task cancel];
        }
        if (completion) { completion(); }
    }];
}

- (NSURL *)urlForQuery:(NSString *)query
{
    if (!query || query.length == 0)
        return nil;
    NSURLComponents *components = [NSURLComponents componentsWithString:CTNetworkLibrarySongsBaseURL];
    
    NSString *parameterQuery = [NSString stringWithFormat:@"term=%@",[query stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    [components setQuery: parameterQuery];
    return components.URL;
}



@end
