#!/bin/bash

if [ -n "$BUILD_FROM_FASTLANE" ]; then
    echo "Build from fastlane. skip execute Install plugin phase."
    exit 0
fi

if [ ! -e "$SRCROOT/SymbolNameAutocomplete.sketchplugin" ]; then
    echo "Run 'npm run postinstall' or 'npm run build' first."
    exit 1
fi

## This script is for using inside Xcode's Run Script Phase to package framework as .sketchplugin and putitng it as symbolic link.
## It means that all you have to do to debug using Xcode is just "Run" then automatilcally install my sketchplugin.

echo "$BUILT_PRODUCTS_DIR/$FULL_PRODUCT_NAME"
echo "$SRCROOT/SymbolNameAutocomplete.sketchplugin/Resources/$FULL_PRODUCT_NAME"

cp -rf "$BUILT_PRODUCTS_DIR/$FULL_PRODUCT_NAME" "$SRCROOT/SymbolNameAutocomplete.sketchplugin/Contents/Resources/$FULL_PRODUCT_NAME"
