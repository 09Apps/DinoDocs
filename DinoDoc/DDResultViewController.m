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
    
    UIImage *image = [UIImage imageNamed: mainparam.navimg];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics: UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

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
        self.bdglbl.text = @"Keep playing to earn badges!";
    }

    [self.navigationItem setHidesBackButton:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playAgain:(UIButton *)senderbutton
{
    [self performSegueWithIdentifier:@"goplay" sender:senderbutton];
    
/*    [self dismissViewControllerAnimated:YES completion:^{}];
 */
}
@end
