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
//    self.openurl = FBURL;
//    [self parentalGate];  //Parental Gate
    
    NSURL *facebookURL = [NSURL URLWithString:FBURL];
    if ([[UIApplication sharedApplication] canOpenURL:facebookURL])
    {
        [[UIApplication sharedApplication] openURL:facebookURL];
    } else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://facebook.com"]];
    }
}
- (IBAction)PolicyPressed:(UIButton *)sender
{
    self.openurl = POLICYURL;
//  [self parentalGate];  //Parental Gate
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.openurl]];
}

- (IBAction)fqaPressed:(UIButton *)sender
{
    self.openurl = FAQURL;
//  [self parentalGate];  //Parental Gate
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.openurl]];

}

- (IBAction)WWWpressed:(UIButton *)sender
{
    self.openurl = TWITTERURL;
//  [self parentalGate];  //Parental Gate
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.openurl]];

}

- (IBAction)AppStoreClicked:(UIButton *)sender
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        NSString *templateReviewURLiOS7 = @"itms-apps://itunes.apple.com/app/id";
        [templateReviewURLiOS7 stringByAppendingString:APPID];
        self.openurl = templateReviewURLiOS7;
    }
    else
    {
        NSString *templateReviewURL = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=09Apps&id=";
        [templateReviewURL stringByAppendingString:APPID];
        self.openurl = templateReviewURL;
    }
    
//  [self parentalGate];  //Parental Gate
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.openurl]];
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

/* future implementation for made for kids category
-(void)parentalGate
{
    //get two random numbers between 10 & 20
    int num1 = (arc4random() % 20) + 10;
    int num2 = (arc4random() % 20) + 10;
    
    NSString* pgQuestion = [NSString stringWithFormat:@"What is sum of %d + %d",num1,num2];
    
    int ans = num1 + num2;
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Consult your parent!" message:pgQuestion delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    alertView.tag = ans;
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    { //OK button
        int parentalGateAnswer = [[[alertView textFieldAtIndex:0] text] intValue];
        
        if ( alertView.tag == parentalGateAnswer )
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.openurl]];
        }
        else
        {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Wrong answer!" message:@"Please consult your parent!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alertView.tag = 0; // required so that the alertview does not go in loop
            [alertView show];

        }
    }
    else if (buttonIndex == 0 && alertView.tag != 0)
    {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Consult your parent!" message:@"Please answer the question to access this link!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alertView.tag = 0; // required so that the alertview does not go in loop
            [alertView show];
    }
}
*/

@end
