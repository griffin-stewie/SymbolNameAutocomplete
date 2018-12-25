//
//  SymbolNameAutocompletePluginController.m
//  SymbolNameAutocomplete
//
//  Created by griffin-stewie on 2018/11/22.
//  Copyright © 2018 cyan-stivy.com. All rights reserved.
//

#import "SymbolNameAutocompletePluginController.h"
#import "CSNSuggestionController.h"
#import "CSNSymbolRepository.h"
#import "MSCreateSymbolNamingSheet.h"
#import "MSDocumentData.h"

@interface SymbolNameAutocompletePluginController ()

@property (nonatomic, strong) CSNSuggestionController *suggestionController;

@end

@implementation SymbolNameAutocompletePluginController

#pragma mark - Singleton

+ (instancetype)sharedController
{
    static dispatch_once_t once;
    static id _sharedInstance = nil;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

#pragma mark - Properties

- (void)setEnabled:(BOOL)enabled
{
    if (_enabled == enabled) {
        return;
    }
    
    _enabled = enabled;
    
    if (enabled) {
        self.suggestionController = [[CSNSuggestionController alloc] init];
    } else {
        self.suggestionController = nil;
    }
}

- (void)setNamingSheet:(MSCreateSymbolNamingSheet *)sheet
{
    if (_namingSheet == sheet) {
        return ;
    }
    
    _namingSheet = sheet;
    
//    NSLog(@"%s %@", __PRETTY_FUNCTION__, @"setNamingSheet is Called 👺");
    
    _namingSheet.symbolNameField.delegate = self.suggestionController;
    self.suggestionController.textFieldProxyDelegate = (id<NSTextFieldDelegate>)_namingSheet;
    self.suggestionController.window = _namingSheet.window;
}

- (void)setDocumentData:(MSDocumentData *)docData
{
    _documentData = docData;

//    NSLog(@"%s %@", __PRETTY_FUNCTION__, @"setDocumentData is Called 👺");

    if (_documentData != nil) {
        self.suggestionController.symbolRepository = [[CSNSymbolRepository alloc] initWithDocumentData:_documentData];
    }
}

@end
