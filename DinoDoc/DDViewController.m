//
//  DDViewController.m
//  DinoDoc
//
//  Created by Swapnil Takalkar on 1/26/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import "DDViewController.h"
#import "DDPlayViewController.h"
#import "DDUtils.h"

@interface DDViewController ()

@end

@implementation DDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    // Read MainParam.plist to get all parameters such as background sound, list on PlayViewController
    [self readMainParam];
    
    // Play background sound
    SystemSoundID bgsound;
    
    // Read the name of background sound file from main param plist
    // Always use wav file less than 30 sec for bgsound
    NSString* bgsoundname = [[self mainparamdict] objectForKey:@"bgsound"];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:bgsoundname ofType:@"wav"];
    NSURL *pathURL = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)pathURL, &bgsound);
    AudioServicesPlaySystemSound(bgsound);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DDPlayViewController *playVC = (DDPlayViewController*)[segue destinationViewController];
    playVC.options = [self.mainparamdict objectForKey:@"options"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) readMainParam
{
    // The main plist file should always be named as MainParam.plist
    NSString* plistPath = [DDUtils getPlistPath:@"MainParam"];
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    
    // convert static property list into dictionary object
    self.mainparamdict = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    
    if (! [self mainparamdict])
    {
        NSLog(@"readMainParam: error reading MainParam, desc: %@, format: %d", errorDesc, format);
    }
}



@end
