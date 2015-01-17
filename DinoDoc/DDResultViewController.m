//
//  DDResultViewController.m
//  DinoDoc
//
//  Created by Swapnil Takalkar on 3/8/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import "DDResultViewController.h"
#import "DDSelectViewController.h"
#import "DDMainParam.h"
#import "DDDefines.h"
#import "DDUtils.h"
#import "DDPlayViewController.h"
#import "DDBadgesViewController.h"
#import <Tapdaq/Tapdaq.h>

@interface DDResultViewController ()

@end

@implementation DDResultViewController

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
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:mainparam.resultbgimg]];
    
    self.adshow = mainparam.showads;
    
    UIImage *image = [UIImage imageNamed: mainparam.navimg];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics: UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    if (self.soundon)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"claps" ofType:@"wav"];
        NSURL *pathURL = [NSURL fileURLWithPath:path];
        
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:pathURL error:nil];
        [self.player play];
    }

    self.scorelbl.text = [NSString stringWithFormat:@" %lu of %lu",(unsigned long)self.score,(unsigned long)self.quizcount];

    // Change headings as per score
    NSUInteger benchmark = self.quizcount * BENCHMARKFACTOR;
    
    if(self.score > benchmark)
    {
        NSString* playernm = @"Excellent score, ";
        self.namelbl.text = [playernm stringByAppendingString:mainparam.playername];
    }
    else
    {
        NSString* playernm = @"Nice Try, ";
        self.namelbl.text = [playernm stringByAppendingString:mainparam.playername];
    }
    
    DDBadgesViewController* bdgVC = [[DDBadgesViewController alloc] init];
    NSString* bdgimg = [ bdgVC checkBadgeForQuiz:self.quiztype
                                        WithScore:self.score
                                        Outof:self.quizcount
                                        InTime:self.totaltime];
    
    if (bdgimg != nil)
    {
        self.bdglbl.text = @"You earned a badge!";
        UIImage *mybdg = [DDUtils imageWithImage:[UIImage imageNamed:bdgimg] scaledToSize:CGSizeMake(150, 150)];
        [self.bdgimglbl setBackgroundColor:[UIColor colorWithPatternImage:mybdg]];
    }
    else
    {
        self.bdglbl.text = @"Keep playing to earn badges & Titles!";
    }
    
    // Unlock quiz for free if badge count matches
    NSUInteger earnedbdgcnt = [bdgVC getEarnedBadgeCount];
    
    if (earnedbdgcnt == FREEQZSCORE1)
    {
        NSUInteger optionscount = [mainparam.options count];
            
        for (int i=0; i<optionscount; i++)
        {
            NSDictionary* dict = [mainparam.options objectAtIndex:i];
            NSString* titlestr = [dict objectForKey:@"title"];
                
            if ([titlestr compare:FREEQZ1] == NSOrderedSame)
            {
                if (! [[dict objectForKey:@"purchased"] boolValue] )
                {
                    [dict setValue:[DDUtils stringFromBool:YES] forKey:@"purchased"];
                    [mainparam updateMainParam];
                
                    NSString* unlockqz = [NSString stringWithFormat:@"You have unlocked %@ quiz for FREE! ", FREEQZ1];
                
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!" message:unlockqz delegate:self cancelButtonTitle:@"Cool" otherButtonTitles:nil];
                
                    [alert show];
                }
                break;
            }
        }
    }
    else if (earnedbdgcnt == FREEQZSCORE2)
    {
        NSUInteger optionscount = [mainparam.options count];
        
        for (int i=0; i<optionscount; i++)
        {
            NSDictionary* dict = [mainparam.options objectAtIndex:i];
            NSString* titlestr = [dict objectForKey:@"title"];
            
            if ([titlestr compare:FREEQZ2] == NSOrderedSame)
            {
                if (! [[dict objectForKey:@"purchased"] boolValue] )
                {
                    [dict setValue:[DDUtils stringFromBool:YES] forKey:@"purchased"];
                    [mainparam updateMainParam];
                    
                    NSString* unlockqz = [NSString stringWithFormat:@"You have unlocked %@ quiz for FREE! ", FREEQZ2];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!" message:unlockqz delegate:self cancelButtonTitle:@"Cool" otherButtonTitles:nil];
                    
                    [alert show];
                }
                break;
            }
        }
    }


    [self.navigationItem setHidesBackButton:YES animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    //DDMainParam* mainparam = [DDMainParam sharedInstance];
    //self.adshow = mainparam.showads;
    
    if (self.adshow)
    {
        [super viewWillAppear:animated];
        self.shared = [MBGADMasterVC singleton];
        [self.shared resetAdView:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playAgain:(UIButton *)senderbutton
{
    [self.player stop];
    if (self.adshow)
    {
        [[Tapdaq sharedSession] showInterstitial];
    }
    [self performSegueWithIdentifier:@"goplay" sender:senderbutton];
}
@end
