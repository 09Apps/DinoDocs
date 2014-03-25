//
//  DDSettingTblViewController.h
//  DinoDoc
//
//  Created by Swapnil Takalkar on 3/13/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface DDSettingTblViewController : UITableViewController

@property BOOL soundon;
@property BOOL showansdetails;
@property (nonatomic,strong) AVAudioPlayer *bgplayer;

@end
