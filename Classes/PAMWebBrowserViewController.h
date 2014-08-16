//
//  PAMWebClipperViewController.h
//  shopapp
//
//  Created by Thomas Sunde Nielsen on 26.03.14.
//  Copyright (c) 2014 PAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"

@interface PAMWebBrowserViewController : UIViewController <UIWebViewDelegate, UITextFieldDelegate, NJKWebViewProgressDelegate>

/* Options
 */
@property (nonatomic, getter = hidesDoneButton) BOOL hideDonebutton; // You can set this to YES if you want your own done-button in the custom items array.

/* Setup
 */
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSArray *customBarButtonItems;
@property (nonatomic, strong) IBOutlet UIWebView *webView;

/* URL Blocking
 */
@property (nonatomic, strong) NSArray *blockedDomains; // Supports NSURL and NSString. Uses liberal "contains" check to catch subdomains.
@property (nonatomic, strong) NSDictionary *blockAlertData; // Available keys: title, message, cancelButton.
@property (nonatomic, strong) NSURL *blockedURLFallback;

/* NJKWebViewProgress
 Progress helper, which reroutes the delegate a bit. 
 If you need to override the webview delegate, set the progressProcy.webViewProxyDelegate to self instead of webview.delegate.
 */
@property (nonatomic, strong) NJKWebViewProgress *progressProcy;

@end
