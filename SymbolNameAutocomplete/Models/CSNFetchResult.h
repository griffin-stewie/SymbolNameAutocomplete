//
//  CSNFetchResult.h
//  SymbolNameAutocomplete
//
//  Created by griffin-stewie on 2018/11/23.
//  Copyright © 2018 cyan-stivy.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSNSymbolMasterItem;
@class CSNNameTokenizer;

NS_ASSUME_NONNULL_BEGIN

@interface CSNFetchResult : NSObject
@property (nonatomic, copy, readonly) NSArray <CSNSymbolMasterItem *> *items;
@property (nonatomic, assign, readonly) NSUInteger bottomLevel;

- (instancetype)initWithItems:(NSArray <CSNSymbolMasterItem *>*)items tokenizer:(CSNNameTokenizer *)tokenizer;

- (NSArray <NSString *> *)tokens;
- (NSArray <NSString *> *)tokensAtBottomLevel;
- (NSArray <NSString *> *)tokensAtLevel:(NSInteger) level unique:(BOOL)unique;
- (NSArray <NSString *> *)tokenStringUpToBottomLevel;
- (NSArray <NSString *> *)tokenStringUpToBottomLevelUniquing:(BOOL)unique;
- (NSArray <NSString *> *)tokenStringUpToLevel:(NSInteger)level unique:(BOOL)unique;

- (BOOL)isTokenEndWithDelimeterAtBottomLevel;

@end


NS_ASSUME_NONNULL_END
