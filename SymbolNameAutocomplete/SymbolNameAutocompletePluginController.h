//
//  SymbolNameAutocompletePluginController.h
//  SymbolNameAutocomplete
//
//  Created by griffin-stewie on 2018/11/22.
//  Copyright © 2018 cyan-stivy.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSCreateSymbolNamingSheet, MSDocumentData;

NS_ASSUME_NONNULL_BEGIN

@interface SymbolNameAutocompletePluginController : NSObject

@property (nonatomic, assign, getter=isEnabled) BOOL enabled;
@property (nonatomic, weak) MSCreateSymbolNamingSheet *namingSheet;
@property (nonatomic, weak) MSDocumentData *documentData;

+ (instancetype)sharedController;

@end

NS_ASSUME_NONNULL_END
