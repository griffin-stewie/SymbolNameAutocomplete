//
//  CSNRowView.m
//  SymbolNameAutocomplete
//
//  Created by griffin-stewie on 2018/11/23.
//  Copyright © 2018 cyan-stivy.com. All rights reserved.
//

#import "CSNRowView.h"
#import "NSColor+Additions.h"

@implementation CSNRowView

- (NSBackgroundStyle)interiorBackgroundStyle
{
    return self.isSelected ? NSBackgroundStyleEmphasized : NSBackgroundStyleNormal;
}

- (void)drawSelectionInRect:(NSRect)dirtyRect
{
    [[NSColor csn_selectionColor] setFill];

    [[NSBezierPath bezierPathWithRect:self.bounds] fill];
}
@end
