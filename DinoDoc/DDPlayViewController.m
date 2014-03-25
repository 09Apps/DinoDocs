//
//  DDPlayViewController.m
//  DinoDoc
//
//  Created by Swapnil Takalkar on 1/28/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import "DDPlayViewController.h"
#import "DDSelectViewController.h"
#import "DDMainParam.h"    

@interface DDPlayViewController ()

@end

@implementation DDPlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)choicemade:(UIButton *)senderbutton
{
    [self performSegueWithIdentifier:@"selseg" sender:senderbutton];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Just to make sure we have the right segue
    if ([segue.identifier isEqualToString:@"selseg"])
    {
        DDSelectViewController *selVC = (DDSelectViewController*)[segue destinationViewController];
        
        // Pass on required parameters from main file
        selVC.opttitle = [(UIButton*)sender currentTitle];
        
        // Stop the background sound now.
        [self.bgplayer stop];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Get the singleton instance of main param
    DDMainParam* mainparam = [DDMainParam sharedInstance];
    
    NSUInteger optionscount = [mainparam.options count];
    
    for (int i=0; i<optionscount; i++)
    {
        NSDictionary* dict = [mainparam.options objectAtIndex:i];
        
        //create buttons for options at runtime
        UIButton *playchoice = [[UIButton alloc] initWithFrame:CGRectMake(25,(160+(40*i)), 150, 25)];
        playchoice.backgroundColor = [UIColor grayColor];
        
        [playchoice setTitle:[dict objectForKey:@"title"] forState:UIControlStateNormal];
        
        //set their selector using add selector
        [playchoice addTarget:self action:@selector(choicemade:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:playchoice];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
