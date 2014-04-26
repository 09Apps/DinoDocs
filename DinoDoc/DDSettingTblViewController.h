//
//  DDSettingTblViewController.h
//  DinoDoc
//
//  Created by Swapnil Takalkar on 3/13/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface DDSettingTblViewController : UITableViewController <UITextFieldDelegate>

@property BOOL soundon;
@property BOOL showansdetails;
@property (nonatomic,strong) AVAudioPlayer *bgplayer;
@property (nonatomic,strong) NSString* playername;

@end
