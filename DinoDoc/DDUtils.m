//
//  DDUtils.m
//  DinoDoc
//
//  Created by Swapnil Takalkar on 2/22/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//  This is utilities class. 

#import "DDUtils.h"
#import "DDDefines.h"

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
        // Copy Plist to document directory
        NSFileManager* manager = [NSFileManager defaultManager];
        NSError *err;
        
        if ([pListName compare:MAINPARAM] == NSOrderedSame || [pListName compare:BADGES] == NSOrderedSame)
        {
            // We want to use some Plist files from old version, so let's copy them
            // Step 1 - reduce BundleVersion by 0.1 to go to old version of plist
            NSString *curver = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
            
            float oldver = [curver floatValue] - 0.1;
            NSString *oldplistver = [pListName stringByAppendingString:[NSString stringWithFormat:@"_%.1f",oldver]];
            
            NSString *oldplist = [oldplistver stringByAppendingString:@".plist"];
            NSString *oldplistPath = [documentsPath stringByAppendingPathComponent:oldplist];
            
            // check to see if this old plist exists in documents
            if ([[NSFileManager defaultManager] fileExistsAtPath:oldplistPath])
            {
                [manager copyItemAtPath:oldplistPath toPath:plistPath error:&err];
                
                if(err)
                {
                    NSLog(@"getPlistPath: file %@ Error in saveData: %@", oldplist,err);
                }
                else
                {
                    return plistPath;
                }
            }
        }
        
        // if not in documents, get property list from main bundle
        NSString* pBundlePath = [[NSBundle mainBundle] pathForResource:pListName ofType:@"plist"];
        [manager copyItemAtPath:pBundlePath toPath:plistPath error:&err];
            
        if(err)
        {
            NSLog(@"getPlistPath: file %@ Error in saveData: %@", pListName,err);
            return pBundlePath;
        }
    }
    // NSLog(@"plistPath %@",plistPath);
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

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
