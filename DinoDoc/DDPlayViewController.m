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

- (void)choiceMade:(UIButton *)senderbutton
{
    DDMainParam* mainparam = [DDMainParam sharedInstance];
    NSDictionary* dict = [mainparam.options objectAtIndex:senderbutton.tag];
    NSString* prodid = [dict objectForKey:@"productid"];
    
    if ([[DDIAPUse sharedInstance] productPurchased:prodid])
    {
        [self performSegueWithIdentifier:@"selseg" sender:senderbutton];
    }
    else
    {
        SKProduct *product = _products[senderbutton.tag];
        NSLog(@"Buying %@...", product.productIdentifier);
        [[DDIAPUse sharedInstance] buyProduct:product];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Just to make sure we have the right segue
    if ([segue.identifier isEqualToString:@"selseg"])
    {
        DDSelectViewController *selVC = (DDSelectViewController*)[segue destinationViewController];
        
        // Pass on required parameters from main file
        selVC.opttitle = [(UIButton*)sender currentTitle];
        
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
            //create buttons for options at runtime
            UIButton *playchoice = [[UIButton alloc] initWithFrame:CGRectMake(25,(160+(40*i)), 150, 25)];
            playchoice.backgroundColor = [UIColor grayColor];
            
            [playchoice setTitle:[dict objectForKey:@"title"] forState:UIControlStateNormal];
            playchoice.tag = i;
            //set their selector using add selector
            [playchoice addTarget:self action:@selector(choiceMade:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:playchoice];
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
//    NSLog(@"viewWillAppear");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
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
