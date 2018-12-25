//
//  CSNSymbolMasterItem.h
//  SymbolNameAutocomplete
//
//  Created by griffin-stewie on 2018/11/22.
//  Copyright © 2018 cyan-stivy.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSNSymbolMasterItem : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSUInteger tokenCount;

- (instancetype)initWithName:(NSString *)symbolName;

- (NSString *)tokenStringUpToLevel:(NSInteger)level;

- (NSArray <NSString *> *)tokensUpToLevel:(NSInteger)level;

- (NSString *)tokenAtLevel:(NSInteger)level;

@end

NS_ASSUME_NONNULL_END
