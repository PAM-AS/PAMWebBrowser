# PAMWebBrowser

Web browser for iOS, intended to be used inside apps

[![Version](http://cocoapod-badges.herokuapp.com/v/PAMWebBrowser/badge.png)](http://cocoadocs.org/docsets/PAMWebBrowser)
[![Platform](http://cocoapod-badges.herokuapp.com/p/PAMWebBrowser/badge.png)](http://cocoadocs.org/docsets/PAMWebBrowser)

## Features

* Web browser with navigation and address bar
* Address bar searches google if no domain is found
* You can add a list of blocked domains, with a fallback (see example project)
* You can add custom buttons that run custom features (see example project)

## Screenshot

![Screenshot](http://cl.ly/image/3c0F432p1808/screenshot.png)

## Installation

PAMWebBrowser is available through [CocoaPods](http://cocoapods.org), to install
it add the following line to your Podfile, then run `pod install`:

    pod "PAMWebBrowser"

## Usage

1. Import `UIViewController+BrowserIBAction.h`
2. Call `[self showBrowser:nil];` or connect your button in IB.

#todo

* Make status bar collapse like in Safari
* Forward + backward gestures
* History and autocomplete

## Author

Thomas S. Nielsen ([@thomassnielsen](https://twitter.com/thomassnielsen), [thomas@pam.no](mailto:thomas@pam.no))
## License

PAMWebBrowser is available under the MIT license. See the LICENSE file for more info.
