//
//  DDResultViewController.h
//  DinoDoc
//
//  Created by Swapnil Takalkar on 3/8/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MBGADMasterVC.h"

@interface DDResultViewController : UIViewController<GADBannerViewDelegate>

@property NSUInteger score;
@property NSUInteger quizcount;
@property NSUInteger totaltime;
@property BOOL soundon;
@property BOOL adshow;
@property (nonatomic,strong) NSString* quiztype;
@property (weak, nonatomic) IBOutlet UILabel *scorelbl;
@property (weak, nonatomic) IBOutlet UILabel *namelbl;
@property (weak, nonatomic) IBOutlet UILabel *bdglbl;
@property (weak, nonatomic) IBOutlet UILabel *bdgimglbl;
@property (nonatomic,strong) AVAudioPlayer *player;

@property (weak, nonatomic) MBGADMasterVC* shared;

@end
