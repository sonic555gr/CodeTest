//
//  CTNetworkLibraryTests.m
//  CodeTest
//
//  Created by Alkiviadis Papadakis on 30/10/2015.
//  Copyright © 2015 Alkimo Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CTNetworkLibrary.h"

@interface CTNetworkLibraryTests : XCTestCase
@property (nonatomic, strong)CTNetworkLibrary *library;
@end

@implementation CTNetworkLibraryTests

- (void)setUp {
    _library = [[CTNetworkLibrary alloc] init];
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testURLForQueryReturnsNilIfStringQueryIsNil
{
    NSURL *url =[_library urlForQuery:nil];
    XCTAssertNil(url);
}

- (void)testURLForQueryReturnsNilIfStringIsEmpty
{
    NSURL *url = [_library urlForQuery:@""];
    XCTAssertNil(url);
}

- (void)testURLForQueryReturnsURLIfQueryIsNotEmpty
{
    NSURL *url = [_library urlForQuery:@"a query"];
    XCTAssertNotNil(url);
}

- (void)testURLForQueryAppendsQueryAtTheEndOfURL
{
    NSURL *url = [_library urlForQuery:@"a query"];
    XCTAssertTrue([url.absoluteString hasSuffix:@"query"]);
}

- (void)testURLForQueryAppendsQueryWithPlusReplacingSpaces
{
    NSURL *url = [_library urlForQuery:@"a query"];
    XCTAssertTrue([url.absoluteString hasSuffix:@"a+query"]);
}



@end
