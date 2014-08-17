//
//  DDBadgesViewController.h
//  DinoDoc
//
//  Created by Swapnil Takalkar on 1/28/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface DDBadgesViewController : UIViewController
@property (nonatomic,strong) AVAudioPlayer *bgplayer;
@property (strong, nonatomic) NSArray* badges;

+ (NSString*) checkBadgeForQuiz:(NSString*)quiztype
                      WithScore:(int)score;

@end
