//
//  DDViewController.m
//  DinoDoc
//
//  Created by Swapnil Takalkar on 1/26/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import "DDViewController.h"
#import "DDPlayViewController.h"
#import "DDSettingTblViewController.h"
#import "DDMainParam.h"
#import "MBInfoVC.h"

@interface DDViewController ()

@end

@implementation DDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Play background sound
    // Read the name of background sound file from main param plist
    // Always use wav file less than 30 sec for bgsound
    // Call the singleton object for main param file
    
    DDMainParam* mainparam = [DDMainParam sharedInstance];
    self.soundon = mainparam.soundon;
    
    UIImage *homeimg = [UIImage imageNamed:mainparam.homebgimg];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:homeimg];
    
    UIImage *navimg = [UIImage imageNamed:mainparam.navimg];
    [self.navigationController.navigationBar setBackgroundImage:navimg forBarMetrics: UIBarMetricsDefault];
    
    NSString* bgsoundname = mainparam.bgsound;
    NSString *path = [[NSBundle mainBundle] pathForResource:bgsoundname ofType:@"wav"];
    NSURL *pathURL = [NSURL fileURLWithPath:path];
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:pathURL error:nil];
//  [self.player setNumberOfLoops:-1]; //infinite
    
    if (self.soundon)
    {
        [self.player play];
    }
    
    // NEED TO IMPLEMENT
    // CHECK 'newverupdate' PARAMETER IN PLIST IF THERE WERE ANY UPDATES TO PLIST FILE
    // IF 'YES' UPDATE NEW PLIST WITH CONTENTS OF OLD PLIST

    UIButton *stngbtn=[[UIButton alloc]initWithFrame:CGRectMake(10,25,48, 46)];
    [stngbtn setImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
    [stngbtn addTarget:self action:@selector(handleSettings:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *stbarbtn=[[UIBarButtonItem alloc]initWithCustomView:stngbtn];
    self.navigationItem.rightBarButtonItem=stbarbtn;
    
    UIButton *infobtn=[[UIButton alloc]initWithFrame:CGRectMake(10,25,42, 46)];
    [infobtn setImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
    [infobtn addTarget:self action:@selector(infoPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *infobarbtn=[[UIBarButtonItem alloc]initWithCustomView:infobtn];
    self.navigationItem.leftBarButtonItem=infobarbtn;

}

- (void)viewWillAppear:(BOOL)animated
{
    DDMainParam* mainparam = [DDMainParam sharedInstance];
    
    self.soundon = mainparam.soundon;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier compare:@"playseg"] == NSOrderedSame)
    {
        DDPlayViewController *playVC = (DDPlayViewController*)[segue destinationViewController];
        
        // Pass on soundid to Play VC as we will stop it at exit of play VC
        playVC.bgplayer = self.player;
    }
    else if ([segue.identifier compare:@"settingseg"] == NSOrderedSame)
    {
        DDSettingTblViewController *settingTVC = (DDSettingTblViewController*)[segue destinationViewController];
        
        // Pass on soundid to Play VC as we will stop it at exit of play VC
        settingTVC.bgplayer = self.player;
    }
}
- (void)infoPressed:(UIButton *)sender
{
    MBInfoVC* infoVC = [[MBInfoVC alloc] init];
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (void)handleSettings:(UIBarButtonItem*)navbarbutton
{
    [self performSegueWithIdentifier:@"settingseg" sender:navbarbutton];
}

@end
