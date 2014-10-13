//
//  MBGADMasterVC.h
//  KichenCalender
//
//  Created by Swapnil Takalkar on 9/3/13.
//  Copyright (c) 2013 09Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"

@interface MBGADMasterVC : UIViewController<GADBannerViewDelegate>  {
    GADBannerView *adBanner_;
    BOOL didCloseWebsiteView_;
    BOOL isLoaded_;
    id currentDelegate_;
}

-(void)resetAdView:(UIViewController *)rootViewController;
+(MBGADMasterVC *)singleton;

@end
