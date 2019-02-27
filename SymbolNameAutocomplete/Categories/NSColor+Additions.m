//
//  NSColor+Additions.m
//  SymbolNameAutocomplete
//
//  Created by griffin-stewie on 2018/11/23.
//  Copyright © 2018 cyan-stivy.net. All rights reserved.
//

#import "NSColor+Additions.h"

@implementation NSColor (Additions)

+ (NSColor *)csn_backgroundColor {
    return [self controlBackgroundColor];
}

+ (NSColor *)csn_selectionColor {
    if (@available(macOS 10.14, *)) {
        return [self controlAccentColor];
    } else {
        return [self selectedMenuItemColor];
    }
}

+ (NSColor *)csn_textColor {
    return [self controlTextColor];
}

@end
