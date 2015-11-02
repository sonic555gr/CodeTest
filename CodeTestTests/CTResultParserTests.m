//
//  CTResultParserTests.m
//  CodeTest
//
//  Created by Alkiviadis Papadakis on 29/10/2015.
//  Copyright © 2015 Alkimo Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CTResultParser.h"
@interface CTResultParserTests : XCTestCase
@property (nonatomic, strong) CTResultParser *parser;
@property (nonatomic, strong) NSDictionary *validResultDictionary;
@property (nonatomic, strong) NSArray *validResultDictionariesArray;
@end

@implementation CTResultParserTests

- (void)setUp {
    [super setUp];
    _parser = [[CTResultParser alloc] init];
    self.continueAfterFailure = YES;
    
    NSData *resultsData = [self dataWithContentsOfFileWithName:@"Results"];
    
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:resultsData options:NSJSONReadingAllowFragments error:nil];
    
    _validResultDictionariesArray = (NSArray *)responseDictionary[@"results"];
    _validResultDictionary = _validResultDictionariesArray[0];
}

- (NSData *)dataWithContentsOfFileWithName:(NSString *)filename
{
    NSBundle *testBundle = [NSBundle bundleForClass:self.class];
    NSString *path = [testBundle pathForResource:filename ofType:@"json" inDirectory:nil];
    return [NSData dataWithContentsOfFile:path];
}

- (void)tearDown {
    _parser = nil;
    _validResultDictionariesArray = nil;
    _validResultDictionary = nil;
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testResultWithDictionaryReturnsNilIfDictionaryIsNil
{
    XCTAssertNil([_parser resultWithDictionary:nil]);
}

- (void)testResultWithDictionaryReturnsNilIfDictionaryIsEmpty
{
    XCTAssertNil([_parser resultWithDictionary:@{}]);
}

- (void)testResultWithDictionaryReturnsCTResultObjectIfDictionaryIsNotNilOrEmpty
{
    CTResult *result = [_parser resultWithDictionary:_validResultDictionary];
    XCTAssertNotNil(result);
}

- (void)testResultWithDictinoaryReturnsCTResultObjectWithAssignedData
{
    CTResult *result = [_parser resultWithDictionary:_validResultDictionary];
    XCTAssertEqualObjects(result.albumName, _validResultDictionary[@"collectionName"]);
    XCTAssertEqualObjects(result.artistName, _validResultDictionary[@"artistName"]);
    XCTAssertEqualObjects(result.artworkUrl.absoluteString, _validResultDictionary[@"artworkUrl100"]);
    XCTAssertEqual(result.price, [_validResultDictionary[@"trackPrice"] floatValue]);
    XCTAssertEqualObjects(result.trackName, _validResultDictionary[@"trackName"]);
    XCTAssertNotNil(result.releaseDate);
    XCTAssertEqualObjects(result.releaseDate, [_parser.formatter dateFromString:_validResultDictionary[@"releaseDate"]]);
}

- (void)testResultsParserInitializationCreatesDateFormatter
{
    XCTAssertNotNil(_parser.formatter);
}

- (void)testResultsParserInitializationCreatesDateFormatterWithDateFormatString
{
    XCTAssertEqualObjects(_parser.formatter.dateFormat, @"YYYY-MM-dd'T'HH:mm:ssZ");
}

- (void)testResultsWithArrayOfDictionariesReturnsNilIfArrayIsNil
{
    NSArray *resultsArray = [_parser resultsWithArrayOfDictionaries:nil];
    XCTAssertNil(resultsArray);
}

- (void)testResultsWithArrayOfDictionariesReturnsNilIfArrayIsNotNilAndEmpty
{
    NSArray *resultsArray = [_parser resultsWithArrayOfDictionaries:@[]];
    XCTAssertNil(resultsArray);
}


- (void)testResultsWithArrayOfDictionariesReturnsAsManyObjectsAsDictionariesPassedIn
{
    NSArray *resultsArray = [_parser resultsWithArrayOfDictionaries:_validResultDictionariesArray];
    XCTAssertEqual(resultsArray.count, _validResultDictionariesArray.count);
}


- (void)testResultsDictionariesFromDataReturnsNilIfDataIsNil
{
    NSArray *results = [_parser resultsDictionariesFromData:nil];
    XCTAssertNil(results);
}

- (void)testResultsDictionariesFromDataReturnsNilIfDataIsNotJSON
{
    NSData *data = [@"This is not a json File!" dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *results = [_parser resultsDictionariesFromData:data];
    XCTAssertNil(results);
}

- (void)testResultsDictionariesFromDataReturnsArrayIfDataIsParsableResultsJSON
{
    NSData *data = [self dataWithContentsOfFileWithName:@"Results"];
    NSArray *array = [_parser resultsDictionariesFromData:data];
    XCTAssertNotNil(array);
    XCTAssertTrue(array.count > 0);
}


@end
