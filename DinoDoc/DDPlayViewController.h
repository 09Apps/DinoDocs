//
//  DDPlayViewController.h
//  DinoDoc
//
//  Created by Swapnil Takalkar on 1/28/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface DDPlayViewController : UIViewController
@property (nonatomic,strong) AVAudioPlayer *bgplayer;
@property (nonatomic,strong) UIActivityIndicatorView *spinner;
@property NSUInteger currprod;
@end
