//
//  DDUtils.h
//  DinoDoc
//
//  Created by Swapnil Takalkar on 2/22/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDUtils : NSObject
+ (NSString*) stringFromBool:(BOOL) boolvar;
+ (NSString*) getPlistPath:(NSString*) pListName;
+ (NSInteger) randomIntegerFrom:(NSInteger)min To :(NSInteger)max;
+ (NSArray*) randomIntegerArrayFrom:(NSInteger)min To:(NSInteger)max Count:(NSUInteger)size;
+ (UIImage*) imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
@end
