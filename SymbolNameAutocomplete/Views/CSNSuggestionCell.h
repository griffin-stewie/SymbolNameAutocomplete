//
//  CSNSuggestionCell.h
//  SymbolNameAutocomplete
//
//  Created by griffin-stewie on 2018/11/23.
//  Copyright © 2018 cyan-stivy.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSNSuggestionCell : NSTableCellView

@property (nonatomic, copy) NSString *suggestion;

+ (CGFloat)height;
+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
