//
//  CSNNameTokenizerTests.m
//  SymbolNameAutocompleteTests
//
//  Created by griffin-stewie on 2018/11/25.
//  Copyright © 2018 cyan-stivy.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CSNNameTokenizer.h"

@interface CSNNameTokenizerTests : XCTestCase

@end

@implementation CSNNameTokenizerTests

- (void)setUp
{
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testSymbolNameSeparatedWithSpace
{
    {
        CSNNameTokenizer *tokenizer = [[CSNNameTokenizer alloc] initWithString:@"ListItem / Online"];
        XCTAssertEqual(tokenizer.count, 2);
        XCTAssertFalse([tokenizer isEndWithDelimeterAtBottomLevel]);
        NSString *firstToken = [tokenizer tokenAtLevel: 0];
        XCTAssertEqualObjects(firstToken, @"ListItem / ");
        NSString *secondToken = [tokenizer tokenAtLevel: 1];
        XCTAssertEqualObjects(secondToken, @"Online");
    }

    {
        CSNNameTokenizer *tokenizer = [[CSNNameTokenizer alloc] initWithString:@"ListItem / Online / button"];
        XCTAssertEqual(tokenizer.count, 3);
        XCTAssertFalse([tokenizer isEndWithDelimeterAtBottomLevel]);
        NSString *firstToken = [tokenizer tokenAtLevel: 0];
        XCTAssertEqualObjects(firstToken, @"ListItem / ");
        NSString *secondToken = [tokenizer tokenAtLevel: 1];
        XCTAssertEqualObjects(secondToken, @"Online / ");
        NSString *thirdToken = [tokenizer tokenAtLevel: 2];
        XCTAssertEqualObjects(thirdToken, @"button");
    }

}

- (void)testSymbolNameSeparatedWithoutSpace
{
    {
        CSNNameTokenizer *tokenizer = [[CSNNameTokenizer alloc] initWithString:@"ListItem/Online"];
        XCTAssertEqual(tokenizer.count, 2);
        XCTAssertFalse([tokenizer isEndWithDelimeterAtBottomLevel]);
        NSString *firstToken = [tokenizer tokenAtLevel: 0];
        XCTAssertEqualObjects(firstToken, @"ListItem/");
        NSString *secondToken = [tokenizer tokenAtLevel: 1];
        XCTAssertEqualObjects(secondToken, @"Online");
    }

    {
        CSNNameTokenizer *tokenizer = [[CSNNameTokenizer alloc] initWithString:@"ListItem/Online/button"];
        XCTAssertEqual(tokenizer.count, 3);
        XCTAssertFalse([tokenizer isEndWithDelimeterAtBottomLevel]);
        NSString *firstToken = [tokenizer tokenAtLevel: 0];
        XCTAssertEqualObjects(firstToken, @"ListItem/");
        NSString *secondToken = [tokenizer tokenAtLevel: 1];
        XCTAssertEqualObjects(secondToken, @"Online/");
        NSString *thirdToken = [tokenizer tokenAtLevel: 2];
        XCTAssertEqualObjects(thirdToken, @"button");
    }
}

- (void)testAtFirstLevel
{
    {
        CSNNameTokenizer *tokenizer = [[CSNNameTokenizer alloc] initWithString:@"ListItem/"];
        XCTAssertEqual(tokenizer.count, 1);

        XCTAssertTrue([tokenizer isEndWithDelimeterAtBottomLevel]);

        NSString *firstToken = [tokenizer tokenAtLevel: 0];
        XCTAssertEqualObjects(firstToken, @"ListItem/");
        NSString *secondToken = [tokenizer tokenAtLevel: 1];
        XCTAssertNil(secondToken);
    }
}


@end
