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
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:mainparam.bgimg]];
    
//    self.navigationItem.title = mainparam.maintitle;
    
    UIImage *image = [UIImage imageNamed: mainparam.navimg];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics: UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    // Change headings as per score
    NSUInteger benchmark = self.quizcount * BENCHMARKFACTOR;
    
    if(self.score > benchmark)
    {
        NSString* playernm = @"Excellent score, ";
        self.namelbl.text = [playernm stringByAppendingString:mainparam.playername];
        
        if (self.score == self.quizcount)
        {
            // call gotfull score
        }
    }
    else
    {
        NSString* playernm = @"Nice Try, ";
        self.namelbl.text = [playernm stringByAppendingString:mainparam.playername];
    }
    
    self.titlelbl.text = @"Game Over!";
    self.scorelbl.text = [NSString stringWithFormat:@" %lu of %lu",(unsigned long)self.score,(unsigned long)self.quizcount];
    
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
