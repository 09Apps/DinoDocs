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
	// Overwritting back button, so I can clean up timer and other objects
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem = backbutton;
    
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
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    self.questions = [dict objectForKey:@"QArr"];
    
    self.WRNGANSTXT = [dict objectForKey:@"WrongAnsTxt"];
    self.QUIZCOUNT = [[dict objectForKey:@"Quizcount"] integerValue];
    
    // get the mainparam singleton
    DDMainParam* mainparam = [DDMainParam sharedInstance];
    self.ANSTIME = mainparam.anstime;
    
    // Keep the sounds ready, but don't play them
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

- (void)handleBack:(id)sender
{
    // we need to clean up timer on back , so wrote custom back button function
    [self.timer invalidate];
    self.timer = nil;
    self.userscore = 0;
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
    AudioServicesPlaySystemSound(_rightsnd);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"That's correct !" message:self.ansdetails delegate:self cancelButtonTitle:@"Cool" otherButtonTitles: nil];

    // Update and show score
    self.userscore++;
    NSString* scorestr = [NSString stringWithFormat:@"Score: %d",self.userscore];
    self.scorelbl.text = scorestr;
    
    [alert setTag:RIGHTANS];
    [alert show];
}

- (void)wrongAnswer
{
    AudioServicesPlaySystemSound(_wrongsnd);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Think harder !" message:self.WRNGANSTXT delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    
    [alert setTag:WRONGANS];
    [alert show];
}

- (void)timesUp
{
    AudioServicesPlaySystemSound(_wrongsnd);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Time's Up !" message:@"Let's move on" delegate:self cancelButtonTitle:@"Hmm.." otherButtonTitles: nil];
    
    [alert setTag:TIMESUP];
    [alert show];
}


- (void) quizCompleted
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self performSegueWithIdentifier:@"showresult" sender:nil];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showresult"])
    {
        DDResultViewController *resultVC = (DDResultViewController *)[segue destinationViewController];
        resultVC.score = self.userscore;
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
        NSString* qct = [NSString stringWithFormat:@"Q %d of %d",(self.currentqnum+1),self.QUIZCOUNT];
        self.qcount.text = qct;
        
        NSUInteger qindex = [[self.qindexes objectAtIndex:self.currentqnum] integerValue];
        
        NSDictionary* que = [self.questions objectAtIndex:qindex];
        
        self.quetxt.text = [que objectForKey:@"Question"];
        NSArray* optarr = [que objectForKey:@"Options"];
            
        for(int cnt=0;cnt< optarr.count;cnt++)
        {
            // Create 4 buttons using array and loop.
            UIButton *theButton= [[UIButton alloc] initWithFrame:CGRectMake(20,(165+(65*cnt)), 275, 60)];
                
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
            
        default:
            break;
    }
}


@end
