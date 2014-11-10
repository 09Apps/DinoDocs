//
//  DDBadgesViewController.h
//  DinoDoc
//
//  Created by Swapnil Takalkar on 1/28/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MBGADMasterVC.h"

@interface DDBadgesViewController : UIViewController <GADBannerViewDelegate>
@property (nonatomic,strong) AVAudioPlayer *bgplayer;

@property (strong, nonatomic) NSArray* badges;
@property BOOL newverupd;
@property NSUInteger quizcounter;
@property (weak, nonatomic) MBGADMasterVC* shared;

-(NSString*) checkBadgeForQuiz:(NSString*)quiztype
                    WithScore:(NSUInteger)score
                        Outof:(NSUInteger)outofcount
                        InTime:(NSUInteger)totaltime;
-(NSString*) getTitle;

@end
