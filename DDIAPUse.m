//
//  DDIAPUse.m
//  DinoDoc
//
//  Created by Swapnil Takalkar on 5/31/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import "DDIAPUse.h"
#import "DDMainParam.h"    

@implementation DDIAPUse

+ (DDIAPUse *)sharedInstance
{
    static dispatch_once_t once;
    static DDIAPUse * sharedInstance;

    dispatch_once(&once, ^{
        DDMainParam* mainparam = [DDMainParam sharedInstance];
        NSUInteger optionscount = [mainparam.options count];
        NSMutableSet* productIdentifiers = [[NSMutableSet alloc] init];
        
        for (int i=0; i<optionscount; i++)
        {
            NSDictionary* dict = [mainparam.options objectAtIndex:i];
            [productIdentifiers addObject:[dict objectForKey:@"productid"]];
        }

        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
        
    });
    
    return sharedInstance;
}

@end





