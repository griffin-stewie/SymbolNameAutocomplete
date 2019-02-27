//
//  CSNSuggestionsWindowController.m
//  SymbolNameAutocomplete
//
//  Created by griffin-stewie on 2018/11/23.
//  Copyright © 2018 cyan-stivy.net. All rights reserved.
//

#import "CSNSuggestionsWindowController.h"
#import "CSNSuggestionsTableView.h"
#import "NSColor+Additions.h"
#import "CSNSuggestionCell.h"
#import "CSNRowView.h"

static const CGFloat CSNSuggestionWindowControllerContentViewCornerRadius = 3.0f;
static const CGFloat CSNSuggestionWindowControllerMargin = 8.0f;
static const NSSize CSNSuggestionWindowControllerMaximumWindowSize = {.width = 190.0f, .height = 208.0f};

@interface CSNSuggestionsWindowController () <NSTableViewDataSource, NSTableViewDelegate, CSNSuggestionsTableViewDelegate>
@property (nonatomic, copy) NSArray<NSString *> *suggestions;
@property (nonatomic, strong) CSNSuggestionsTableView *tableView;
@end

@implementation CSNSuggestionsWindowController

- (instancetype)init
{
    self = [super initWithWindow:nil];
    if (!self) {
        return nil;
    }

    NSView *contentView = [[NSView alloc] init];
    contentView.wantsLayer = YES;
    contentView.layer.cornerRadius = CSNSuggestionWindowControllerContentViewCornerRadius;

    self.tableView = [[CSNSuggestionsTableView alloc] init];
    self.tableView.headerView = nil;
    self.tableView.intercellSpacing = NSZeroSize;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsEmptySelection = NO;

    NSColor *tableViewBackgroundColor = [NSColor csn_backgroundColor];
    if (tableViewBackgroundColor) {
        self.tableView.backgroundColor = tableViewBackgroundColor;
    }

    NSScrollView *scrollView = [[NSScrollView alloc] init];
    scrollView.documentView = self.tableView;

    [contentView addSubview:scrollView];

    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint activateConstraints:@[
                                              [scrollView.topAnchor constraintEqualToAnchor:contentView.topAnchor],
                                              [scrollView.leftAnchor constraintEqualToAnchor:contentView.leftAnchor],
                                              [scrollView.rightAnchor constraintEqualToAnchor:contentView.rightAnchor],
                                              [scrollView.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor]
                                              ]];

    NSTableColumn *column = [[NSTableColumn alloc] init];
    column.resizingMask = NSTableColumnAutoresizingMask;
    [self.tableView addTableColumn:column];

    NSWindow *window = [[NSWindow alloc] initWithContentRect:NSZeroRect styleMask:NSWindowStyleMaskBorderless backing:NSBackingStoreBuffered defer:NO];
    window.titleVisibility = NSWindowTitleHidden;
    window.hasShadow = YES;
    window.opaque = NO;
    window.backgroundColor = [NSColor clearColor];
    window.contentView = contentView;

    self.window = window;

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.delegate = nil;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

#pragma mark - Public

- (void)presentWithSuggestions:(NSArray<NSString *> *)suggestions positioningTextView:(NSView *)positioningTextView
{
    self.suggestions = suggestions;

    [self.tableView reloadData];

    if (![self adjustFrameWithPositioningTextView:positioningTextView]) {
        return;
    }

    if (self.window.isVisible == NO) {
        [positioningTextView.window addChildWindow:self.window ordered:NSWindowAbove];
        positioningTextView.postsFrameChangedNotifications = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(positioningTextViewFrameDidChange:)
                                                     name:NSViewFrameDidChangeNotification
                                                   object:positioningTextView];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(parentWindowDidResignKey:)
                                                     name:NSWindowDidResignKeyNotification
                                                   object:positioningTextView.window];
    }

    [self selectRowAtIndex:0];
}

- (void)cancelSuggestions
{
    if (self.window.isVisible == NO) {
        return;
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self.window.parentWindow removeChildWindow:self.window];
    [self.window orderOut:nil];
}

- (BOOL)adjustFrameWithPositioningTextView:(NSView *)positioningTextView
{
    if (self.window == nil || positioningTextView.superview == nil || positioningTextView.window == nil) {
        return NO;
    }

    CGFloat windowHeight = MIN(self.suggestions.count * CSNSuggestionCell.height, CSNSuggestionWindowControllerMaximumWindowSize.height);

    NSRect positioningTextViewRect = positioningTextView.frame;
    NSRect rect = [positioningTextView.window convertRectToScreen:positioningTextViewRect];

    rect.origin.y = rect.origin.y - windowHeight - CSNSuggestionWindowControllerMargin;
    rect.size.width = positioningTextView.frame.size.width;
    rect.size.height = windowHeight;

    [self.window setFrame:rect display:NO];

    return YES;
}

- (void)selectRowAtIndex:(NSInteger)index
{
    if (self.suggestions.count == 0) {
        return;
    }

    NSInteger adjustedIndex = MAX(0, MIN(index, self.suggestions.count - 1));

    [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:adjustedIndex] byExtendingSelection:NO];
    [self.tableView scrollRowToVisible:adjustedIndex];
    [self.delegate suggestionWindowController:self didHighlightSuggestion:self.suggestions[adjustedIndex]];
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.suggestions.count;
}

#pragma mark - ZPLFocusTableViewDelegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    CSNSuggestionCell *cell = [tableView makeViewWithIdentifier:[CSNSuggestionCell reuseIdentifier] owner:self];
    if (!cell) {
        cell = [[CSNSuggestionCell alloc] init];
    }

    cell.suggestion = self.suggestions[row];

    return cell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return [CSNSuggestionCell height];
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row
{
    return [[CSNRowView alloc] init];
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    return YES;
}

- (void)tableView:(NSTableView *)tableView didClickRow:(NSInteger)row
{
    [self.delegate suggestionWindowController:self didSelectSuggestion:self.suggestions[row]];
}

#pragma mark - Notifications

- (void)positioningTextViewFrameDidChange:(NSNotification *)notification
{
    NSTextView *positioningTextView = notification.object;
    if (!positioningTextView) {
        return;
    }

    [self adjustFrameWithPositioningTextView:positioningTextView];
}

- (void)parentWindowDidResignKey:(NSNotification *)notification
{
    [self cancelSuggestions];
}

#pragma mark - Keyboard Tracking

/* move the selection up and send action.
 */
- (void)moveUp:(id)sender
{
    NSInteger row = MAX(self.tableView.selectedRow - 1, 0);
    [self selectRowAtIndex:row];
}

/* move the selection down and send action.
 */
- (void)moveDown:(id)sender
{
    NSInteger lastRow = self.suggestions.count - 1;
    NSInteger row = MIN(self.tableView.selectedRow + 1, lastRow);
    [self selectRowAtIndex:row];
}

- (void)insertTab:(id)sender
{
    [self.delegate suggestionWindowController:self didSelectSuggestion:self.suggestions[self.tableView.selectedRow]];
}

- (void)insertNewline:(id)sender
{
    [self.delegate suggestionWindowController:self didSelectSuggestion:self.suggestions[self.tableView.selectedRow]];
}

- (void)insertNewlineIgnoringFieldEditor:(id)sender
{
    [self.delegate suggestionWindowController:self didSelectSuggestion:self.suggestions[self.tableView.selectedRow]];
}

- (void)insertLineBreak:(id)sender
{
    [self.delegate suggestionWindowController:self didSelectSuggestion:self.suggestions[self.tableView.selectedRow]];
}

@end
