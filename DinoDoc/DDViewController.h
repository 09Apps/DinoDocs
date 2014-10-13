//
//  DDViewController.h
//  DinoDoc
//
//  Created by Swapnil Takalkar on 1/26/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface DDViewController : UIViewController

@property (nonatomic,strong) AVAudioPlayer *player;
@property BOOL soundon;
@property (weak, nonatomic) IBOutlet UILabel *playernm;
@end
