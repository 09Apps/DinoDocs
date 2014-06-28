//
//  DDPlayViewController.m
//  DinoDoc
//
//  Created by Swapnil Takalkar on 1/28/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import "DDPlayViewController.h"
#import "DDSelectViewController.h"
#import "DDMainParam.h"    
#import "DDSettingTblViewController.h"
#import "DDIAPUse.h"
#import "DDUtils.h"

@interface DDPlayViewController ()
{
    NSArray *_products;
}

@end

@implementation DDPlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Custom initialization
    }
    return self;
}
- (IBAction)btnClicked:(UIButton *)senderbtn
{
    DDMainParam* mainparam = [DDMainParam sharedInstance];
    self.currprod = senderbtn.tag;
    NSDictionary* dict = [mainparam.options objectAtIndex:senderbtn.tag];
    NSString* prodid = [dict objectForKey:@"productid"];
    
    if ([[DDIAPUse sharedInstance] productPurchased:prodid])
    {
        [self performSegueWithIdentifier:@"selseg" sender:senderbtn];
    }
    else
    {
        SKProduct *product = _products[senderbtn.tag];
        [[DDIAPUse sharedInstance] buyProduct:product];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender
{
    // Just to make sure we have the right segue
    if ([segue.identifier isEqualToString:@"selseg"])
    {
        DDSelectViewController *selVC = (DDSelectViewController*)[segue destinationViewController];
        
        DDMainParam* mainparam = [DDMainParam sharedInstance];
        NSDictionary* dict = [mainparam.options objectAtIndex:self.currprod];
        
        // Pass on required parameters from main file
        selVC.opttitle = [dict objectForKey:@"title"];
        
        // Stop the background sound now.
        [self.bgplayer stop];
    }
    else if ([segue.identifier isEqualToString:@"selsetting"])
    {
        DDSettingTblViewController *settingTVC = (DDSettingTblViewController*)[segue destinationViewController];
        
        // Pass on soundid to Play VC as we will stop it at exit of play VC
        settingTVC.bgplayer = self.bgplayer;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *stngbtn=[[UIButton alloc]initWithFrame:CGRectMake(10,25,48, 46)];
    [stngbtn setImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
    [stngbtn addTarget:self action:@selector(handleSettings:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *stbarbtn=[[UIBarButtonItem alloc]initWithCustomView:stngbtn];
    self.navigationItem.rightBarButtonItem=stbarbtn;
    
    UIButton *homebtn=[[UIButton alloc]initWithFrame:CGRectMake(10,25,42, 46)];
    [homebtn setImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
    [homebtn addTarget:self action:@selector(goHome:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homebarbtn=[[UIBarButtonItem alloc]initWithCustomView:homebtn];
    self.navigationItem.leftBarButtonItem=homebarbtn;
    
	// Get the singleton instance of main param
    DDMainParam* mainparam = [DDMainParam sharedInstance];

    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:mainparam.playbgimg]];

    NSUInteger optionscount = [mainparam.options count];

    for (int i=0; i<optionscount; i++)
    {
        NSDictionary* dict = [mainparam.options objectAtIndex:i];
        
        if ([[dict objectForKey:@"active"] boolValue])
        {
            switch ([[dict objectForKey:@"butseq"] integerValue])
            {
                case 0:
                    if ([[dict objectForKey:@"purchased"] boolValue])
                    {
                        [self.b0btn setBackgroundImage:[UIImage imageNamed:[dict objectForKey:@"on-image"]] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [self.b0btn setBackgroundImage:[UIImage imageNamed:[dict objectForKey:@"iap-image"]] forState:UIControlStateNormal];
                    }
                    [self.b0btn setTag:i];
                    break;

                case 1:
                    if ([[dict objectForKey:@"purchased"] boolValue])
                    {
                        [self.b1btn setBackgroundImage:[UIImage imageNamed:[dict objectForKey:@"on-image"]] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [self.b1btn setBackgroundImage:[UIImage imageNamed:[dict objectForKey:@"iap-image"]] forState:UIControlStateNormal];
                    }
                    [self.b1btn setTag:i];
                    break;

                case 2:
                    if ([[dict objectForKey:@"purchased"] boolValue])
                    {
                        [self.b2btn setBackgroundImage:[UIImage imageNamed:[dict objectForKey:@"on-image"]] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [self.b2btn setBackgroundImage:[UIImage imageNamed:[dict objectForKey:@"iap-image"]] forState:UIControlStateNormal];
                    }
                    [self.b2btn setTag:i];
                    break;
                    
                case 3:
                    if ([[dict objectForKey:@"purchased"] boolValue])
                    {
                        [self.b3btn setBackgroundImage:[UIImage imageNamed:[dict objectForKey:@"on-image"]] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [self.b3btn setBackgroundImage:[UIImage imageNamed:[dict objectForKey:@"iap-image"]] forState:UIControlStateNormal];
                    }
                    [self.b3btn setTag:i];
                    break;
                    
                case 4:
                    if ([[dict objectForKey:@"purchased"] boolValue])
                    {
                        [self.b4btn setBackgroundImage:[UIImage imageNamed:[dict objectForKey:@"on-image"]] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [self.b4btn setBackgroundImage:[UIImage imageNamed:[dict objectForKey:@"iap-image"]] forState:UIControlStateNormal];
                    }
                    [self.b4btn setTag:i];
                    break;
                    
                case 5:
                    if ([[dict objectForKey:@"purchased"] boolValue])
                    {
                        [self.b5btn setBackgroundImage:[UIImage imageNamed:[dict objectForKey:@"on-image"]] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [self.b5btn setBackgroundImage:[UIImage imageNamed:[dict objectForKey:@"iap-image"]] forState:UIControlStateNormal];
                    }
                    [self.b5btn setTag:i];
                    break;

                case 6:
                    if ([[dict objectForKey:@"purchased"] boolValue])
                    {
                        [self.b6btn setBackgroundImage:[UIImage imageNamed:[dict objectForKey:@"on-image"]] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [self.b6btn setBackgroundImage:[UIImage imageNamed:[dict objectForKey:@"iap-image"]] forState:UIControlStateNormal];
                    }
                    [self.b6btn setTag:i];
                    break;
                    
                case 7:
                    if ([[dict objectForKey:@"purchased"] boolValue])
                    {
                        [self.b7btn setBackgroundImage:[UIImage imageNamed:[dict objectForKey:@"on-image"]] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [self.b7btn setBackgroundImage:[UIImage imageNamed:[dict objectForKey:@"iap-image"]] forState:UIControlStateNormal];
                    }
                    [self.b7btn setTag:i];
                    break;
                    
                default:
                    break;
            }
        } ;
    }
    
    // Now do the in-app purchase thing
    
    [[DDIAPUse sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *prod)
     {
         if (success)
         {
             _products = prod;
         }
     }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop)
    {
        if ([product.productIdentifier isEqualToString:productIdentifier])
        {
            // Update Mainparam to set putchased is yes
            // reload images
            *stop = YES;
            
            DDMainParam* mainparam = [DDMainParam sharedInstance];
            NSDictionary* dict = [mainparam.options objectAtIndex:self.currprod];
            [dict setValue:[DDUtils stringFromBool:YES] forKey:@"purchased"];
            [mainparam updateMainParam];
            
        }
    }];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleSettings:(id)navbarbutton
{
    [self performSegueWithIdentifier:@"selsetting" sender:navbarbutton];
}

- (void)goHome:(id)navbarbutton
{
    // Stop the background sound now.
    [self.bgplayer stop];
    [self performSegueWithIdentifier:@"gohome" sender:navbarbutton];
}

@end
