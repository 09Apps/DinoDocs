//
//  DDSelectViewController.h
//  DinoDoc
//
//  Created by Swapnil Takalkar on 1/31/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

extern


@interface DDSelectViewController : UIViewController

- (void)showQuestions;

@property (weak, nonatomic) IBOutlet UILabel *timerlabel;
@property (nonatomic,strong) NSString* optname;
@property NSUInteger answernum;
@property NSUInteger currentqnum;
@property NSUInteger timesec;
@property (nonatomic, strong) NSArray* questions;
@property (nonatomic, strong) NSString* ansdetails;
@property (weak, nonatomic) IBOutlet UILabel *quetxt;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSString* rightsoundfile;
@property (nonatomic, strong) NSString* wrongsoundfile;

@property (assign) SystemSoundID rightsound;
@property (assign) SystemSoundID wrongsound;

@property NSUInteger const QUIZCOUNT;
@property NSUInteger const ANSTIME;
@property NSString* const WRNGANSTXT;

- (void) handleBack:(id)sender;

@end
