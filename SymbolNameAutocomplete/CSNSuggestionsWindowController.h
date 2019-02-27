//
//  CSNSuggestionsWindowController.h
//  SymbolNameAutocomplete
//
//  Created by griffin-stewie on 2018/11/23.
//  Copyright © 2018 cyan-stivy.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CSNSuggestionsWindowControllerDelegate;

@interface CSNSuggestionsWindowController : NSWindowController

@property (nonatomic, weak) id <CSNSuggestionsWindowControllerDelegate> delegate;

- (void)presentWithSuggestions:(NSArray<NSString *> *)suggestions positioningTextView:(NSView *)positioningTextView;
- (void)cancelSuggestions;

@end

@protocol CSNSuggestionsWindowControllerDelegate <NSObject>

- (void)suggestionWindowController:(CSNSuggestionsWindowController *)suggestionWindowController didHighlightSuggestion:(NSString *)suggestion;
- (void)suggestionWindowController:(CSNSuggestionsWindowController *)suggestionWindowController didSelectSuggestion:(NSString *)suggestion;

@end

NS_ASSUME_NONNULL_END
