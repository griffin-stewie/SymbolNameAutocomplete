//
//  CSNSuggestionsTableView.h
//  SymbolNameAutocomplete
//
//  Created by griffin-stewie on 2018/11/23.
//  Copyright © 2018 cyan-stivy.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CSNSuggestionsTableViewDelegate;

@interface CSNSuggestionsTableView : NSTableView

@end

@protocol CSNSuggestionsTableViewDelegate <NSTableViewDelegate>
@optional

- (void)tableView:(NSTableView *)tableView didClickRow:(NSInteger)row;
- (void)selectRowAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
