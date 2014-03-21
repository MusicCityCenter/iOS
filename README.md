# iOS

[![Build Status](https://travis-ci.org/MusicCityCenter/iOS.png?branch=master)](https://travis-ci.org/MusicCityCenter/iOS)

iOS App for Nashville's Music City Center

## Installation

1. Clone the repo to your local machine.
2. Run `$ pod install` (download [CocoaPods](cocoapods.org) first if you haven't already).
3. In *MBXMapKit.m*, comment out the line `[self updateMarkers]` in `setMapID:` (based on advice given [here](https://github.com/mapbox/mbxmapkit/issues/75#issuecomment-37945403). 
