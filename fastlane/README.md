fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## Mac
### mac develop
```
fastlane mac develop
```
Build for development
### mac build
```
fastlane mac build
```
Build framework
### mac package
```
fastlane mac package
```
Package plugin, building framework unless provided
### mac install
```
fastlane mac install
```
Package and install plugin to Sketch
### mac zipped_package
```
fastlane mac zipped_package
```
Package plugin, and zip it
### mac publish
```
fastlane mac publish
```
Publish and Package
### mac notarize_plugin
```
fastlane mac notarize_plugin
```
Notarize

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
