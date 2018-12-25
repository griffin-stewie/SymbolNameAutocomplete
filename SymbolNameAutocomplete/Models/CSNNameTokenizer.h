//
//  CSNNameTokenizer.h
//  SymbolNameAutocomplete
//
//  Created by griffin-stewie on 2018/11/22.
//  Copyright © 2018 cyan-stivy.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSNNameTokenizer : NSObject

@property (nonatomic, assign) NSUInteger count;

+ (NSInteger)levelWithString:(NSString *)name;

- (instancetype)initWithString:(NSString *)name;

- (NSInteger)levelWithString:(NSString *)name;

- (NSInteger)bottomLevel;

- (NSString *)tokenStringUpToLevel:(NSInteger)level;

- (NSArray <NSString *> *)tokensUpToLevel:(NSInteger)level;

- (NSString *)tokenAtLevel:(NSInteger)level;

- (BOOL)isEndWithDelimeterAtLevel:(NSInteger)level;

- (BOOL)isEndWithDelimeterAtBottomLevel;

@end

NS_ASSUME_NONNULL_END
