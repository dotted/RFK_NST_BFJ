//
//  WebViewController.h
//  Randers Flyveklub
//
//  Created by Mercantec on 2/26/13.
//  Copyright (c) 2013 Nestea & Bo Fucking Jensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *myWebView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadIndicator;

@property (strong, nonatomic) IBOutlet UILabel *labelErrorDescription;

- (IBAction)changeWebSite:(UISegmentedControl *)sender;
- (IBAction)backBtn:(id)sender;

@end
