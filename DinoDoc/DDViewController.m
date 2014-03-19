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

    NSString* bgsoundname = mainparam.bgsound;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:bgsoundname ofType:@"wav"];
    NSURL *pathURL = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)pathURL, &_bgsound);
    AudioServicesPlaySystemSound(_bgsound);
    
    // NEED TO IMPLEMENT
    // CHECK 'newverupdate' PARAMETER IN PLIST IF THERE WERE ANY UPDATES TO PLIST FILE
    // IF 'YES' UPDATE NEW PLIST WITH CONTENTS OF OLD PLIST
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
        playVC.bgplaysound = self.bgsound;
    }
}


@end
