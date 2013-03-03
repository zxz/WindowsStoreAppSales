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
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}
-(void)refresh:(id)sender{
    NSArray *apps_=[[ReviewManager sharedManager]allApplicationInfo];
    
    for(id app in apps_){
    [[ReviewManager sharedManager]fetchReviews:app];
    }
    NSString *message;
    if ([apps count]==0 ) {
        message=@"No App Found";
    }else{
        message=@"Done";
    }
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:message message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
    cell.textLabel.text= apps[indexPath.row] ;
    // Configure the cell...
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCommentViewController *detail=[[DetailCommentViewController alloc]initWithStyle:UITableViewStyleGrouped];
    detail.appid= apps[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}

@end
