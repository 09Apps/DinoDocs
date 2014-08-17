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
    
    // Change headings as per score
    NSUInteger benchmark = self.quizcount * BENCHMARKFACTOR;

    self.titlelbl.text = @"Game Over!";
    self.scorelbl.text = [NSString stringWithFormat:@" %lu of %lu",(unsigned long)self.score,(unsigned long)self.quizcount];
    
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
    
    NSString* bdgimg = [DDBadgesViewController checkBadgeForQuiz:self.quiztype
                                                       WithScore:self.score];

    
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
