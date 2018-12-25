//
//  CSNSymbolMasterItem.m
//  SymbolNameAutocomplete
//
//  Created by griffin-stewie on 2018/11/22.
//  Copyright © 2018 cyan-stivy.com. All rights reserved.
//

#import "CSNSymbolMasterItem.h"
#import "CSNNameTokenizer.h"

@interface CSNSymbolMasterItem ( )
@property (nonatomic, strong) CSNNameTokenizer *tokenizer;
@end

@implementation CSNSymbolMasterItem

- (instancetype)initWithName:(NSString *)symbolName
{
    self = [super init];
    if (self) {
//        NSLog(@"👺 %s %@", __PRETTY_FUNCTION__, [symbolName debugDescription]);
        self.tokenizer = [[CSNNameTokenizer alloc] initWithString:symbolName];
    }
    return self;
}

- (NSUInteger)count
{
    return self.tokenizer.count;
}

- (NSString *)tokenStringUpToLevel:(NSInteger)level
{
    return [self.tokenizer tokenStringUpToLevel:level];
}

- (NSArray <NSString *> *)tokensUpToLevel:(NSInteger)level
{
    return [self.tokenizer tokensUpToLevel:level];
}

- (NSString *)tokenAtLevel:(NSInteger)level
{
    return [self.tokenizer tokenAtLevel:level];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, %@>",
                NSStringFromClass([self class]),
                self,
                self.tokenizer
            ];
}
@end

