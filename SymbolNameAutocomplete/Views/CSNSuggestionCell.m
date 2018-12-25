//
//  CSNSuggestionCell.m
//  SymbolNameAutocomplete
//
//  Created by griffin-stewie on 2018/11/23.
//  Copyright © 2018 cyan-stivy.com. All rights reserved.
//

#import "CSNSuggestionCell.h"
#import "NSColor+Additions.h"

static const CGFloat CSNSuggestionCellHeight = 32.0f;
static const CGFloat CSNSuggestionCellMargin = 8.0f;

@interface CSNSuggestionCell ()
@property (nonatomic, strong) NSTextField *suggeestionTextField;
@end


@implementation CSNSuggestionCell

+ (CGFloat)height
{
    return CSNSuggestionCellHeight;
}

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

#pragma mark - Initializers

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];

    if (!self) {
        return nil;
    }

    self.identifier = [[self class] reuseIdentifier];

    self.suggeestionTextField = [[NSTextField alloc] init];
    self.suggeestionTextField.bordered = NO;
    self.suggeestionTextField.drawsBackground = NO;
    self.suggeestionTextField.editable = NO;
    self.suggeestionTextField.selectable = NO;
    self.suggeestionTextField.usesSingleLineMode = YES;
    self.suggeestionTextField.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.suggeestionTextField.alignment = NSTextAlignmentLeft;
    self.suggeestionTextField.font = [NSFont systemFontOfSize:14.0];

    NSColor *textFieldTextColor = [NSColor csn_textColor];
    if (textFieldTextColor) {
        self.suggeestionTextField.textColor = textFieldTextColor;
    }

    [self addSubview:self.suggeestionTextField];

    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.suggeestionTextField.translatesAutoresizingMaskIntoConstraints = NO;

    NSArray *constrains = @[
                            [self.suggeestionTextField.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:CSNSuggestionCellMargin],
                            [self.suggeestionTextField.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant: -CSNSuggestionCellMargin],
                            [self.suggeestionTextField.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
                            ];

    [NSLayoutConstraint activateConstraints:constrains];

    return self;
}

#pragma mark - Properties

- (void)setSuggestion:(NSString *)suggestion
{
    _suggestion = [suggestion copy];
    self.suggeestionTextField.stringValue = _suggestion;
}

@end
