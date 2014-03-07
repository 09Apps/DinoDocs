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
@property (nonatomic,strong) NSString* opttitle;
@property (nonatomic, strong) NSMutableArray* questions;
@property NSUInteger answernum;
@property (nonatomic, strong) NSString* ansdetails;
@property NSUInteger currentqnum;
@property (weak, nonatomic) IBOutlet UILabel *quetxt;
@property NSUInteger timesec;
@property NSUInteger userscore;
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UILabel *qcount;
@property (weak, nonatomic) IBOutlet UILabel *scorelbl;

@property (assign) SystemSoundID rightsnd;
@property (assign) SystemSoundID wrongsnd;

@property NSUInteger const QUIZCOUNT;
@property NSUInteger const ANSTIME;
@property NSString* const WRNGANSTXT;

- (void) handleBack:(id)sender;

@end
