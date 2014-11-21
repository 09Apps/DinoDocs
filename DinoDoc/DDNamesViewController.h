//
//  DDNamesViewController.h
//  DinoDoc
//
//  Created by Swapnil Takalkar on 11/15/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface DDNamesViewController : UIViewController <UIWebViewDelegate, MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *cwebview;
@property (nonatomic,strong) MBProgressHUD *HUD;

@end
