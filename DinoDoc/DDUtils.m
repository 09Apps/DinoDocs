//
//  DDUtils.m
//  DinoDoc
//
//  Created by Swapnil Takalkar on 2/22/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//  This is utilities class. 

#import "DDUtils.h"

@implementation DDUtils

+ (NSString*) stringFromBool:(BOOL) boolvar
{
    return boolvar? @"YES" : @"NO";
}
    
+ (NSString*) getPlistPath:(NSString*) pListName
{
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    
    //Take care of versioning of pList file
    NSString* plistver = [pListName stringByAppendingString:[NSString stringWithFormat:@"_%@",
                                                             [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]]];
    
    NSString *filename = [plistver stringByAppendingString:@".plist"];
    
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
            NSLog(@"getPlistPath: file %@ Error in saveData: %@", pListName,err);
            return pBundlePath;
        }
    }
//    NSLog(@"plistPath %@",plistPath);
    return plistPath;
}

+ (NSInteger) randomIntegerFrom:(NSInteger)min
                            To :(NSInteger)max
{
    // Gives a single random number
    NSUInteger range = max - min + 1;
    return (min + (arc4random() % range));
}

+ (NSArray*) randomIntegerArrayFrom:(NSInteger)min
                               To :(NSInteger)max
                             Count:(NSUInteger)size
{
    // This method gives an array of unique random numbers. Arraysize = size
    NSUInteger range = max - min + 1;
    NSUInteger szctr = 0;
    NSMutableArray* randomarr = [[NSMutableArray alloc] init];
    
    while (szctr < size)
    {
        BOOL numrepeated = NO;
        NSUInteger randnum = (min + (arc4random() % range));

        for (id rnd in randomarr)
        {
            if ([rnd integerValue] == randnum)
            {
                numrepeated = YES;
                break;
            }
        }
        
        if (numrepeated == NO)
        {
            [randomarr addObject:[NSNumber numberWithInteger:randnum]];
            szctr++;
        }
    }
    
    return randomarr;
//    return [NSArray arrayWithObjects:@"3",@"11",@"7",@"15",@"6",nil];
}

@end
