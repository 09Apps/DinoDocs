//
//  DDMainParam.m
//  DinoDoc
//
//  Created by Swapnil Takalkar on 3/1/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import "DDMainParam.h"
#import "DDUtils.h"

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
        // The main plist file should always be named as MainParam.plist
        NSString* plistPath = [DDUtils getPlistPath:@"MainParam"];
        
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
            self.bgsound = [mainparamdict objectForKey:@"bgsound"];
            self.quizbgsound = [mainparamdict objectForKey:@"quizbgsound"];
            self.options = [mainparamdict objectForKey:@"options"];
            self.anstime = [[mainparamdict objectForKey:@"anstime"] integerValue];
            self.rightsound = [mainparamdict objectForKey:@"rightsound"];
            self.wrongsound = [mainparamdict objectForKey:@"wrongsound"];
            self.soundon = [[mainparamdict objectForKey:@"soundon"] boolValue];
            self.showansdetails = [[mainparamdict objectForKey:@"showansdetails"] boolValue];            
        }
    }
    
    return self;
}

@end
