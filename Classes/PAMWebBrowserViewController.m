//
//  PAMWebClipperViewController.m
//  shopapp
//
//  Created by Thomas Sunde Nielsen on 26.03.14.
//  Copyright (c) 2014 PAM. All rights reserved.
//

#import "PAMWebBrowserViewController.h"
#import "NSString+SAMAdditions.h"
#import "NJKWebViewProgressView.h"

@interface PAMWebBrowserViewController ()

@property (nonatomic, strong) IBOutlet UIToolbar *topToolbar;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *topToolbarHeight;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *urlFieldWrapperItem;
@property (nonatomic, strong) IBOutlet UIView *urlFieldBg;
@property (nonatomic, strong) UIColor *urlFieldDefaultBgColor;
@property (nonatomic, strong) IBOutlet UITextField *urlField;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *urlFieldRightMargin;

@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic, strong) IBOutlet UIButton *backButton;
@property (nonatomic, strong) IBOutlet UIButton *forwardButton;
@property (nonatomic, strong) IBOutlet UIButton *reloadButton;

@property (nonatomic, strong) IBOutlet UIToolbar *bottomToolbar;

@property (nonatomic, strong) UIAlertView *alert;

@property (nonatomic, strong) IBOutlet NJKWebViewProgressView *progressView;

@end

@implementation PAMWebBrowserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.url)
        self.url = [NSURL URLWithString:@"http://google.com/"];
    
    self.urlFieldDefaultBgColor = self.urlFieldBg.backgroundColor;
    
    [[self.reloadButton titleLabel] setFont:[UIFont fontWithName:@"FontAwesome" size:self.reloadButton.titleLabel.font.pointSize]];
    
    if (self.hidesDoneButton)
        self.doneButton.customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    self.urlField.superview.layer.cornerRadius = 5.0;
    
    self.urlField.text = [[self.url.absoluteString stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];

    [self.topToolbarHeight setConstant:64.0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.customBarButtonItems)
    {
        [self.webView.scrollView setContentInset:UIEdgeInsetsMake(64.0, 0.0, 44.0, 0.0)];
        [self.bottomToolbar setItems:self.customBarButtonItems];
    }
    else
    {
        [self.webView.scrollView setContentInset:UIEdgeInsetsMake(64.0, 0.0, 0.0, 0.0)];
        self.bottomToolbar.hidden = YES;
    }
    [self.webView.scrollView setScrollIndicatorInsets:self.webView.scrollView.contentInset];
    
    self.progressProxy = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = self.progressProxy;
    self.progressProxy.webViewProxyDelegate = self;
    self.progressProxy.progressDelegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [self.progressView setProgress:progress animated:NO];
}

#pragma mark - rotation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // Nobody has ever been hurt by a few magic numbers - said nobody, ever.
    [UIView animateWithDuration:duration animations:^{
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            switch (toInterfaceOrientation) {
                case UIInterfaceOrientationLandscapeLeft:
                case UIInterfaceOrientationLandscapeRight:
                    self.urlFieldWrapperItem.width = 836;
                    break;
                    
                case UIInterfaceOrientationPortrait:
                case UIInterfaceOrientationPortraitUpsideDown:
                    self.urlFieldWrapperItem.width = 580;
                default:
                    break;
            }
        }
        else
        {
            switch (toInterfaceOrientation) {
                case UIInterfaceOrientationLandscapeLeft:
                case UIInterfaceOrientationLandscapeRight:
                    self.urlFieldWrapperItem.width = 400;
                    break;
                    
                case UIInterfaceOrientationPortrait:
                case UIInterfaceOrientationPortraitUpsideDown:
                    self.urlFieldWrapperItem.width = 160;
                default:
                    break;
            }
        }
    }];
}

#pragma mark - Setters & getters
- (void)setUrl:(NSURL *)url
{
    _url = url;
    self.urlField.text = [[url.absoluteString stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}
    

#pragma mark - helpers
- (NSURL *)googleURLForString:(NSString *)string
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://www.google.com/search?q=%@", [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (self.blockedDomains)
    {
        BOOL allowed = YES;
        
        for (id urlObject in self.blockedDomains)
        {
            NSString *string = nil;
            if ([urlObject isKindOfClass:[NSString class]])
            {
                string = urlObject;
            }
            else if ([urlObject isKindOfClass:[NSURL class]])
            {
                string = [(NSURL *)urlObject host];
            }
            
            if (string)
            {
                if ([request.URL.host sam_containsString:string])
                {
                    allowed = NO;
                    if (![self.alert isVisible])
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (self.blockAlertData)
                            {
                                if ([self.blockAlertData objectForKey:@"cancelButton"])
                                    self.alert = [[UIAlertView alloc] initWithTitle:@"Blocked domain" message:@"This domain has been blocked." delegate:nil cancelButtonTitle:[self.blockAlertData objectForKey:@"cancelButton"] otherButtonTitles: nil];
                                else
                                    self.alert = [[UIAlertView alloc] initWithTitle:@"Blocked domain" message:@"This domain has been blocked." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                
                                if ([self.blockAlertData objectForKey:@"title"])
                                    self.alert.title = [self.blockAlertData objectForKey:@"title"];
                                if ([self.blockAlertData objectForKey:@"message"])
                                    self.alert.message = [self.blockAlertData objectForKey:@"message"];
                            }
                            else
                                self.alert = [[UIAlertView alloc] initWithTitle:@"Blocked domain" message:@"This domain has been blocked." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                            
                            [self.alert show];
                        });
                    }
                    
                    if (self.blockedURLFallback)
                        [self.webView loadRequest:[NSURLRequest requestWithURL:self.blockedURLFallback]];
                    
                    break;
                }
            }
        }
        
        return allowed;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.urlField.text = [[webView.request.URL.absoluteString stringByReplacingOccurrencesOfString:@"https://" withString:@""] stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    self.backButton.enabled = webView.canGoBack;
    self.forwardButton.enabled = webView.canGoForward;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (error.code == NSURLErrorCancelled) // Something else than page not found.
        return;
    
    self.url = [self googleURLForString:self.urlField.text];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.reloadButton.hidden = YES;
    self.urlFieldRightMargin.constant = 0;
    [textField selectAll:self];
    self.urlFieldBg.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0.9 alpha:1];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.reloadButton.hidden = NO;
    self.urlFieldRightMargin.constant = 30;
    self.urlFieldBg.backgroundColor = self.urlFieldDefaultBgColor;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self go:textField];
    return NO;
}

- (IBAction)go:(id)sender
{
    NSString *urlString = self.urlField.text;

    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if (!urlString || urlString.length == 0)
    {
#if DEBUG
        NSLog(@"No url, load google.com");
#endif
        self.url = [NSURL URLWithString:@"http://google.com/"];
    }
    else if ([url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"])
    {
#if DEBUG
        NSLog(@"Got regular URL, load it");
#endif
        self.url = url;
    }
    else
    {
        NSError *error = [[NSError alloc] init];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^((\\S{1,61})\\.)+([a-z0-9-]{2,30})[\\?\\/]?\\S*$" options:NSRegularExpressionCaseInsensitive error:&error];
        if ([[regex matchesInString:urlString options:0 range:NSMakeRange(0, urlString.length)] count] > 0)
        {
#if DEBUG
            NSLog(@"Regex match for %@", urlString);
#endif
            self.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", urlString]];
        }
        else
        {
#if DEBUG
            NSLog(@"No regex match for %@", urlString);
#endif
            self.url = [self googleURLForString:urlString];
        }
    }
    
#if DEBUG
    NSLog(@"Loading URL: %@", self.url.absoluteString);
#endif
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
    [self.urlField resignFirstResponder];
}

- (IBAction)back:(id)sender
{
    if (self.webView.canGoBack)
        [self.webView goBack];
}

- (IBAction)forward:(id)sender
{
    if (self.webView.canGoForward)
        [self.webView goForward];
}

- (IBAction)reload:(id)sender
{
    [self.webView reload];
}

- (IBAction)done:(id)sender
{
    if (self.navigationController)
        [[self navigationController] popViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
