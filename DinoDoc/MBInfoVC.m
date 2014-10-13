//
//  MBInfoVC.m
//  KichenCalender
//
//  Created by Swapnil Takalkar on 8/27/13.
//  Copyright (c) 2013 09Apps. All rights reserved.
//

#import "MBInfoVC.h"
#import "DDMainParam.h"
#import "DDDefines.h"

@interface MBInfoVC ()

@end

@implementation MBInfoVC

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
    // Do any additional setup after loading the view from its nib.
    
    DDMainParam* mainparam = [DDMainParam sharedInstance];
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:mainparam.infobgimg]];

    UIButton *homebtn=[[UIButton alloc]initWithFrame:CGRectMake(10,25,42, 46)];
    [homebtn setImage:[UIImage imageNamed:HOMEICON] forState:UIControlStateNormal];
    [homebtn addTarget:self action:@selector(goHome:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homebarbtn=[[UIBarButtonItem alloc]initWithCustomView:homebtn];
    self.navigationItem.leftBarButtonItem=homebarbtn;
    
    self.scrollview.contentSize = CGSizeMake(self.scrollview.frame.size.width, 600);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)FBClicked:(UIButton *)sender
{
    NSURL *facebookURL = [NSURL URLWithString:FBURL];
    if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
        [[UIApplication sharedApplication] openURL:facebookURL];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://facebook.com"]];
    }
}

- (IBAction)WWWpressed:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:WEBURL]];
}
- (IBAction)AppStoreClicked:(UIButton *)sender
{    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        NSString *templateReviewURLiOS7 = @"itms-apps://itunes.apple.com/app/id";
        [templateReviewURLiOS7 stringByAppendingString:APPID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:templateReviewURLiOS7]];
    }
    else
    {
        NSString *templateReviewURL = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=";
        [templateReviewURL stringByAppendingString:APPID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:templateReviewURL]];
    }
}

- (IBAction)EmailClicked:(UIButton *)sender
{
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    
    mailComposer.mailComposeDelegate = self;
    
    [mailComposer setToRecipients:[NSArray arrayWithObjects: CONTACTEMAIL,nil]];
    
    [mailComposer setSubject:[NSString stringWithFormat: EMAILSUB]];
    
    [self presentViewController:mailComposer animated:YES completion:nil];

}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error

{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)goHome:(id)navbarbutton
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
