//
//  CSNSymbolRepositoryTests.m
//  SymbolNameAutocompleteTests
//
//  Created by griffin-stewie on 2018/11/23.
//  Copyright © 2018 cyan-stivy.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CSNSymbolRepository.h"
#import "CSNNameTokenizer.h"
#import "CSNFetchResult.h"
#import "CSNSymbolMasterItem.h"

@interface CSNSymbolRepositoryTests : XCTestCase
@property (nonatomic, strong) CSNSymbolRepository *repository;
@end

@implementation CSNSymbolRepositoryTests

- (void)setUp
{
    self.repository = [[CSNSymbolRepository alloc] initWithNames:@[
                                                                   @"ListItem/Online",
                                                                   @"ListItem/Offline",
                                                                   @"StatusBar",
                                                                   ]];
}

- (void)tearDown
{
    self.repository = nil;
}

- (void)testFetchItemsByStringEndWithDelimiter
{
    NSString *input = @"ListItem/";
    CSNFetchResult *result = [self.repository fetchItemsByString:input];
    XCTAssertEqual(result.items.count, 2);
}

- (void)testFetchItemsByStringEndWithFirstLetter
{
    NSString *input = @"ListItem/o";

    CSNFetchResult *result = [self.repository fetchItemsByString:input];
    XCTAssertEqual(result.items.count, 2);

    XCTAssertEqualObjects([result.items[0] tokenAtLevel:result.bottomLevel], @"Online");

    NSArray <NSString *> *tokens = [result tokensAtBottomLevel];
    XCTAssertEqualObjects(tokens[0], @"Online");
    XCTAssertEqualObjects(tokens[1], @"Offline");

}

- (void)testTokenStringUpToLastLevel
{

    {
        NSString *input = @"Li";
        CSNFetchResult *result = [self.repository fetchItemsByString:input];
        XCTAssertEqual(result.items.count, 2);
        XCTAssertEqual(result.bottomLevel, 0);
        NSArray <NSString *> *names = [result tokenStringUpToBottomLevel];
        XCTAssertEqual(names.count, 1);
        XCTAssertEqualObjects(names[0], @"ListItem/");
    }

    {
        NSString *input = @"ListItem/o";
        CSNFetchResult *result = [self.repository fetchItemsByString:input];
        XCTAssertEqual(result.items.count, 2);
        NSArray <NSString *> *names = [result tokenStringUpToBottomLevel];
        XCTAssertEqual(names.count, 2);
        XCTAssertEqualObjects(names[0], @"ListItem/Offline");
        XCTAssertEqualObjects(names[1], @"ListItem/Online");
    }

}

- (void)testListUpItemsUsingStringZeroInput
{

    {
        NSString *input = @"";
        CSNFetchResult *result = [self.repository listUpItemsUsingString:input];
        XCTAssertEqual(result.items.count, 3);
        XCTAssertEqual(result.bottomLevel, 0);
        NSArray <NSString *> *names = [result tokenStringUpToBottomLevel];
        XCTAssertEqual(names.count, 2);
        XCTAssertEqualObjects(names[0], @"ListItem/");
        XCTAssertEqualObjects(names[1], @"StatusBar");
    }
}

- (void)testListUpItemsUsingStringStartWithOneLetter
{
    {
        NSString *input = @"L";
        CSNFetchResult *result = [self.repository listUpItemsUsingString:input];
        XCTAssertEqual(result.items.count, 2);
        XCTAssertEqual(result.bottomLevel, 0);
        NSArray <NSString *> *names = [result tokenStringUpToBottomLevel];
        XCTAssertEqual(names.count, 1);
        XCTAssertEqualObjects(names[0], @"ListItem/");
    }
}

- (void)testListUpItemsUsingStringTopLevel
{

    {
        NSString *input = @"ListItem/";
        CSNFetchResult *result = [self.repository listUpItemsUsingString:input];
        XCTAssertEqual(result.items.count, 2);

        XCTAssertTrue([result isTokenEndWithDelimeterAtBottomLevel]);

        NSArray <NSString *> *names = [result tokenStringUpToLevel:result.bottomLevel + 1 unique:YES];
        XCTAssertEqual(names.count, 2);
        XCTAssertEqualObjects(names[0], @"ListItem/Offline");
        XCTAssertEqualObjects(names[1], @"ListItem/Online");
    }
}

@end
