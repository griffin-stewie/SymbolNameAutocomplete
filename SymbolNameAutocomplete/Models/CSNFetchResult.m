//
//  CSNFetchResult.m
//  SymbolNameAutocomplete
//
//  Created by griffin-stewie on 2018/11/23.
//  Copyright © 2018 cyan-stivy.net. All rights reserved.
//

#import "CSNFetchResult.h"
#import "CSNSymbolMasterItem.h"
#import "CSNNameTokenizer.h"

@interface CSNFetchResult ()

@property (nonatomic, copy, readwrite) NSArray <CSNSymbolMasterItem *> *items;
@property (nonatomic, strong) CSNNameTokenizer *tokenizer;

@end


@implementation CSNFetchResult

- (instancetype)initWithItems:(NSArray <CSNSymbolMasterItem *>*)items tokenizer:(CSNNameTokenizer *)tokenizer
{
    self = [super init];
    if (self) {
        self.items = items;
        self.tokenizer = tokenizer;
    }
    return self;
}

- (BOOL)isTokenEndWithDelimeterAtBottomLevel
{
    return [self.tokenizer isEndWithDelimeterAtBottomLevel];
}

- (NSUInteger)bottomLevel
{
    if (self.tokenizer.count == 0) {
        return 0;
    }
    return self.tokenizer.count - 1;
}

- (NSArray <NSString *> *)tokens
{
    NSMutableArray <NSString *> *tokens = [NSMutableArray array];

    for (CSNSymbolMasterItem *item in self.items) {
        [tokens addObject:[item name]];
    }

    return [tokens copy];
}

- (NSArray <NSString *> *)tokensAtBottomLevel
{
    return [self tokensAtLevel:self.bottomLevel unique:YES];
}

- (NSArray <NSString *> *)tokensAtLevel:(NSInteger) level unique:(BOOL)unique
{
    NSMutableArray <NSString *> *tokens = [NSMutableArray array];

    for (CSNSymbolMasterItem *item in self.items) {
        NSString *token = [item tokenAtLevel:level];
        if (unique) {
            if (![tokens containsObject:token]) {
                [tokens addObject:token];
            }
        } else {
            [tokens addObject:token];
        }
    }

    return [tokens copy];
}

- (NSArray <NSString *> *)tokenStringUpToBottomLevel
{
    return [self tokenStringUpToLevel:self.bottomLevel];
}

- (NSArray <NSString *> *)tokenStringUpToBottomLevelUniquing:(BOOL)unique
{
    return [self tokenStringUpToLevel:self.bottomLevel unique:unique];
}

- (NSArray <NSString *> *)tokenStringUpToLevel:(NSInteger) level
{
    return [self tokenStringUpToLevel:level unique:YES];
}

- (NSArray <NSString *> *)tokenStringUpToLevel:(NSInteger)level unique:(BOOL)unique
{
    NSMutableArray <NSString *> *tokens = [NSMutableArray array];

    for (CSNSymbolMasterItem *item in self.items) {
        NSString *string = [item tokenStringUpToLevel:level];
        if (unique) {
            if (![tokens containsObject:string]) {
                [tokens addObject:string];
            }
        } else {
            [tokens addObject:string];
        }

    }

    NSStringCompareOptions compareOptions = (NSNumericSearch | NSCaseInsensitiveSearch);
    [tokens sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2 options:compareOptions];
    }];

    return [tokens copy];
}

@end
