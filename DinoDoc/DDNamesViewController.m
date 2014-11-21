//
//  DDNamesViewController.m
//  DinoDoc
//
//  Created by Swapnil Takalkar on 11/15/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import "DDNamesViewController.h"
#import "DDDefines.h"

@interface DDNamesViewController ()

@end

@implementation DDNamesViewController 

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.cwebview.delegate = self;
    
    NSURL *url = [NSURL URLWithString:CONTRIURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.cwebview loadRequest:requestObj];
    
    UIButton *homebtn=[[UIButton alloc]initWithFrame:CGRectMake(10,25,42, 46)];
    [homebtn setImage:[UIImage imageNamed:HOMEICON] forState:UIControlStateNormal];
    [homebtn addTarget:self action:@selector(goHome:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homebarbtn=[[UIBarButtonItem alloc]initWithCustomView:homebtn];
    self.navigationItem.leftBarButtonItem=homebarbtn;
    
    
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goHome:(id)navbarbutton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.navigationItem.title = @"Loading ..";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.navigationItem.title = @"Our Stars";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
