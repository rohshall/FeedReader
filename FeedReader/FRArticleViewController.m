//
//  FRArticleViewController.m
//  FeedReader
//
//  Created by Salil Wadnerkar on 10/5/13.
//  Copyright (c) 2013 Salil Wadnerkar. All rights reserved.
//

#import "FRArticleViewController.h"

@interface FRArticleViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation FRArticleViewController

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
	// Do any additional setup after loading the view.
    [_loadingIndicator startAnimating];
    
    NSURL *url = [NSURL URLWithString:_url];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:req];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_loadingIndicator stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"webView::didFailLoadWithError %@", [error localizedDescription]);
    [_loadingIndicator stopAnimating];    
}

@end
