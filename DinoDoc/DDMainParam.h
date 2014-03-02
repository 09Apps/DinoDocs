//
//  DDMainParam.h
//  DinoDoc
//
//  Created by Swapnil Takalkar on 3/1/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDMainParam : NSObject

@property (nonatomic,retain) NSString* bgsound;
@property (nonatomic,retain) NSString* rightsound;
@property (nonatomic,retain) NSString* wrongsound;
@property (nonatomic,strong) NSArray* options;
@property NSUInteger anstime;

+ (DDMainParam*)sharedInstance;

@end
