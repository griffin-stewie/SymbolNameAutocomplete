//
//  CSNSymbolRepository.m
//  SymbolNameAutocomplete
//
//  Created by griffin-stewie on 2018/11/22.
//  Copyright © 2018 cyan-stivy.com. All rights reserved.
//

#import "CSNSymbolRepository.h"
#import "CSNSymbolMasterItem.h"
#import "CSNNameTokenizer.h"
#import "CSNFetchResult.h"
#import "MSDocumentData.h"
#import "MSSymbolMaster.h"

@interface CSNSymbolRepository ()

@property (nonatomic, copy) NSArray<CSNSymbolMasterItem *> *items;

@end


@implementation CSNSymbolRepository

- (instancetype)initWithDocumentData:(MSDocumentData *)docData
{
//    NSLog(@"👺 %s %@", __PRETTY_FUNCTION__, [docData.localSymbols debugDescription]);
    NSMutableArray *temp = [NSMutableArray array];
    for (MSSymbolMaster *master in docData.localSymbols) {
        [temp addObject:master.name];
    }
    return [self initWithNames:temp];
}

- (instancetype)initWithNames:(NSArray <NSString *> *)names
{
    self = [super init];
    if (self) {
        NSMutableArray *temp = [NSMutableArray array];
        for (NSString *name in names) {
            CSNSymbolMasterItem *item = [[CSNSymbolMasterItem alloc] initWithName:name];
            [temp addObject:item];
        }

        self.items = [temp copy];
    }
    return self;
}

- (CSNFetchResult *)fetchItemsByString:(NSString *)searchword
{
    CSNNameTokenizer *tokenizer = [[CSNNameTokenizer alloc] initWithString:searchword];
    NSInteger level = [tokenizer bottomLevel];
    if (level == NSNotFound) {
        NSLog(@"👺 %s level NSNotFound for '%@'", __PRETTY_FUNCTION__, [NSNumber numberWithInteger:level]);
        return nil;
    }

    NSMutableArray <CSNSymbolMasterItem *> *targetItems = [self.items copy];
    NSMutableArray <CSNSymbolMasterItem *> *filterdItems = [NSMutableArray array];

    for (NSInteger i = 0; i < tokenizer.count; i++) {
        [filterdItems removeAllObjects];
        BOOL isLastLevel = (i == tokenizer.count - 1);
        if (isLastLevel) {
            for (CSNSymbolMasterItem *item in targetItems) {
                NSString *name = [item tokenAtLevel:i];
                NSString *searchWordAtLevel = [tokenizer tokenAtLevel:i];
                if ([[name lowercaseString] hasPrefix:[searchWordAtLevel lowercaseString]]) {
                    [filterdItems addObject:item];
                }
            }
        } else {
            for (CSNSymbolMasterItem *item in targetItems) {
                NSString *name = [item tokenAtLevel:i];
                NSString *searchWordAtLevel = [tokenizer tokenAtLevel:i];
                if ([name isEqualToString:searchWordAtLevel]) {
                    [filterdItems addObject:item];
                }
            }
        }

        targetItems = [filterdItems mutableCopy];
    }

    if ([filterdItems count] == 0) {
        return nil;
    }

    return [[CSNFetchResult alloc] initWithItems:[filterdItems copy] tokenizer:tokenizer];
}

- (CSNFetchResult *)listUpItemsUsingString:(NSString *)word
{
    CSNNameTokenizer *tokenizer = [[CSNNameTokenizer alloc] initWithString:word];
    NSMutableArray <CSNSymbolMasterItem *> *targetItems = [self.items copy];
    NSMutableArray <CSNSymbolMasterItem *> *filterdItems = [NSMutableArray array];

    if (tokenizer.count == 0) {
        return [[CSNFetchResult alloc] initWithItems:targetItems tokenizer:tokenizer];
    }

    for (NSInteger i = 0; i < tokenizer.count; i++) {
        [filterdItems removeAllObjects];
        BOOL isLastLevel = (i == tokenizer.count - 1);
        if (isLastLevel) {
            for (CSNSymbolMasterItem *item in targetItems) {
                NSString *name = [item tokenAtLevel:i];
                NSString *searchWordAtLevel = [tokenizer tokenAtLevel:i];
                if ([searchWordAtLevel length] == 0) {
                    [filterdItems addObject:item];
                } else if ([[name lowercaseString] hasPrefix:[searchWordAtLevel lowercaseString]]) {
                    [filterdItems addObject:item];
                }
            }
        } else {
            for (CSNSymbolMasterItem *item in targetItems) {
                NSString *name = [item tokenAtLevel:i];
                NSString *searchWordAtLevel = [tokenizer tokenAtLevel:i];
                if ([name isEqualToString:searchWordAtLevel]) {
                    [filterdItems addObject:item];
                }
            }
        }

        targetItems = [filterdItems mutableCopy];
    }

    if ([tokenizer isEndWithDelimeterAtBottomLevel]) {
        for (CSNSymbolMasterItem *item in targetItems) {
            NSString *name = [item tokenAtLevel:[tokenizer bottomLevel] + 1];
            NSString *searchWordAtLevel = [tokenizer tokenAtLevel:[tokenizer bottomLevel] + 1];
            if ([name isEqualToString:searchWordAtLevel]) {
                [filterdItems addObject:item];
            }
        }
    }

    if ([filterdItems count] == 0) {
        return nil;
    }

    return [[CSNFetchResult alloc] initWithItems:[filterdItems copy] tokenizer:tokenizer];
}

- (NSArray <NSString *>*)fetchItemsByString:(NSString *)searchword atLevel:(NSUInteger)level
{
    return [self fetchItemsByString:searchword atLevel:level fazzy:YES];
}


#pragma mark - Private

- (NSArray <NSString *>*)fetchItemsByString:(NSString *)searchword atLevel:(NSUInteger)level fazzy:(BOOL)isFazzy
{
    NSArray <NSString *>*nameAtLevel = [self namesAtLevel:level unique:NO];

    NSPredicate *predicate = nil;
    if (isFazzy) {
        predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchword];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"SELF == %@", searchword];
    }

    return [nameAtLevel filteredArrayUsingPredicate:predicate];
}

- (NSArray <NSString *>*)namesAtLevel:(NSUInteger)level unique:(BOOL)unique
{
    NSMutableArray *namesAtLevel = [NSMutableArray array];

    for (CSNSymbolMasterItem *item in self.items) {
        NSString *name = [item tokenAtLevel:level];
        if (name != nil) {
            if (unique) {
                if ([namesAtLevel containsObject:name] == NO) {
                    [namesAtLevel addObject:name];
                }
            } else {
                [namesAtLevel addObject:name];
            }
        }
    }

    return [namesAtLevel copy];
}

@end
