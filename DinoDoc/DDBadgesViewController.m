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
        NSLog(@"readMainParam: error reading MainParam, desc: %@, format: %d", errorDesc, format);
    }
    else
    {
        self.badges = [dict objectForKey:@"Badges"];
        
        NSUInteger bcount = [self.badges count];
        
        for (int i=0; i<bcount; i++)
        {
            NSDictionary* bgdict = [self.badges objectAtIndex:i];
            
            //create buttons for options at runtime
            UILabel *badgelbl = [[UILabel alloc] initWithFrame:CGRectMake(25,(160+(40*i)), 150, 25)];
            
            [badgelbl setText:[bgdict objectForKey:@"title"]];
            
            [self.view addSubview:badgelbl];
        }
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
