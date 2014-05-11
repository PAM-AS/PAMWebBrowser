//
//  UIViewController+BrowserIBAction.m
//  webbrowser
//
//  Created by Thomas Sunde Nielsen on 27.04.14.
//  Copyright (c) 2014 PAM. All rights reserved.
//

#import "UIViewController+BrowserIBAction.h"

@implementation UIViewController (BrowserIBAction)

- (IBAction)showBrowser:(id)sender
{
    UIStoryboard *storyboard = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        storyboard = [UIStoryboard storyboardWithName:@"PAMWebBrowser_iPad" bundle:nil];
    else
        storyboard = [UIStoryboard storyboardWithName:@"PAMWebBrowser_iPhone" bundle:nil];
    
    UIViewController *browser = [storyboard instantiateInitialViewController];
    [self presentViewController:browser animated:YES completion:nil];
}

@end
