//
//  DDPlayViewController.m
//  DinoDoc
//
//  Created by Swapnil Takalkar on 1/28/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import "DDPlayViewController.h"
#import "DDSelectViewController.h"

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

- (IBAction)button1touched:(UIButton *)senderbutton
{
    [self performSegueWithIdentifier:@"selseg" sender:senderbutton];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Just to make sure we have the right segue
    if ([segue.identifier isEqualToString:@"selseg"])
    {
        DDSelectViewController *selVC = (DDSelectViewController*)[segue destinationViewController];
        
        selVC.optname = [(UIButton*)sender currentTitle];

        // Stop the backgrounf music now.

    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    
    NSUInteger optionscount = [self.options count];
    
    for (int i=0; i<optionscount; i++)
    {
        NSDictionary* dict = [self.options objectAtIndex:i];
        [self.button1 setTitle:[dict objectForKey:@"name"] forState:UIControlStateNormal];
        break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
