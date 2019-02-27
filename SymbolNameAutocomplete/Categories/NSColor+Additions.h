//
//  NSColor+Additions.h
//  SymbolNameAutocomplete
//
//  Created by griffin-stewie on 2018/11/23.
//  Copyright © 2018 cyan-stivy.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSColor (Additions)

+ (NSColor *)csn_backgroundColor;
+ (NSColor *)csn_selectionColor;
+ (NSColor *)csn_textColor;

@end

NS_ASSUME_NONNULL_END
