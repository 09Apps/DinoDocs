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

@interface DDPlayViewController ()

@end

@implementation DDPlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)choicemade:(UIButton *)senderbutton
{
    [self performSegueWithIdentifier:@"selseg" sender:senderbutton];
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
    
    UIBarButtonItem *settingbutton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(handleSettings:)];
    self.navigationItem.rightBarButtonItem = settingbutton;
    
    // Overwritting back button, so it goes to home screen even caled from anywhere
    UIBarButtonItem *homebutton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(goHome:)];
    self.navigationItem.leftBarButtonItem = homebutton;
    
    self.navigationItem.title = @"Select Quiz";
    
	// Get the singleton instance of main param
    DDMainParam* mainparam = [DDMainParam sharedInstance];
    
//    self.view.backgroundColor = [UIColor clearColor];
//    self.view.opaque = NO;
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:mainparam.bgimg]];
    
    NSUInteger optionscount = [mainparam.options count];
    
    for (int i=0; i<optionscount; i++)
    {
        NSDictionary* dict = [mainparam.options objectAtIndex:i];
        
        //create buttons for options at runtime
        UIButton *playchoice = [[UIButton alloc] initWithFrame:CGRectMake(25,(160+(40*i)), 150, 25)];
        playchoice.backgroundColor = [UIColor grayColor];
        
        [playchoice setTitle:[dict objectForKey:@"title"] forState:UIControlStateNormal];
        
        //set their selector using add selector
        [playchoice addTarget:self action:@selector(choicemade:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:playchoice];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
//    NSLog(@"viewWillAppear");
    UIBarButtonItem *settingbutton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(handleSettings:)];
    self.navigationItem.rightBarButtonItem = settingbutton;
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
    [self performSegueWithIdentifier:@"gohome" sender:navbarbutton];
}

@end
