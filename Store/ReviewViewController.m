//
//  ReviewViewController.m
//  Store
//
//  Created by 鄒 西中 on 2/27/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//

#import "ReviewViewController.h"
#import "ReviewManager.h"
#import "DetailCommentViewController.h"
@interface ReviewViewController ()

@end

@implementation ReviewViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.tabBarItem.image=[UIImage imageNamed:@"comment"];
        self.tabBarItem.title=@"Reviews";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
    apps=[[ReviewManager sharedManager]allApplicationInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}
-(void)refresh:(id)sender{
    for(id app in apps){
    [[ReviewManager sharedManager]fetchReviews:app];
    }
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Done" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [apps count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell ;

    cell=[tableView dequeueReusableHeaderFooterViewWithIdentifier:CellIdentifier];
    if (cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.detailTextLabel.font=[UIFont fontWithName:@"Arial" size:13];
        cell.textLabel.numberOfLines=0;
    }
    cell.textLabel.text= [apps[indexPath.row] objectForKey:kAppName];
    // Configure the cell...
    
    return cell;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCommentViewController *detail=[[DetailCommentViewController alloc]initWithStyle:UITableViewStyleGrouped];
    detail.appid= [apps[indexPath.row] objectForKey:kAppId];
    [self.navigationController pushViewController:detail animated:YES];
}

@end
