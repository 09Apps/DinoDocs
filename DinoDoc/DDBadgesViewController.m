//
//  DDBadgesViewController.m
//  DinoDoc
//
//  Created by Swapnil Takalkar on 1/28/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import "DDBadgesViewController.h"
#import "DDDefines.h"
#import "DDUtils.h"
#import "DDMainParam.h"    

@interface DDBadgesViewController ()

@end

@implementation DDBadgesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

	// Get the singleton instance of main param
    DDMainParam* mainparam = [DDMainParam sharedInstance];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:mainparam.badgebgimg]];
    
    UIButton *homebtn=[[UIButton alloc]initWithFrame:CGRectMake(10,25,42, 46)];
    [homebtn setImage:[UIImage imageNamed:HOMEICON] forState:UIControlStateNormal];
    [homebtn addTarget:self action:@selector(goHome:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homebarbtn=[[UIBarButtonItem alloc]initWithCustomView:homebtn];
    self.navigationItem.leftBarButtonItem=homebarbtn;
 
    // The badges plist file
    NSString* plistPath = [DDUtils getPlistPath:BADGES];
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    
    // convert static property list into dictionary object
    NSDictionary* dict = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    
    if (! dict)
    {
        NSLog(@"Error reading Badge plist, desc: %@", errorDesc);
    }
    else
    {
        self.newverupd = [[dict objectForKey:@"newverupdate"] boolValue];
        self.quizcounter = [[dict objectForKey:@"quizcounter"] integerValue];
        self.badges = [dict objectForKey:@"Badges"];
        
        NSUInteger bcount = [self.badges count];
        CGFloat scrwidth = CGRectGetWidth(self.view.bounds);
        CGFloat scrheight = CGRectGetHeight(self.view.bounds);
        NSUInteger widthindex = 0;

        for (int i=0; i<bcount;i++)
        {
            NSDictionary* bgdict = [self.badges objectAtIndex:i];
            BOOL isenabled = [[bgdict objectForKey:@"enabled"] boolValue];
            
            if (isenabled)
            {
                NSUInteger heightindex = (widthindex/3)+1; // To get height
                NSUInteger nwidthindex = widthindex - ((heightindex-1)*3);
                NSUInteger nheightindex = (scrheight*0.23)+((heightindex-1)*(BADGEHEIGHT*0.8));
                
                //create buttons for badges
                UIButton *bdgbtn = [[UIButton alloc] initWithFrame:CGRectMake((scrwidth*0.32*nwidthindex),nheightindex,BADGEWIDTH,BADGEHEIGHT)];
                NSString* img = [bgdict objectForKey:@"enabledimg"];
                UIImage *mybdg = [DDUtils imageWithImage:[UIImage imageNamed:img] scaledToSize:CGSizeMake(110, 110)];
                [bdgbtn setImage:mybdg forState:UIControlStateNormal];
                [bdgbtn setTag:i];
                [bdgbtn addTarget:self action:@selector(badgeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                widthindex++;
                [self.view addSubview:bdgbtn];
            }
        }
    }
}

-(NSString*) checkBadgeForQuiz:(NSString*)quiztype
                     WithScore:(NSUInteger)score
                         Outof:(NSUInteger)outofcount
                        InTime:(NSUInteger)totaltime
{    
    // The badges plist file
    NSString* plistPath = [DDUtils getPlistPath:BADGES];
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    
    // convert static property list into dictionary object
    NSMutableDictionary* dict = (NSMutableDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    
    if (! dict)
    {
        NSLog(@"readMainParam: error reading Badge plist, desc: %@", errorDesc);
    }
    else
    {
        self.newverupd = [[dict objectForKey:@"newverupdate"] boolValue];
        self.quizcounter = [[dict objectForKey:@"quizcounter"] integerValue];
        self.badges = [dict objectForKey:@"Badges"];
        
        NSUInteger bcount = [self.badges count];
        NSUInteger earnedbadges = 0;

        for (int i=0; i<bcount;i++)
        {
            NSMutableDictionary* bgdict = [self.badges objectAtIndex:i];
                
            BOOL isenabled = [[bgdict objectForKey:@"enabled"] boolValue];
            NSString* nsenabled = [DDUtils stringFromBool:YES];
            NSString* titlestr = [bgdict objectForKey:@"title"];
                
            if (isenabled == NO)
            {
                // Check if beginner
                if (self.quizcounter == 0)
                {
                    if ([titlestr compare:@"First_Quiz"] == NSOrderedSame)
                    {
                        [bgdict setObject:nsenabled forKey:@"enabled"];
                        self.quizcounter++;
                        [self updateBadgeParam];
                        return [bgdict objectForKey:@"enabledimg"];
                    }
                }

                if (score > outofcount*BADGEFACTOR)
                {
                    //Check if fast
                    if (totaltime <= SPEEDMASTERFACTOR*outofcount )
                    {
                        if ([titlestr compare:@"Speed"] == NSOrderedSame)
                        {
                            [bgdict setObject:nsenabled forKey:@"enabled"];
                            self.quizcounter++;
                            [self updateBadgeParam];
                            return [bgdict objectForKey:@"enabledimg"];
                        }
                    }
                    
                    //Check if any other badge
                    if ([titlestr compare:quiztype] == NSOrderedSame)
                    {
                        [bgdict setObject:nsenabled forKey:@"enabled"];
                        self.quizcounter++;
                        [self updateBadgeParam];
                        return [bgdict objectForKey:@"enabledimg"];
                    }
                    
                }
                
                //Check if quiz master
                if (self.quizcounter > QUIZMASTERFACTOR )
                {
                    if ([titlestr compare:@"QuizMaster"] == NSOrderedSame)
                    {
                        [bgdict setObject:nsenabled forKey:@"enabled"];
                        self.quizcounter++;
                        [self updateBadgeParam];
                        return [bgdict objectForKey:@"enabledimg"];
                    }
                }
                
                // Check if Quiz doctor
                if (bcount == QUIZDOCFACTOR)
                {
                    if ([titlestr compare:@"QuizDoc"] == NSOrderedSame)
                    {
                        [bgdict setObject:nsenabled forKey:@"enabled"];
                        self.quizcounter++;
                        [self updateBadgeParam];
                        return [bgdict objectForKey:@"enabledimg"];
                    }
                }
                
            }
            else
            {
                earnedbadges++;
            }
        }
    }
    
    self.quizcounter++;
    [self updateBadgeParam];
    return nil;
}

-(void) updateBadgeParam
{
    NSArray* keyarr = [[NSArray alloc] initWithObjects: @"newverupdate",
                       @"quizcounter",
                       @"Badges", nil];
    
    NSString* nsnewver = [DDUtils stringFromBool:self.newverupd];
    NSString* nsquizcounter = [NSString stringWithFormat:@"%lu",(unsigned long)self.quizcounter];
    
    NSArray* valarr = [NSArray arrayWithObjects: nsnewver,
                       nsquizcounter,
                       self.badges, nil];
    
    NSDictionary* bdgparam = [[NSDictionary alloc] initWithObjects:valarr forKeys:keyarr];
    
    NSString* plistPath = [DDUtils getPlistPath:BADGES];
    
    NSString *error = nil;
    
    // create NSData from dictionary
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:bdgparam format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    
    // check is plistData exists
    if(plistData)
    {
        // write plistData to our Data.plist file
        [plistData writeToFile:plistPath atomically:YES];
    }
    else
    {
        NSLog(@"Error in saveData: %@", error);
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goHome:(id)navbarbutton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)badgeButtonPressed:(UIButton*)navbarbutton
{
    
    NSDictionary* bgdict = [self.badges objectAtIndex:navbarbutton.tag];
    NSString* descstr = [bgdict objectForKey:@"description"];
    NSString* detstr = [bgdict objectForKey:@"details"];
    NSString* imgstr = [bgdict objectForKey:@"enabledimg"];
    
    UIImage *mybdg = [DDUtils imageWithImage:[UIImage imageNamed:imgstr] scaledToSize:CGSizeMake(155, 155)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 40, 195, 195)];
    [imageView setImage:mybdg];
 /*
    CGFloat scrwidth = CGRectGetWidth(self.view.bounds);
    CGFloat scrheight = CGRectGetHeight(self.view.bounds);
    UIView* showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrwidth*0.6 , scrheight* 0.6)];
*/
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:descstr message:detstr delegate:self cancelButtonTitle:@"Cool" otherButtonTitles: nil];

    //check if os version is 7 or above
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        [alert setValue:imageView forKey:@"accessoryView"];
    }else{
        [alert addSubview:imageView];
    }
    [alert show];
}

-(NSString*) getTitle
{
    // The badges plist file
    NSString* plistPath = [DDUtils getPlistPath:BADGES];
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    
    // convert static property list into dictionary object
    NSDictionary* dict = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    
    if (! dict)
    {
        NSLog(@"readMainParam: error reading Badge plist, desc: %@", errorDesc);
    }
    else
    {
        self.badges = [dict objectForKey:@"Badges"];
        NSUInteger bcount = [self.badges count];
        
        NSUInteger earnedbadges = 0;
        
        for (int i=0; i<bcount;i++)
        {
            NSMutableDictionary* bgdict = [self.badges objectAtIndex:i];
            
            BOOL isenabled = [[bgdict objectForKey:@"enabled"] boolValue];
            if (isenabled )
            {
                earnedbadges++;
            }
        }
        
        if (earnedbadges > 8)
        {
            return HIGHTITLE;
        }
        else if (earnedbadges > 5)
        {
            return MEDTITLE;
        }
        else if (earnedbadges > 2)
        {
            return LOWTITLE;
        }
    }
    
    return NOTITLE;
}

@end
