//
//  CSNSuggestionController.m
//  SymbolNameAutocomplete
//
//  Created by griffin-stewie on 2018/11/22.
//  Copyright © 2018 cyan-stivy.net. All rights reserved.
//

#import "CSNSuggestionController.h"
#import "CSNFetchResult.h"
#import "CSNNameTokenizer.h"
#import "CSNSymbolRepository.h"
#import "CSNSuggestionsWindowController.h"

@interface CSNSuggestionController () <CSNSuggestionsWindowControllerDelegate>
@property (nonatomic, weak) NSText *fieldEditor;
@property (nonatomic, strong) CSNSuggestionsWindowController *windowController;
@property (nonatomic, assign) BOOL skipUpdatingFieldEditor;
@end

@implementation CSNSuggestionController

- (void)dealloc
{
    self.delegate = nil;
}

/* Update the field editor with a suggested string. The additional suggested characters are auto selected.
 */
- (void)updateFieldEditor:(NSText *)fieldEditor withSuggestion:(NSString *)suggestion
{
    if (suggestion == nil) {
        return ;
    }

    NSRange selection = NSMakeRange([fieldEditor selectedRange].location, [suggestion length]);
    [fieldEditor setString:suggestion];
    [fieldEditor setSelectedRange:selection];
}

- (void)updateSuggestionsFromControl:(NSControl *)control {
//    NSLog(@"👺 %s %@", __PRETTY_FUNCTION__, [control debugDescription]);
    self.fieldEditor = [self.window fieldEditor:NO forObject:control];
//    NSLog(@"👺 %s %@", __PRETTY_FUNCTION__, [self.fieldEditor debugDescription]);
    if (self.fieldEditor) {
        // Only use the text up to the caret position
        NSRange selection = [self.fieldEditor selectedRange];
        NSString *text = [[self.fieldEditor string] substringToIndex:selection.location];
//        NSLog(@"👺 %s %@ '%@'", __PRETTY_FUNCTION__, NSStringFromRange(selection), text);

        if (text == nil || [text length] == 0) {
//            NSLog(@"👺 %s search text is blank or nil", __PRETTY_FUNCTION__);
            self.skipUpdatingFieldEditor = NO;
            return ;
        }

        CSNFetchResult *result = [self.symbolRepository fetchItemsByString:text];

        if (result == nil) {
//            NSLog(@"👺 %s not matched any name", __PRETTY_FUNCTION__);
            [self.windowController cancelSuggestions];
            self.skipUpdatingFieldEditor = NO;
            return ;
        }

        NSArray <NSString *> *names = [result tokenStringUpToBottomLevel];

//        for (NSString *name in names) {
//            NSLog(@"👺 %s related name is '%@'", __PRETTY_FUNCTION__, name);
//        }

        if (!self.skipUpdatingFieldEditor) {
            [self.windowController presentWithSuggestions:names positioningTextView:(NSView *)control];
        } else {
//            NSLog(@"👺 %s cancel suggestions cause skipUpdatingFieldEditor is '%@'", __PRETTY_FUNCTION__, [NSNumber numberWithBool:self.skipUpdatingFieldEditor]);
            [self.windowController cancelSuggestions];
        }

        self.skipUpdatingFieldEditor = NO;
    }
}

- (NSRange)selectedRangeFromFieldEditor
{
    if (self.fieldEditor != nil) {
        // Only use the text up to the caret position
        return [self.fieldEditor selectedRange];
    } else {
        return NSMakeRange(0, 0);
    }
}

- (void)deleteSuggestedTextFromFieldEditor
{
    if (self.fieldEditor == nil) {
        return ;
    }
    NSRange selection = [self.fieldEditor selectedRange];
    NSString *text = [[self.fieldEditor string] substringToIndex:selection.location];
    [self.fieldEditor setString:text];
}

#pragma mark - CSNSuggestionWindowControllerDelegate

- (void)suggestionWindowController:(CSNSuggestionsWindowController *)suggestionWindowController didHighlightSuggestion:(NSString *)suggestion
{
//    NSLog(@"👺 %s update TextField with '%@'", __PRETTY_FUNCTION__, suggestion);
    [self updateFieldEditor:self.fieldEditor withSuggestion:suggestion];
}

- (void)suggestionWindowController:(CSNSuggestionsWindowController *)suggestionsWindowController didSelectSuggestion:(NSString *)suggestion
{
    [self updateFieldEditor:self.fieldEditor withSuggestion:suggestion];
    NSRange selection = NSMakeRange([self.fieldEditor string].length, 0);
    [self.fieldEditor setSelectedRange:selection];
    [self.windowController cancelSuggestions];
}

#pragma mark -
#pragma mark Delegate

- (void)controlTextDidBeginEditing:(NSNotification *)notification
{
//    NSLog(@"👺 %s %@", __PRETTY_FUNCTION__, [notification debugDescription]);

    if (!self.windowController) {
        self.windowController = [[CSNSuggestionsWindowController alloc] init];
        self.windowController.delegate = self;
    }

    self.fieldEditor = [self.window fieldEditor:NO forObject:notification.object];

    if ([_textFieldProxyDelegate respondsToSelector:@selector(controlTextDidBeginEditing:)]) {
        [_textFieldProxyDelegate controlTextDidBeginEditing:notification];
    }
}

- (void)controlTextDidChange:(NSNotification *)notification
{
//    NSLog(@"👺 %s %@", __PRETTY_FUNCTION__, [notification debugDescription]);
    [self updateSuggestionsFromControl:notification.object];
    
    if ([_textFieldProxyDelegate respondsToSelector:@selector(controlTextDidChange:)]) {
        [_textFieldProxyDelegate controlTextDidChange:notification];
    }
}

- (void)controlTextDidEndEditing:(NSNotification *)notification
{
//    NSLog(@"👺 %s %@", __PRETTY_FUNCTION__, [notification debugDescription]);

    [self.windowController cancelSuggestions];
    self.windowController = nil;

    if ([_textFieldProxyDelegate respondsToSelector:@selector(controlTextDidEndEditing:)]) {
        [_textFieldProxyDelegate controlTextDidEndEditing:notification];
    }
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector
{
//    NSLog(@"👺 %s selector is '%@'", __PRETTY_FUNCTION__, NSStringFromSelector(commandSelector));
    if (commandSelector == @selector(moveUp:)) {
        // Move up in the suggested selections list
        [self.windowController moveUp:textView];
        return YES;
    }

    if (commandSelector == @selector(moveDown:)) {
        // shows all possible suggestions if suggestions list is not visible
        if ([self.windowController.window isVisible] == NO) {
            if (self.fieldEditor != nil) {
                NSString *text = [self.fieldEditor string];
                CSNFetchResult *result = [self.symbolRepository listUpItemsUsingString:text];
                NSArray <NSString *> *suggestions = nil;
                if ([result isTokenEndWithDelimeterAtBottomLevel]) {
                    suggestions = [result tokenStringUpToLevel:result.bottomLevel + 1 unique:YES];
                } else {
                    suggestions = [result tokenStringUpToBottomLevel];
                }

                if ([suggestions count] > 0) {
                    [self.windowController presentWithSuggestions:suggestions positioningTextView:control];
                    return YES;
                }
            }
        }

        // Move down in the suggested selections list
        [self.windowController moveDown:textView];
        return YES;
    }

    if (commandSelector == @selector(deleteForward:) || commandSelector == @selector(deleteBackward:)) {
        /* The user is deleting the highlighted portion of the suggestion or more. Return NO so that the field editor performs the deletion. The field editor will then call -controlTextDidChange:. We don't want to provide a new set of suggestions as that will put back the characters the user just deleted. Instead, set skipNextSuggestion to YES which will cause -controlTextDidChange: to cancel the suggestions window. (see -controlTextDidChange: above)
         */

        if (self.fieldEditor != nil) {
            NSRange selection = [self.fieldEditor selectedRange];
            NSString *text = [[self.fieldEditor string] substringToIndex:selection.location];
//            NSLog(@"👺 %s %@ '%@'", __PRETTY_FUNCTION__, NSStringFromRange(selection), text);
            if ([text length] > 0) {
                self.skipUpdatingFieldEditor = YES;
            } else {
                self.skipUpdatingFieldEditor = NO;
            }
        }


        return NO;
    }

    // `ESC` key
    if (commandSelector == @selector(cancelOperation:)) {
        // hide suggestions and remove suggeestion string if sugessions is visible.
        if ([self.windowController.window isVisible]) {
            [self deleteSuggestedTextFromFieldEditor];
            [self.windowController cancelSuggestions];
            return YES;
        } else {
            return NO;
        }
    }

    if (commandSelector == @selector(complete:)) {
        // The user has pressed the key combination for auto completion. AppKit has a built in auto completion. By overriding this command we prevent AppKit's auto completion and can respond to the user's intention by showing or cancelling our custom suggestions window.
        if ([self.windowController.window isVisible]) {
            [self.windowController cancelSuggestions];
        } else {
            [self updateSuggestionsFromControl:control];
        }

        return YES;
    }

    if (
        commandSelector == @selector(insertTab:) ||
        commandSelector == @selector(insertNewline:) ||
        commandSelector == @selector(insertNewlineIgnoringFieldEditor:) ||
        commandSelector == @selector(insertLineBreak:)
        ) {

        if ([self.windowController.window isVisible]) {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.windowController performSelector:commandSelector withObject:textView];
            #pragma clang diagnostic pop

            return YES;
        }

        if (self.fieldEditor) {
            NSRange selection = [self.fieldEditor selectedRange];
            NSString *text = [[self.fieldEditor string] substringToIndex:selection.location];
            NSLog(@"👺 %s %@ '%@'", __PRETTY_FUNCTION__, NSStringFromRange(selection), text);

            if (selection.length == 0) {
                // act default behavior if selection is none.
                return NO;
            } else {
                // let caret moves to the end of line if selection is exists.
                NSRange selection = NSMakeRange([self.fieldEditor string].length, 0);
                [self.fieldEditor setSelectedRange:selection];
                return YES;
            }
        }
        return YES;
    }

    // This is a command that we don't specifically handle, let the field editor do the appropriate thing.
    return NO;
}

#pragma mark -
#pragma mark Method Forwarding

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector]) {
        return YES;
    }
    
    if ([self.textFieldProxyDelegate respondsToSelector:aSelector]) {
        return YES;
    }
    
    
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if (!signature) {
        if ([_textFieldProxyDelegate respondsToSelector:selector]) {
            return [(NSObject *)_textFieldProxyDelegate methodSignatureForSelector:selector];
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation*)invocation
{
    if ([_textFieldProxyDelegate respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:_textFieldProxyDelegate];
    }
}

@end
