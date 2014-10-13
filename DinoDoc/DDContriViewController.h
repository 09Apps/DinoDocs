//
//  DDContriViewController.h
//  DinoDoc
//
//  Created by Swapnil Takalkar on 9/21/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MBGADMasterVC.h"

@interface DDContriViewController : UIViewController <MFMailComposeViewControllerDelegate, GADBannerViewDelegate>

@property (weak, nonatomic) MBGADMasterVC* shared;

@end
