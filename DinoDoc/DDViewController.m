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
    
//    self.view.backgroundColor = [UIColor clearColor];
//    self.view.opaque = NO;
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:mainparam.bgimg]];
    
    NSString* bgsoundname = mainparam.bgsound;
    NSString *path = [[NSBundle mainBundle] pathForResource:bgsoundname ofType:@"wav"];
    NSURL *pathURL = [NSURL fileURLWithPath:path];
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:pathURL error:nil];
    [self.player setNumberOfLoops:-1]; //infinite
    
    if (self.soundon)
    {
        [self.player play];
    }
    
    self.navigationItem.title = mainparam.maintitle;
    
    NSString* playernm = @"Hello ";
    self.playername.text = [playernm stringByAppendingString:mainparam.playername];
    
    // NEED TO IMPLEMENT
    // CHECK 'newverupdate' PARAMETER IN PLIST IF THERE WERE ANY UPDATES TO PLIST FILE
    // IF 'YES' UPDATE NEW PLIST WITH CONTENTS OF OLD PLIST
    
    [self.navigationItem setHidesBackButton:YES animated:NO];    
}

- (void)viewWillAppear:(BOOL)animated
{
    DDMainParam* mainparam = [DDMainParam sharedInstance];
    NSString* playernm = @"Hello ";
    self.playername.text = [playernm stringByAppendingString:mainparam.playername];
    
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
- (IBAction)infoPressed:(UIButton *)sender
{
    MBInfoVC* infoVC = [[MBInfoVC alloc] init];
    [self.navigationController pushViewController:infoVC animated:YES];
}


@end
