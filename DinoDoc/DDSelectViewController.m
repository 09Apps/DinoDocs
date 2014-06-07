//
//  DDSelectViewController.m
//  DinoDoc
//
//  Created by Swapnil Takalkar on 1/31/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import "DDSelectViewController.h"
#import "DDMainParam.h"
#import "DDDefines.h"
#import "DDUtils.h"
#import "DDResultViewController.h"

@interface DDSelectViewController ()

@end

@implementation DDSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // get the mainparam singleton
    DDMainParam* mainparam = [DDMainParam sharedInstance];
    
//    self.view.backgroundColor = [UIColor clearColor];
//    self.view.opaque = NO;
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:mainparam.bgimg]];
    
	// Overwritting back button, so I can clean up timer and other objects
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] initWithTitle:@"Quit" style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem = backbutton;
    self.navigationItem.title = mainparam.maintitle;    
    
    self.btnbgimg = mainparam.btnbgimg;
    
    // The name of the plist file with questions and answers for each option must match
    // with the button title
    NSString* plistPath = [DDUtils getPlistPath:self.opttitle];
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    
    // convert static property list into dictionary object
    NSDictionary *dict = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    
    if (!dict)
    {
        NSLog(@"Error reading plist: %@", errorDesc);
    }
    
    self.questions = [dict objectForKey:@"QArr"];
    
    self.WRNGANSTXT = [dict objectForKey:@"WrongAnsTxt"];
    self.QUIZCOUNT = [[dict objectForKey:@"Quizcount"] integerValue];

    self.ANSTIME = mainparam.anstime;
    self.showansdetails = mainparam.showansdetails;
    
    // play backgrund sound if not muted
    self.soundon = mainparam.soundon;
    NSString* qzbgsndname = mainparam.quizbgsound;
    
    // Keep the sounds ready, but don't play them
    NSString *qzsndpath = [[NSBundle mainBundle] pathForResource:qzbgsndname ofType:@"wav"];
    NSURL *qzpathURL = [NSURL fileURLWithPath:qzsndpath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)qzpathURL, &_qzbgsnd);
    
    NSString *rtpath = [[NSBundle mainBundle] pathForResource:mainparam.rightsound ofType:@"wav"];
    NSURL *rtpathURL = [NSURL fileURLWithPath:rtpath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)rtpathURL, &_rightsnd);
    
    NSString *wrngpath = [[NSBundle mainBundle] pathForResource:mainparam.wrongsound ofType:@"wav"];
    NSURL *wrngpathURL = [NSURL fileURLWithPath:wrngpath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)wrngpathURL, &_wrongsnd);
    
    self.userscore = 0;
    self.currentqnum = 0;
    
    // get an array of unique random numbers to be used to pulls questions at random
    self.qindexes = [DDUtils randomIntegerArrayFrom:0 To:([self.questions count]-1) Count:self.QUIZCOUNT];
    [self showQuestions];
}
/*
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToPlay) name:@"pushToPlay" object:nil];
}

*/
- (void)handleBack:(id)sender
{
    [self pauseTimer];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Quit?" message:@"Do you want to quit the quiz?" delegate:self cancelButtonTitle:@"Nope" otherButtonTitles: @"Yes",nil];
    
    [alert setTag:QUITQUIZ];
    [alert show];
}

/*  This will be done in next release
- (void)handleSettings:(id)sender
{
    [self pauseTimer];
    DDSettingTblViewController* settingvc = [[DDSettingTblViewController alloc] init];
    settingvc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:settingvc animated:YES completion:nil];
}
*/

- (void)timerTick:(NSTimer *)timer
{
    if (self.timesec == 0)
    {
        [self.timer invalidate];
        self.timer = nil;
        self.timerlabel.text = [NSString stringWithFormat:@"00:%lu",(unsigned long)[self timesec]];
        [self timesUp];
    }
    else
    {
        if (self.soundon)
        {
            AudioServicesPlaySystemSound(_qzbgsnd);
        }
        self.timerlabel.text = [NSString stringWithFormat:@"00:%lu",(unsigned long)[self timesec]];
        self.timesec--;
    }
}

- (void)answerClicked:(UIButton*) sender
{
    [self.timer invalidate];
    self.timer = nil;
    AudioServicesRemoveSystemSoundCompletion(self.qzbgsnd);
    
    if (sender.tag == self.answernum)
    {
        [self rightAnswer];
    }
    else
    {
        [self wrongAnswer];
    }
}

- (void)rightAnswer
{
    if (self.soundon)
    {
        AudioServicesPlaySystemSound(_rightsnd);
    }
    
    // Update and show score
    self.userscore++;
    NSString* scorestr = [NSString stringWithFormat:@"Score: %lu",(unsigned long)self.userscore];
    self.scorelbl.text = scorestr;
    
    if (self.showansdetails)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"That's correct !" message:self.ansdetails delegate:self cancelButtonTitle:@"Cool" otherButtonTitles: nil];
        
        [alert setTag:RIGHTANS];
        [alert show];
    }
    else
    {
        [self showQuestions];
    }
}

- (void)wrongAnswer
{
    if (self.soundon)
    {
        AudioServicesPlaySystemSound(_wrongsnd);
    }
    
    if (self.showansdetails)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Think harder !" message:self.WRNGANSTXT delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    
        [alert setTag:WRONGANS];
        [alert show];
    }
    else
    {
        [self showQuestions];
    }
}

- (void)timesUp
{
    if (self.soundon)
    {
        AudioServicesPlaySystemSound(_wrongsnd);
    }
    
    if (self.showansdetails)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Time's Up !" message:@"Let's move on" delegate:self cancelButtonTitle:@"Hmm.." otherButtonTitles: nil];
    
        [alert setTag:TIMESUP];
        [alert show];
    }
    else
    {
        [self showQuestions];
    }
}

- (void) quizCompleted
{
    //clear all sounds
    [self cleanUp];
    [self performSegueWithIdentifier:@"showresult" sender:nil];
}

- (void) pauseTimer
{
    self.pausedtimesec = self.timesec;
    [self.timer invalidate];
    self.timer = nil;
    AudioServicesRemoveSystemSoundCompletion(self.qzbgsnd);
}

- (void) unpausedTimer
{
    // Restart the timer
    self.timesec = self.pausedtimesec ;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showresult"])
    {
        DDResultViewController *resultVC = (DDResultViewController *)[segue destinationViewController];
        resultVC.score = self.userscore;
        resultVC.quizcount = self.QUIZCOUNT;
    }
}

- (void)showQuestions
{
    if (self.currentqnum < self.QUIZCOUNT)
    {
        // start the timer
        self.timesec = self.ANSTIME;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
        
        // Show count of questions
        NSString* qct = [NSString stringWithFormat:@"Q %u of %lu",(self.currentqnum+1),(unsigned long)self.QUIZCOUNT];
        self.qcount.text = qct;
        
        NSUInteger qindex = [[self.qindexes objectAtIndex:self.currentqnum] integerValue];
        
        NSDictionary* que = [self.questions objectAtIndex:qindex];
        
        self.quetxt.text = [que objectForKey:@"Question"];
        NSArray* optarr = [que objectForKey:@"Options"];
            
        for(int cnt=0;cnt< OPTCT;cnt++)
        {
            // Create 4 buttons using array and loop.
            UIButton *theButton= [[UIButton alloc] initWithFrame:CGRectMake(37,(170+(70*cnt)), 261, 64)];

            if (cnt < optarr.count)
            {
                [theButton setBackgroundImage:[UIImage imageNamed:self.btnbgimg] forState:UIControlStateNormal];
                
                //set their selector using add selector
                [theButton addTarget:self action:@selector(answerClicked:) forControlEvents:UIControlEventTouchUpInside];
                NSString *buttontext = [optarr objectAtIndex:cnt];
                [theButton setTitle:buttontext forState:UIControlStateNormal];
                theButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            }
            else
            {
                theButton.backgroundColor = [UIColor clearColor];
                [theButton setTitle:@" " forState:UIControlStateNormal];
            }
            
            theButton.tag = cnt;
                
            [self.view addSubview:theButton];
        }
            
        // Save tha answer key. It starts from 0.
        self.answernum = [[que objectForKey:@"Answer"] integerValue];
        self.ansdetails = [que objectForKey:@"Details"];
        
        self.currentqnum++;
    }
    else
    {
        // Quiz ended
        [self quizCompleted];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self.view window] == nil)
    {
        // Add code to preserve data stored in the views that might be
        // needed later.
        
        // Add code to clean up other strong references to the view in
        // the view hierarchy.
        self.view = nil;
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag)
    {
        case RIGHTANS:
            [self showQuestions];
            break;
            
        case WRONGANS:
            [self showQuestions];
            break;

        case TIMESUP:
            [self showQuestions];
            break;

        case QUITQUIZ:
            if (buttonIndex == 1)
            { // User presses Yes to Quit?
                self.userscore = 0;
                [self cleanUp];
                // pop to root view controller
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            { // User presses No to Quit?
                [self unpausedTimer];
            }
            break;
            
        default:
            break;
    }
}

- (void) cleanUp
{
    // we need to clean up timer
    [self.timer invalidate];
    self.timer = nil;
    
    //clear all sounds
    AudioServicesRemoveSystemSoundCompletion(self.rightsnd);
    AudioServicesDisposeSystemSoundID(self.rightsnd);
    
    AudioServicesRemoveSystemSoundCompletion(self.wrongsnd);
    AudioServicesDisposeSystemSoundID(self.wrongsnd);
    
    AudioServicesRemoveSystemSoundCompletion(self.qzbgsnd);
    AudioServicesDisposeSystemSoundID(self.qzbgsnd);
    
    // pop to root view controller
    //[self.navigationController popViewControllerAnimated:YES];
}


@end
