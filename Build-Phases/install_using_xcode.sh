#!/bin/bash

## This script is for using inside Xcode's Run Script Phase to package framework as .sketchplugin and putitng it as symbolic link.
## It means that all you have to do to debug using Xcode is just "Run" then automatilcally install my sketchplugin.

## set a path for `bundler` if you have it on different path.
BUNDLER_PATH=~/.rbenv/shims/bundler

## run fastlane "install" lane
$BUNDLER_PATH exec fastlane mac install build_dir:$CONFIGURATION_BUILD_DIR