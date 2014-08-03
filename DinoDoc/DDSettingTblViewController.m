//
//  DDSettingTblViewController.m
//  DinoDoc
//
//  Created by Swapnil Takalkar on 3/13/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import "DDSettingTblViewController.h"
#import "DDMainParam.h" 
#import "DDDefines.h"
#import "DDUtils.h"
#import "DDIAPUse.h"

@interface DDSettingTblViewController () 

@end

@implementation DDSettingTblViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get the singleton instance of main param
    DDMainParam* mainparam = [DDMainParam sharedInstance];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:mainparam.bgimg]];
    
    self.soundon = mainparam.soundon;
    self.showansdetails = mainparam.showansdetails;
    self.playername = mainparam.playername;
    self.restored = NO;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseFailed:) name:IAPHelperFailedPurchasedNotification object:nil];
}


- (void)purchaseFailed:(NSNotification *)notification
{
    if ([self.spinner isAnimating])
    {
        [self.spinner stopAnimating];
    }
}

- (void)productPurchased:(NSNotification *)notification
{
    NSString * productIdentifier = notification.object;

    DDMainParam* mainparam = [DDMainParam sharedInstance];
    NSUInteger optionscount = [mainparam.options count];
             
    for (int i=0; i<optionscount; i++)
    {
        NSDictionary* dict = [mainparam.options objectAtIndex:i];
        NSString* plistprodid = [dict objectForKey:@"productid"];
        
        if ([plistprodid compare:productIdentifier] == NSOrderedSame)
        {
            [dict setValue:[DDUtils stringFromBool:YES] forKey:@"purchased"];
            break;
        }
    }
         
    if ([self.spinner isAnimating])
    {
        [self.spinner stopAnimating];
    }
    self.restored = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewDidDisappear:(BOOL)animated
{
    if (self.restored)
    {
        [self.delegate modalDialogClosed:self.parentViewController];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return SETOPTCT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    UISwitch* ddswitch = [[UISwitch alloc] init];
    UIButton* ddbuttons = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    ddbuttons.frame = CGRectMake(0, 0, 260, 40);
    
    UITextField* txtfld = [[UITextField alloc] initWithFrame:CGRectMake(150, 0, 150, 40)];

    switch (indexPath.row)
    {
        case 0:
            CellIdentifier = @"Cell0";  //blank cell
            break;
            
        case 1:
            CellIdentifier = @"Cell1";
            break;
            
        case 2:
            CellIdentifier = @"Cell2";
            break;
            
        case 3:
            CellIdentifier = @"Cell2";
            break;
            
        case 4:
            CellIdentifier = @"Cell3";
            break;
            
        case 5:
            CellIdentifier = @"Cell3";
            break;
            
        default:
            CellIdentifier = @"Cell0";
            break;
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        // Cell is prototyped in Storyboard, it won't be initialized here
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;
    
    switch (indexPath.row)
    {
        case 1:
            [cell.textLabel setText:@"   Enter Name : "];
            txtfld.text= self.playername;
            txtfld.delegate = self;
            txtfld.tag = indexPath.row;
            [txtfld setBorderStyle:UITextBorderStyleLine];
            cell.accessoryView = txtfld;
            break;
            
        case 2:
            [cell.textLabel setText:@"   Sound"];
            [cell.detailTextLabel setText:@"    Sound On/Off"];
            ddswitch.tag = indexPath.row;
            [ddswitch addTarget:self action:@selector(settingChanged:) forControlEvents:UIControlEventValueChanged];
            [ddswitch setOn:self.soundon];
            cell.accessoryView = ddswitch;
            break;
            
        case 3:
            [cell.textLabel setText:@"   Answer Details"];
            [cell.detailTextLabel setText:@"    Show Answer details"];
            ddswitch.tag = indexPath.row;
            [ddswitch addTarget:self action:@selector(settingChanged:) forControlEvents:UIControlEventValueChanged];
            [ddswitch setOn:self.showansdetails];
            cell.accessoryView = ddswitch;
            break;

        case 4:
            [ddbuttons setTitle:@"   Remove Ads" forState:UIControlStateNormal];
            [ddbuttons addTarget:self action:@selector(removeAds) forControlEvents:UIControlEventTouchUpInside];
            ddbuttons.tag = indexPath.row;
            [cell addSubview:ddbuttons];
            break;

        case 5:
            [ddbuttons setTitle:@"   Restore Purchases" forState:UIControlStateNormal];
            [ddbuttons addTarget:self action:@selector(restorePurchases:) forControlEvents:UIControlEventTouchUpInside];
            ddbuttons.tag = indexPath.row;
            [cell addSubview:ddbuttons];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)settingChanged:(UISwitch*)sender
{
    DDMainParam* mainparam = [DDMainParam sharedInstance];
    
    if([sender isOn])
    {
        // This means switch turned ON
        if (sender.tag == 2)
        {
            // This means sound made ON
            self.soundon = TRUE;
            [mainparam setSoundon:self.soundon];
            [self.bgplayer play];
        }
        else
        {
            self.showansdetails = TRUE;
            [mainparam setShowansdetails:self.showansdetails];
        }
    }
    else
    {
        // Execute any code when the switch is OFF
        if (sender.tag == 2)
        {
            // This means sound muted
            self.soundon = FALSE;
            [mainparam setSoundon:self.soundon];
            
            // Stop the background music now.
            [self.bgplayer stop];
        }
        else
        {
            self.showansdetails = FALSE;
            [mainparam setShowansdetails:self.showansdetails];
        }
    }
    
    [mainparam setParamchanged:TRUE];
}

- (IBAction)restorePurchases:(UIButton *)sender
{
    // Initiate activity indicator
    self.spinner = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.hidesWhenStopped = YES;
    self.spinner.center = self.view.center;
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
    
    [[DDIAPUse sharedInstance] restoreCompletedTransactions];
}

- (void)removeAds
{
    NSLog(@"Remove Ads");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.playername = textField.text;
    DDMainParam* mainparam = [DDMainParam sharedInstance];
    [mainparam setPlayername:self.playername];
    [mainparam setParamchanged:TRUE];
}

- (IBAction)donePressed:(UIButton *)sender
{
    DDMainParam* mainparam = [DDMainParam sharedInstance];
    
    if ([mainparam paramchanged])
    {
        [mainparam updateMainParam];
    }

    [self dismissViewControllerAnimated:YES completion:^{ }];    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
