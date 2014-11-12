//
//  DDContriViewController.m
//  DinoDoc
//
//  Created by Swapnil Takalkar on 9/21/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import "DDContriViewController.h"
#import "DDMainParam.h"    
#import "DDDefines.h"

@interface DDContriViewController ()

@end

@implementation DDContriViewController

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
    
    // Get the singleton instance of main param
    DDMainParam* mainparam = [DDMainParam sharedInstance];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:mainparam.contribgimg]];
    
    UIButton *homebtn=[[UIButton alloc]initWithFrame:CGRectMake(10,25,42, 46)];
    [homebtn setImage:[UIImage imageNamed:HOMEICON] forState:UIControlStateNormal];
    [homebtn addTarget:self action:@selector(goHome:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homebarbtn=[[UIBarButtonItem alloc]initWithCustomView:homebtn];
    self.navigationItem.leftBarButtonItem=homebarbtn;
}
- (IBAction)showContributers:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.09apps.com/"]];
}

- (IBAction)sendMail:(UIButton *)sender
{
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    
    mailComposer.mailComposeDelegate = self;
    
    [mailComposer setToRecipients:[NSArray arrayWithObjects: @"dinoQ@09apps.com",nil]];
    
    [mailComposer setSubject:[NSString stringWithFormat: @"Q for DinoDoc"]];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    DDMainParam* mainparam = [DDMainParam sharedInstance];
    
    if (mainparam.showads)
    {
        [super viewWillAppear:animated];
        self.shared = [MBGADMasterVC singleton];
        [self.shared resetAdView:self];
    }
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
