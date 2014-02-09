//
//  DDSelectViewController.m
//  DinoDoc
//
//  Created by Swapnil Takalkar on 1/31/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import "DDSelectViewController.h"

@interface DDSelectViewController ()

@end

@implementation DDSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
- (id)initWithAnimalType:(NSUInteger)type
{
    self.animaltype = type;
    return self;
}
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSString* plistPath = [self getPlistPath:@"TRexQA"];
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    
    // convert static property list into dictionary object
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    
    if (!temp)
    {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    self.opt1.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.opt2.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.opt3.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.opt4.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.questions = [temp objectForKey:@"QArr"];
    
    for (NSDictionary* que in self.questions)
    {
        BOOL userknows = [[que objectForKey:@"UserGaveAns"] boolValue];
        
        if ( userknows == NO )
        {
            self.quetxt.text = [que objectForKey:@"Question"];
            
            [self.opt1 setTitle:[que objectForKey:@"Option1"] forState:UIControlStateNormal];
            [self.opt2 setTitle:[que objectForKey:@"Option2"] forState:UIControlStateNormal];
            [self.opt3 setTitle:[que objectForKey:@"Option3"] forState:UIControlStateNormal];
            [self.opt4 setTitle:[que objectForKey:@"Option4"] forState:UIControlStateNormal];

            break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*) getPlistPath:(NSString*) pListName
{
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *filename = [pListName stringByAppendingString:@".plist"];
    
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:filename];
    
    // check to see if Data.plist exists in documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        NSError *err;
        // if not in documents, get property list from main bundle
        NSString* pBundlePath = [[NSBundle mainBundle] pathForResource:pListName ofType:@"plist"];
        
        // Copy Plist to document directory
        NSFileManager* manager = [NSFileManager defaultManager];
        [manager copyItemAtPath:pBundlePath toPath:plistPath error:&err];
        
        if(err)
        {
            NSLog(@"Error in saveData: %@", err);
            return pBundlePath;
        }
    }
    return plistPath;
}


@end
