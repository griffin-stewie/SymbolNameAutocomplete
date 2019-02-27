//
//  CSNSuggestionsTableView.m
//  SymbolNameAutocomplete
//
//  Created by griffin-stewie on 2018/11/23.
//  Copyright © 2018 cyan-stivy.net. All rights reserved.
//

#import "CSNSuggestionsTableView.h"

@interface CSNSuggestionsTableView ( )
@property (nonatomic, strong) NSTrackingArea *trackingArea;
@end


@implementation CSNSuggestionsTableView

#pragma mark - NSTableView

- (void)reloadData
{
    [super reloadData];

    if (!self.window) {
        return;
    }

    [self reloadSelectionWithMouseLocationInWindow:self.window.mouseLocationOutsideOfEventStream];
}

#pragma mark - NSResponder

- (void)updateTrackingAreas
{
    if (self.trackingArea != nil) {
        [self removeTrackingArea:self.trackingArea];
    }

    self.trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingMouseMoved | NSTrackingActiveInActiveApp owner:self userInfo:nil];
    [self addTrackingArea:self.trackingArea];

    [super updateTrackingAreas];
}

- (void)mouseDown:(NSEvent *)event
{
    NSPoint convertedLocation = [self convertPoint:event.locationInWindow toView:nil];
    NSInteger row = [self rowAtPoint:convertedLocation];

    id <CSNSuggestionsTableViewDelegate> delegate = (id <CSNSuggestionsTableViewDelegate>)self.delegate;
    if (row >= 0 && [delegate respondsToSelector:@selector(tableView:didClickRow:)]) {
        [delegate tableView:self didClickRow:row];
    }
}

- (void)mouseMoved:(NSEvent *)event
{
    [self reloadSelectionWithMouseLocationInWindow:event.locationInWindow];
}

#pragma mark - Private

- (void)reloadSelectionWithMouseLocationInWindow:(NSPoint)mouseLocationInWindow
{
    NSPoint convertedLocation = [self convertPoint:mouseLocationInWindow toView:nil];
    NSInteger row = [self rowAtPoint:convertedLocation];

    if (row < 0 || self.selectedRow == row) {
        return;
    }

    BOOL shouldSelect = [self.delegate tableView:self shouldSelectRow:row] ?: YES;

    if (shouldSelect) {
        [self selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
        id <CSNSuggestionsTableViewDelegate> delegate = (id <CSNSuggestionsTableViewDelegate>)self.delegate;
        if ([delegate respondsToSelector:@selector(selectRowAtIndex:)]) {
            [delegate selectRowAtIndex:row];
        }
    }
}

@end
