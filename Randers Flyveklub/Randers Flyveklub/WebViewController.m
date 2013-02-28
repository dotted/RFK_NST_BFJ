//
//  WebViewController.m
//  Randers Flyveklub
//
//  Created by Mercantec on 2/26/13.
//  Copyright (c) 2013 Nestea & Bo Fucking Jensen. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

@synthesize myWebView;
@synthesize segment;
@synthesize loadIndicator;
@synthesize labelErrorDescription;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    //Load default website in webview
    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.dmi.dk/dmi/mobil2"]]];

}

- (void)viewDidLoad
{
    //Change style and color of the segmented controller.
    segment.segmentedControlStyle = UISegmentedControlStyleBar;
    segment.tintColor = [UIColor darkGrayColor];
    //Dont highlight any "button" at start
    segment.selectedSegmentIndex = -1;
    //Only show selected while pushing "button"
    segment.momentary = YES;
    
    [super viewDidLoad];
    myWebView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeWebSite:(UISegmentedControl *)sender
// Change website when "button" is pushed.
{
    labelErrorDescription.text = @"";
    if  (segment.selectedSegmentIndex == 0)
    {
        [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.dmi.dk/dmi/mobil2"]]];
    }
    else if(segment.selectedSegmentIndex == 1)
    {
        [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.airfields.dk/"]]];
    }
    else if(segment.selectedSegmentIndex == 2)
    {
        [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.randersflyveklub.dk"]]];
    }
    else if(segment.selectedSegmentIndex == 3)
    {
        [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://embed.bambuser.com/broadcast/3390434"]]];
    }
}

- (IBAction)backBtn:(id)sender
//Go back whenever back button is pressed
{
    [myWebView goBack];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //Stop animation "loading" indicator when webview finishes loading
    [loadIndicator stopAnimating];
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    //Start animation of "loading" indicator on webview load.
    [loadIndicator startAnimating];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //Log error messages.
    //NSLog(@"Error: %@", error);
    //NSLog(@"Error local Description: %@", [error localizedDescription]);
    if ([error code] == -1009)
    {
        //Load blank page and show error when theres no internet connection available
        [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
        labelErrorDescription.text = [NSString stringWithFormat:@"%@", [error localizedDescription]];
    }
}

@end
