//
//  PAMViewController.m
//  webbrowser
//
//  Created by Thomas Sunde Nielsen on 22.04.14.
//  Copyright (c) 2014 PAM. All rights reserved.
//

#import "PAMViewController.h"
#import "PAMWebBrowserViewController.h"
#import "UIViewController+BrowserIBAction.h"

@interface PAMViewController ()

@property (nonatomic, strong) PAMWebBrowserViewController *browser;
@property (nonatomic, getter = isOverlayVisible) BOOL overlayVisible;

@end

@implementation PAMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.overlayVisible = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    self.browser = nil; // Frees the reference to save memory
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStoryboard *)browserStoryboardForDevice
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return [UIStoryboard storyboardWithName:@"PAMWebBrowser_iPad" bundle:nil];
    else
        return [UIStoryboard storyboardWithName:@"PAMWebBrowser_iPhone" bundle:nil];
}

- (IBAction)showBrowserProgrammatically:(id)sender
{
    /*
     [self showBrowser:nil]; // This does the same as below, only giving you less control.
     */
    
    self.browser = [[self browserStoryboardForDevice] instantiateInitialViewController];
    [self presentViewController:self.browser animated:YES completion:nil];
}

- (IBAction)showCensoringBrowser:(id)sender
{
    self.browser = [[self browserStoryboardForDevice] instantiateInitialViewController];
    [self.browser setBlockedDomains:@[[NSURL URLWithString:@"http://www.fcc.gov"], @"microsoft.com"]];
    [self.browser setBlockAlertData:@{@"title":@"Domain blocked",
                                      @"message":@"This domain has been blocked for your own protection.",
                                      @"cancelButton":@"Thanks"}];
    [self.browser setBlockedURLFallback:[NSURL URLWithString:@"http://apple.com"]];
    
    UIBarButtonItem *flex1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *infoItem = [[UIBarButtonItem alloc] initWithTitle:@"This browser blocks foul domains." style:UIBarButtonItemStylePlain target:nil action:nil];
    infoItem.enabled = NO;
    UIBarButtonItem *flex2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *customItems = @[flex1, infoItem, flex2];
    [self.browser setCustomBarButtonItems:customItems];
    
    [self presentViewController:self.browser animated:YES completion:nil];
}

- (IBAction)showWebClipper:(id)sender
{
    self.browser = [[self browserStoryboardForDevice] instantiateInitialViewController];
    [self.browser setHideDonebutton:YES];
    self.browser.url = [NSURL URLWithString:@"http://www.pam.no"];
    
    UIBarButtonItem *showImagesButton = [[UIBarButtonItem alloc] initWithTitle:@"Show available images" style:UIBarButtonItemStylePlain target:self action:@selector(showWebClipperOverlay)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *downloadButton = [[UIBarButtonItem alloc] initWithTitle:@"Done picking images" style:UIBarButtonItemStylePlain target:self action:@selector(downloadImages)];
    
    NSArray *customItems = @[showImagesButton, flex, downloadButton];

    [self.browser setCustomBarButtonItems:customItems];
    
    [self presentViewController:self.browser animated:YES completion:nil];
}

- (void)showWebClipperOverlay
{
    if (self.isOverlayVisible)
    {
        [self.browser.webView reload];
        return;
    }
    self.overlayVisible = YES;
    NSData *jsData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"webclipper" ofType:@"js"]];
    NSString *jsString = [[NSString alloc] initWithData:jsData encoding:NSUTF8StringEncoding];
    [self.browser.webView stringByEvaluatingJavaScriptFromString:jsString];
}

- (void)downloadImages
{
    NSString *imageURLString = [self.browser.webView stringByEvaluatingJavaScriptFromString:@"JSON.stringify(_PAM_imagesToDownload)"];
    NSData *imageURLData = [imageURLString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = [[NSError alloc] init];
    NSArray *imageURLArray = [NSJSONSerialization JSONObjectWithData:imageURLData options:0 error:&error];
    NSString *message = [NSString stringWithFormat:@"Downloading %lu images.", (unsigned long)imageURLArray.count];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Downloading" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
    // Start download of images here
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
