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
    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.dmi.dk/dmi/mobil2"]]];
    [super viewDidLoad];
    myWebView.delegate = self;
    segment.selectedSegmentIndex = -1;
    segment.momentary = YES;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeWebSite:(UISegmentedControl *)sender
{
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
{
    [myWebView goBack];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [loadIndicator stopAnimating];
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [loadIndicator startAnimating];
}

@end
