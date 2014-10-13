//
//  DDSettingTblViewController.h
//  DinoDoc
//
//  Created by Swapnil Takalkar on 3/13/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"
#import "MBGADMasterVC.h"

@protocol DDSettingTblViewControllerDelegate
- (void)modalDialogClosed:(UIViewController *)viewController;
//- (void)modalDialogClosed;
@end

@interface DDSettingTblViewController : UITableViewController <UITextFieldDelegate, MBProgressHUDDelegate, GADBannerViewDelegate>

@property BOOL soundon;
@property BOOL showansdetails;
@property BOOL restored;
@property (nonatomic,strong) AVAudioPlayer *bgplayer;
@property (nonatomic,strong) NSString* playername;
@property (nonatomic,strong) NSString* btnbgimg;
//@property (atomic,strong) UIActivityIndicatorView *spinner;
@property (assign) id<DDSettingTblViewControllerDelegate> delegate;
@property (nonatomic,strong) MBProgressHUD *HUD;
@property (weak, nonatomic) MBGADMasterVC* shared;

@end
