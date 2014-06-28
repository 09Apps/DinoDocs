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
@property (weak, nonatomic) IBOutlet UIButton *b0btn;
@property (weak, nonatomic) IBOutlet UIButton *b7btn;
@property (weak, nonatomic) IBOutlet UIButton *b2btn;
@property (weak, nonatomic) IBOutlet UIButton *b4btn;
@property (weak, nonatomic) IBOutlet UIButton *b5btn;
@property (weak, nonatomic) IBOutlet UIButton *b3btn;
@property (weak, nonatomic) IBOutlet UIButton *b6btn;
@property (weak, nonatomic) IBOutlet UIButton *b1btn;
@property (nonatomic,strong) AVAudioPlayer *bgplayer;
@property NSUInteger currprod;
@end
