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
#import <AudioToolbox/AudioToolbox.h>

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
	// Do any additional setup after loading the view.
    
    // The name of the plist file with questions and answers for each option must match
    // with the button title
    NSString* plistPath = [DDUtils getPlistPath:self.optname];
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
//    self.currentqnum = 0;
    
    // convert static property list into dictionary object
    NSDictionary *dict = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    
    if (!dict)
    {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    self.questions = [dict objectForKey:@"QArr"];
    
    [self showQuestions];
}

- (void)buttonClicked:(UIButton*) sender
{
    if (sender.tag == self.answernum)
    {
        [self rightAnswer];
    }
    else
    {
        [self wrongAnswer];
    }
    
    [self showQuestions];
}

- (void)rightAnswer
{
    SystemSoundID _rightsound;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"right_answer" ofType:@"wav"];
    NSURL *pathURL = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)pathURL, &_rightsound);
/*    AudioServicesAddSystemSoundCompletion(_rightsound, NULL, NULL, <#AudioServicesSystemSoundCompletionProc inCompletionRoutine#>, <#void *inClientData#>) */
    AudioServicesPlaySystemSound(_rightsound);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Awesome !" message:self.ansdetails delegate:self cancelButtonTitle:@"Cool" otherButtonTitles: nil];
    
    [alert show];
}

- (void)wrongAnswer
{
    SystemSoundID _wrongsound;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"wrong_answer" ofType:@"wav"];
    NSURL *pathURL = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)pathURL, &_wrongsound);
    AudioServicesPlaySystemSound(_wrongsound);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Think harder !" message:@"Remember, An incorrect answer makes the dinosaurs really sad" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    
    [alert show];
    
}

- (void) soundCompleted
{
    [self showQuestions];
}

- (void)showQuestions
{
    // Start again from first if user has completed the quiz.
    if (self.currentqnum == MAXNUM)
    {
        self.currentqnum = 0;
    }
    
    for (int quect=self.currentqnum; quect < MAXNUM; quect++)
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
                [theButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                
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
}



@end
