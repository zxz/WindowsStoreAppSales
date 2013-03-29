//
//  ReviewViewController.m
//  Store
//
//  Created by 鄒 西中 on 2/27/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//

#import "ReviewViewController.h"
#import "DetailCommentViewController.h"
#import "Query.h"
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
  apps= [Query allAppNameInReview];
    [ReviewManager sharedManager].delegate=self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}
-(void)refresh:(id)sender{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Sales" message:@"Do you want to load the reivews of your apps form all markets? It takes a long time to load." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.delegate=self;
    [alert show];

}
-(void)doRefreshAction{
    
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	// Set determinate mode
	HUD.mode = MBProgressHUDModeDeterminate;
	
	HUD.delegate = self;
	HUD.labelText = @"Loading";
	
	// myProgressTask uses the HUD instance to update progress
	[HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];

}
-(void)myProgressTask{
   [[ReviewManager sharedManager]allReviewsSync];
 
}
-(void)reviewProgress:(double)progress{
    HUD.progress = progress;

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
    cell.textLabel.text= apps[indexPath.row] ;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCommentViewController *detail=[[DetailCommentViewController alloc]initWithStyle:UITableViewStyleGrouped];
    detail.appid= apps[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}
#pragma mark-
#pragma mark alter view
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex==1) {
        [self doRefreshAction];
    }
}

@end
