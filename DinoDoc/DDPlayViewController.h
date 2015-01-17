//
//  DDPlayViewController.h
//  DinoDoc
//
//  Created by Swapnil Takalkar on 1/28/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DDSettingTblViewController.h"
#import "MBGADMasterVC.h"

@interface DDPlayViewController : UIViewController <DDSettingTblViewControllerDelegate, GADBannerViewDelegate>
@property (nonatomic,strong) AVAudioPlayer *bgplayer;
@property (atomic,strong) UIActivityIndicatorView *spinner;
@property (weak, nonatomic) MBGADMasterVC* shared;
@property NSUInteger currprod;
@property BOOL adshow;
@end
