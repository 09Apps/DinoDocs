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
	// Do any additional setup after loading the view.
    
    DDMainParam* mainparam = [DDMainParam sharedInstance];
    
    // Change headings as per score
    NSUInteger benchmark = self.quizcount * BENCHMARKFACTOR;
    
    if(self.score > benchmark)
    {
        NSString* playernm = @"Excellent score ";
        self.namelbl.text = [playernm stringByAppendingString:mainparam.playername];
    }
    else
    {
        NSString* playernm = @"Nice Try ";
        self.namelbl.text = [playernm stringByAppendingString:mainparam.playername];
    }
    
    self.titlelbl.text = mainparam.maintitle;
    self.scorelbl.text = [NSString stringWithFormat:@" %d of %d",self.score,self.quizcount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playAgain:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
