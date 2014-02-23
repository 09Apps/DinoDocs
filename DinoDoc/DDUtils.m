//
//  DDUtils.m
//  DinoDoc
//
//  Created by Swapnil Takalkar on 2/22/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//  This is utilities class. 

#import "DDUtils.h"

@implementation DDUtils

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

@end
