//
//  DDSettingTblViewController.m
//  DinoDoc
//
//  Created by Swapnil Takalkar on 3/13/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import "DDSettingTblViewController.h"
#import "DDMainParam.h" 

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
    self.soundon = mainparam.soundon;
    self.showansdetails = mainparam.showansdetails;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        // Cell is prototyped in Storyboard, it won't be initialized here
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    UISwitch * ddswitch = [[UISwitch alloc] init];
    ddswitch.tag = indexPath.row;

    
    [ddswitch addTarget:self action:@selector(settingChanged:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = ddswitch;
    
    switch (indexPath.row)
    {
        case 0:
            [cell.textLabel setText:@"Sound"];
            [cell.detailTextLabel setText:@"Sound On/Off"];
            [ddswitch setOn:self.soundon];
            break;
            
        case 1:
            [cell.textLabel setText:@"Answer Details"];
            [cell.detailTextLabel setText:@"Show Answer details"];
            [ddswitch setOn:self.showansdetails];
            break;

        case 2:
            cell.textLabel.text = @"Volume";
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
        if (sender.tag == 0)
        {
            // This means volume changed
            self.soundon = TRUE;
            [mainparam setSoundon:self.soundon];
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
        if (sender.tag == 0)
        {
            // This means volume changed
            self.soundon = FALSE;
            [mainparam setSoundon:self.soundon];            
        }
        else
        {
            self.showansdetails = FALSE;
            [mainparam setShowansdetails:self.showansdetails];
        }
    }
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
