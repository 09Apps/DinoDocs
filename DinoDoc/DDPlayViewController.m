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
#import "DDDefines.h"

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
    // Initiate activity indicator
    self.spinner = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.hidesWhenStopped = YES;
    self.spinner.center = senderbtn.center;
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
    
    DDMainParam* mainparam = [DDMainParam sharedInstance];
    self.currprod = senderbtn.tag;
    NSDictionary* dict = [mainparam.options objectAtIndex:senderbtn.tag];
    
    NSString* prodid = [dict objectForKey:@"productid"];

    if ([[dict objectForKey:@"purchased"] boolValue] || [[DDIAPUse sharedInstance] productPurchased:prodid] )
    {
        if ([self.spinner isAnimating])
        {
            [self.spinner stopAnimating];
        }
        
        [self performSegueWithIdentifier:@"selseg" sender:senderbtn];
    }
    else
    {
        if (_products == nil)
        {
            [self.spinner stopAnimating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oh shucks!" message:@"Seems like a slow connection, please try again in 2-3 seconds" delegate:self cancelButtonTitle:@"Yawn..." otherButtonTitles: nil];
            
            [alert show];
        }
        else
        {
            SKProduct *product = _products[senderbtn.tag];
            [[DDIAPUse sharedInstance] buyProduct:product];
        }
        
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
        //tile value in mainparam options must match with title value in badge -> Badges
        selVC.opttitle = [dict objectForKey:@"title"];
        
        // Stop the background sound now.
        [self.bgplayer stop];
    }
    else if ([segue.identifier isEqualToString:@"selsetting"])
    {
        DDSettingTblViewController *settingTVC = (DDSettingTblViewController*)[segue destinationViewController];
        
        // Pass on soundid to Play VC as we will stop it at exit of play VC
        settingTVC.bgplayer = self.bgplayer;
        settingTVC.delegate = self;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *stngbtn=[[UIButton alloc]initWithFrame:CGRectMake(10,25,48, 46)];
    [stngbtn setImage:[UIImage imageNamed:SETGICON] forState:UIControlStateNormal];
    [stngbtn addTarget:self action:@selector(handleSettings:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *stbarbtn=[[UIBarButtonItem alloc]initWithCustomView:stngbtn];
    self.navigationItem.rightBarButtonItem=stbarbtn;
    
    UIButton *homebtn=[[UIButton alloc]initWithFrame:CGRectMake(10,25,42, 46)];
    [homebtn setImage:[UIImage imageNamed:HOMEICON] forState:UIControlStateNormal];
    [homebtn addTarget:self action:@selector(goHome:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homebarbtn=[[UIBarButtonItem alloc]initWithCustomView:homebtn];
    self.navigationItem.leftBarButtonItem=homebarbtn;
    
    // Get the singleton instance of main param
    DDMainParam* mainparam = [DDMainParam sharedInstance];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:mainparam.playbgimg]];
    
    NSUInteger optionscount = [mainparam.options count];
    
    for (int i=0; i<optionscount; i++)
    {
        [self drawButton:i];
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

- (void) drawButton:(NSUInteger)btnindex
{
    CGFloat scrwidth = CGRectGetWidth(self.view.bounds);
    CGFloat scrheight = CGRectGetHeight(self.view.bounds);
    CGFloat imgwidth, imgheight;
    
    // Get the singleton instance of main param
    DDMainParam* mainparam = [DDMainParam sharedInstance];
    
    NSDictionary* dict = [mainparam.options objectAtIndex:btnindex];
    
    if ([[dict objectForKey:@"active"] boolValue])
    {
        //create buttons for options at runtime
        UIButton *choicebtn = [[UIButton alloc] init];
        
        //set their selector using add selector
        [choicebtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([[dict objectForKey:@"purchased"] boolValue])
        {
            UIImage* on_img = [UIImage imageNamed:[dict objectForKey:@"on-image"]];
            [choicebtn setImage:on_img forState:UIControlStateNormal];
            imgheight = on_img.size.height;
            imgwidth = on_img.size.width;
        }
        else
        {
            UIImage* iap_img = [UIImage imageNamed:[dict objectForKey:@"iap-image"]];
            [choicebtn setImage:iap_img forState:UIControlStateNormal];
            imgheight = iap_img.size.height;
            imgwidth = iap_img.size.width;
        }
        
        [choicebtn setTag:btnindex];
        
        switch ([[dict objectForKey:@"butseq"] integerValue])
        {
            case 0:
                choicebtn.frame = CGRectMake(((scrwidth*0.5)-(imgwidth/2)),((scrheight*0.3)-(imgheight/2)),imgwidth,imgheight);
                break;
                
            case 1:
                choicebtn.frame = CGRectMake(((scrwidth*0.22)-(imgwidth/2)),((scrheight*0.5)-(imgheight/2)),imgwidth,imgheight);
                break;
                
            case 2:
                choicebtn.frame = CGRectMake(((scrwidth*0.5)-(imgwidth/2)),((scrheight*0.5)-(imgheight/2)),imgwidth,imgheight);
                break;
                
            case 3:
                choicebtn.frame = CGRectMake(((scrwidth*0.78)-(imgwidth/2)),((scrheight*0.5)-(imgheight/2)),imgwidth,imgheight);
                break;
                
            case 4:
                choicebtn.frame = CGRectMake(((scrwidth*0.12)-(imgwidth/2)),((scrheight*0.67)-(imgheight/2)),imgwidth,imgheight);
                break;
                
            case 5:
                choicebtn.frame = CGRectMake(((scrwidth*0.36)-(imgwidth/2)),((scrheight*0.67)-(imgheight/2)),imgwidth,imgheight);
                break;
                
            case 6:
                choicebtn.frame = CGRectMake(((scrwidth*0.59)-(imgwidth/2)),((scrheight*0.67)-(imgheight/2)),imgwidth,imgheight);
                break;
                
            case 7:
                choicebtn.frame = CGRectMake(((scrwidth*0.85)-(imgwidth/2)),((scrheight*0.67)-(imgheight/2)),imgwidth,imgheight);
                break;
                
            default:
                break;
        }
        
        [self.view addSubview:choicebtn];
    } ;
}

- (void)modalDialogClosed:(UIViewController *)viewController
//- (void)modalDialogClosed
{
    [self goHome:nil];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseFailed:) name:IAPHelperFailedPurchasedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)purchaseFailed:(NSNotification *)notification
{
    if ([self.spinner isAnimating])
    {
        [self.spinner stopAnimating];
    }
}

- (void)productPurchased:(NSNotification *)notification
{
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop)
    {
        if ([product.productIdentifier isEqualToString:productIdentifier])
        {
            // Update Mainparam to set putchased is yes
            // reload images
            *stop = YES;
            
            DDMainParam* mainparam = [DDMainParam sharedInstance];
            NSMutableDictionary* dict = [mainparam.options objectAtIndex:self.currprod];
            [dict setValue:[DDUtils stringFromBool:YES] forKey:@"purchased"];
            [mainparam updateMainParam];

            // Change image on button
            UIView *sview = [self.view viewWithTag:self.currprod];
            UIButton* cbtn = (UIButton*)sview;
            
            UIImage* on_img = [UIImage imageNamed:[dict objectForKey:@"on-image"]];
            [cbtn setImage: on_img forState:UIControlStateNormal];
        }
        
        if ([self.spinner isAnimating])
        {
            [self.spinner stopAnimating];
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
