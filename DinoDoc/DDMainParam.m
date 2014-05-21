//
//  DDMainParam.m
//  DinoDoc
//
//  Created by Swapnil Takalkar on 3/1/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import "DDMainParam.h"
#import "DDUtils.h"
#import "DDDefines.h"

@implementation DDMainParam

+ (DDMainParam*)sharedInstance
{
    static DDMainParam *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[DDMainParam alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    if (self = [super init])
    {
        // The main plist file 
        NSString* plistPath = [DDUtils getPlistPath:MAINPARAM];
        
        // read property list into memory as an NSData object
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        
        // convert static property list into dictionary object
        NSDictionary* mainparamdict = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
        
        if (! mainparamdict)
        {
            NSLog(@"readMainParam: error reading MainParam, desc: %@, format: %d", errorDesc, format);
        }
        else
        {
            self.newverupd = [[mainparamdict objectForKey:@"newverupdate"] boolValue];
            self.maintitle = [mainparamdict objectForKey:@"maintitle"];
            self.playername = [mainparamdict objectForKey:@"playername"];
            self.anstime = [[mainparamdict objectForKey:@"anstime"] integerValue];
            self.bgsound = [mainparamdict objectForKey:@"bgsound"];
            self.bgimg = [mainparamdict objectForKey:@"bgimg"];
            self.showads = [[mainparamdict objectForKey:@"showads"] boolValue];
            self.quizbgsound = [mainparamdict objectForKey:@"quizbgsound"];
            self.wrongsound = [mainparamdict objectForKey:@"wrongsound"];
            self.rightsound = [mainparamdict objectForKey:@"rightsound"];
            self.soundon = [[mainparamdict objectForKey:@"soundon"] boolValue];
            self.showansdetails = [[mainparamdict objectForKey:@"showansdetails"] boolValue];
            self.options = [mainparamdict objectForKey:@"options"];
        }
    }
    return self;
}

- (void) updateMainParam
{
    NSArray* keyarr = [[NSArray alloc] initWithObjects: @"newverupdate",
                                                        @"maintitle",
                                                        @"playername",
                                                        @"anstime",
                                                        @"bgsound",
                                                        @"bgimg",
                                                        @"showads",
                                                        @"quizbgsound",
                                                        @"wrongsound",
                                                        @"rightsound",
                                                        @"soundon",
                                                        @"showansdetails",
                                                        @"options", nil];

    NSString* nsnewver = [DDUtils stringFromBool:self.newverupd];
    NSString* nssndon = [DDUtils stringFromBool:self.soundon];
    NSString* nsansdet = [DDUtils stringFromBool:self.showansdetails];
    NSString* nsshowads = [DDUtils stringFromBool:self.showads];
    NSString* nsanstime = [NSString stringWithFormat:@"%d",self.anstime];
    
    NSArray* valarr = [NSArray arrayWithObjects: nsnewver,
                                                self.maintitle,
                                                self.playername,
                                                nsanstime,
                                                self.bgsound,
                                                self.bgimg,
                                                nsshowads,
                                                self.quizbgsound,
                                                self.wrongsound,
                                                self.rightsound,
                                                nssndon,
                                                nsansdet,
                                                self.options, nil];
    
    NSDictionary* mainparam = [[NSDictionary alloc] initWithObjects:valarr forKeys:keyarr];
    
    NSString* plistPath = [DDUtils getPlistPath:MAINPARAM];
    
    NSString *error = nil;
    
    // create NSData from dictionary
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:mainparam format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    
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
@end
