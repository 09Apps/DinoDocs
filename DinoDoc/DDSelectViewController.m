//
//  DDSelectViewController.m
//  DinoDoc
//
//  Created by Swapnil Takalkar on 1/31/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import "DDSelectViewController.h"
#import "DDDefines.h"
#import "DDUtils.h"

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
	// Overwritting back button, so I can clean up timer and other objects
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem = backbutton;
    
    // The name of the plist file with questions and answers for each option must match
    // with the button title
    NSString* plistPath = [DDUtils getPlistPath:self.optname];
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    
    // convert static property list into dictionary object
    NSDictionary *dict = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    
    if (!dict)
    {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    self.questions = [dict objectForKey:@"QArr"];
    
    self.WRNGANSTXT = [dict objectForKey:@"WrongAnsTxt"];
    self.QUIZCOUNT = [[dict objectForKey:@"Quizcount"] integerValue];
    self.ANSTIME = [[dict objectForKey:@"AnsTime"] integerValue];
    
    // Keep the sounds ready, but don't play them
    
    NSString *rtpath = [[NSBundle mainBundle] pathForResource:self.rightsoundfile ofType:@"wav"];
    NSURL *rtpathURL = [NSURL fileURLWithPath:rtpath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)rtpathURL, &_rightsound);
    
    NSString *wrngpath = [[NSBundle mainBundle] pathForResource:self.wrongsoundfile ofType:@"wav"];
    NSURL *wrngpathURL = [NSURL fileURLWithPath:wrngpath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)wrngpathURL, &_wrongsound);
    
    [self showQuestions];
}

- (void)handleBack:(id)sender
{
    [self.timer invalidate];
    self.timer = nil;
    // pop to root view controller
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)timerTick:(NSTimer *)timer
{
    if (self.timesec == 0)
    {
        [self.timer invalidate];
        self.timer = nil;
        self.timerlabel.text = [NSString stringWithFormat:@"00:%d",[self timesec]];
        [self timesUp];
    }
    else
    {
        self.timesec--;
        self.timerlabel.text = [NSString stringWithFormat:@"00:%d",[self timesec]];
    }
}

- (void)answerClicked:(UIButton*) sender
{
    [self.timer invalidate];
    self.timer = nil;
    
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
    NSString *rtpath = [[NSBundle mainBundle] pathForResource:@"right_answer" ofType:@"wav"];
    NSURL *rtpathURL = [NSURL fileURLWithPath:rtpath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)rtpathURL, &_rightsound);
    AudioServicesPlaySystemSound(_rightsound);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Awesome !" message:self.ansdetails delegate:self cancelButtonTitle:@"Cool" otherButtonTitles: nil];
    
    [alert setTag:RIGHTANS];
    [alert show];
}

- (void)wrongAnswer
{
    NSString *wrngpath = [[NSBundle mainBundle] pathForResource:@"wrong_answer" ofType:@"wav"];
    NSURL *wrngpathURL = [NSURL fileURLWithPath:wrngpath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)wrngpathURL, &_wrongsound);
    AudioServicesPlaySystemSound(_wrongsound);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Think harder !" message:self.WRNGANSTXT delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    
    [alert setTag:WRONGANS];
    [alert show];
}

- (void)timesUp
{
    NSString *wrngpath = [[NSBundle mainBundle] pathForResource:@"wrong_answer" ofType:@"wav"];
    NSURL *wrngpathURL = [NSURL fileURLWithPath:wrngpath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)wrngpathURL, &_wrongsound);
    AudioServicesPlaySystemSound(_wrongsound);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Time's Up !" message:@"Let's move on" delegate:self cancelButtonTitle:@"Hmm.." otherButtonTitles: nil];
    
    [alert setTag:TIMESUP];
    [alert show];
    
}

- (void)showQuestions
{
    // start the timer
    self.timesec = 30;//self.ANSTIME;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    
    // Start again from first if user has completed the quiz.
    if (self.currentqnum == self.QUIZCOUNT)
    {
        self.currentqnum = 0;
    }
    
    for (int quect=self.currentqnum; quect < self.QUIZCOUNT; quect++)
    {
        NSDictionary* que = [self.questions objectAtIndex:quect];
        BOOL userknows = [[que objectForKey:@"UserGaveAns"] boolValue];
        
        if ( userknows == NO )
        {
            self.quetxt.text = [que objectForKey:@"Question"];
            
            NSArray* optarr = [que objectForKey:@"Options"];
            
            for(int cnt=0;cnt<4;cnt++)
            {
                // Create 4 buttons using array and loop.
                UIButton *theButton= [[UIButton alloc] initWithFrame:CGRectMake(20,(160+(65*cnt)), 275, 60)];
                
                theButton.backgroundColor = [UIColor grayColor];
                theButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                theButton.tag = cnt;
                
                NSString *buttontext = [optarr objectAtIndex:cnt];
                
                [theButton setTitle:buttontext forState:UIControlStateNormal];
                
                //set their selector using add selector
                [theButton addTarget:self action:@selector(answerClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.view addSubview:theButton];
            }
            
            // Save tha answer key. It starts from 0.
            self.answernum = [[que objectForKey:@"Answer"] integerValue];
            self.ansdetails = [que objectForKey:@"Details"];
            self.currentqnum++;
            
            break;
        }
        else
        {
            self.currentqnum++;
        }
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
    [self showQuestions];
}

@end
