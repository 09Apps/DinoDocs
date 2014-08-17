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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

	// Get the singleton instance of main param
    DDMainParam* mainparam = [DDMainParam sharedInstance];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:mainparam.badgebgimg]];
    
    UIButton *homebtn=[[UIButton alloc]initWithFrame:CGRectMake(10,25,42, 46)];
    [homebtn setImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
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
        NSLog(@"readMainParam: error reading Badge plist, desc: %@", errorDesc);
    }
    else
    {
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
                
                //create labels for badges
                UILabel *badgelbl = [[UILabel alloc] initWithFrame:CGRectMake((scrwidth*0.32*nwidthindex),nheightindex,BADGEWIDTH,BADGEHEIGHT)];
                NSString* img = [bgdict objectForKey:@"enabledimg"];
                badgelbl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:img]];
                widthindex++;
                [self.view addSubview:badgelbl];
            }
        }
    }
}

+ (NSString*) checkBadgeForQuiz:(NSString*)quiztype
                      WithScore:(int)score
{
    NSString* str;
    return str;
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


@end
