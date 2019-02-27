//
//  CSNSuggestionController.h
//  SymbolNameAutocomplete
//
//  Created by griffin-stewie on 2018/11/22.
//  Copyright © 2018 cyan-stivy.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@class CSNSymbolRepository;

NS_ASSUME_NONNULL_BEGIN

@interface CSNSuggestionController : NSObject<NSTextFieldDelegate>

@property (nonatomic, strong) NSWindow *window;
@property (nonatomic, weak) id<NSTextFieldDelegate>delegate;
@property (nonatomic, weak) id<NSTextFieldDelegate>textFieldProxyDelegate;
@property (nonatomic, strong) CSNSymbolRepository *symbolRepository;

@end

NS_ASSUME_NONNULL_END
