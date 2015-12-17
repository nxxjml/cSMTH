//
//  ViewController.m
//  cSMTH
//
//  Created by simao on 15/11/5.
//  Copyright © 2015年 simao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from600 nib.
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 600, 600)];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.newsmth.net"]];
    [self.view addSubview:webView];
    [webView loadRequest:request];
    [webView setDelegate:self];
    
    
}

- (void) webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 600, 600)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.5];
    [self.view addSubview:view];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [activityIndicator setCenter:view.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"WebViewDidFinishLoad");
    [activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    
    
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"didiFailLoadWithError:%@", error);
    [activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
