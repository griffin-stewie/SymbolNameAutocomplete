//
//  CSNSymbolRepository.h
//  SymbolNameAutocomplete
//
//  Created by griffin-stewie on 2018/11/22.
//  Copyright © 2018 cyan-stivy.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSNFetchResult, CSNSymbolMasterItem;
@class MSDocumentData;

NS_ASSUME_NONNULL_BEGIN

@interface CSNSymbolRepository : NSObject

- (instancetype)initWithDocumentData:(MSDocumentData *)docData;
- (instancetype)initWithNames:(NSArray <NSString *>*)names;

- (CSNFetchResult *)fetchItemsByString:(NSString *)searchword;
- (CSNFetchResult *)listUpItemsUsingString:(NSString *)word;
- (NSArray <NSString *>*)fetchItemsByString:(NSString *)searchword atLevel:(NSUInteger)level;

@end
NS_ASSUME_NONNULL_END
