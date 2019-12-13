//
//  CSNNameTokenizer.m
//  SymbolNameAutocomplete
//
//  Created by griffin-stewie on 2018/11/22.
//  Copyright © 2018 cyan-stivy.net. All rights reserved.
//

#import "CSNNameTokenizer.h"

@interface CSNNameTokenizer ()
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray<NSString *> *tokens;
@end

@implementation CSNNameTokenizer

+ (NSInteger)levelWithString:(NSString *)name
{
    NSUInteger count = [[self tokenize:name] count];
    if (count == 0) {
        return NSNotFound;
    }
    return count - 1;
}

- (instancetype)initWithString:(NSString *) name
{
    self = [super init];
    if (self) {
        self.name = name;
        self.tokens = [[self class] tokenize:_name];
    }
    return self;
}

- (NSUInteger)count
{
    return self.tokens.count;
}

- (NSInteger)levelWithString:(NSString *)name
{
    for (NSInteger i = 0; i < self.tokens.count; i++) {
        NSString *token = self.tokens[i];
        if ([token isEqualToString:name]) {
            return i;
        }
    }

    return NSNotFound;
}

- (NSInteger)bottomLevel
{
    if (self.count == 0) {
        return NSNotFound;
    }
    return self.count - 1;
}

- (NSString *)tokenStringUpToLevel:(NSInteger)level
{
    return [[self tokensUpToLevel:level] componentsJoinedByString:@""];
}

- (NSArray <NSString *> *)tokensUpToLevel:(NSInteger)level
{
    if (self.tokens.count <= level) {
        return nil;
    }

    NSMutableArray <NSString *> *tokens = [NSMutableArray array];
    NSInteger upto = MIN((NSInteger)self.tokens.count - 1, level) + 1; 
    for (NSInteger i = 0; i < upto; i++) {
        [tokens addObject:self.tokens[i]];
    }

    return [tokens copy];
}

- (NSString *)tokenAtLevel:(NSInteger) level
{
    if (self.tokens.count <= level) {
        return nil;
    }

    return self.tokens[level];
}

- (BOOL)isEndWithDelimeterAtLevel:(NSInteger)level
{
    NSString *token = [self tokenAtLevel:level];
    if (token == nil) {
        return NO;
    }

    if ([token hasSuffix:@"/"]) {
        return YES;
    }

    if ([token hasSuffix:@"/ "]) {
        return YES;
    }

    return NO;
}

- (BOOL)isEndWithDelimeterAtBottomLevel
{
    return [self isEndWithDelimeterAtLevel:[self bottomLevel]];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, tokens: %@>",
            NSStringFromClass([self class]),
            self,
            self.tokens
            ];
}

#pragma mark - Private

+ (NSArray<NSString *> *)tokenize: (NSString *)string
{
    NSMutableArray<NSString *> *tokens = [NSMutableArray array];
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [characterSet removeCharactersInString:@"/"];
    NSScanner *scanner = [NSScanner scannerWithString:string];
    NSString *name = nil;
    NSString *delimiter = nil;
    while (![scanner isAtEnd]) {
        [scanner scanUpToString:@"/" intoString:&name];
//        NSLog(@"`%@`", name);
        if ([scanner scanUpToCharactersFromSet:characterSet intoString:&delimiter]) {
//            NSLog(@"`%@`", delimiter);
            [tokens addObject:[name stringByAppendingString:delimiter]];
        } else {
            [tokens addObject:name];
        }
    }
    return [tokens copy];
}

@end
