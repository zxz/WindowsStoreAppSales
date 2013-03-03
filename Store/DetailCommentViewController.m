//
//  DetailCommentViewController.m
//  Store
//
//  Created by 鄒 西中 on 2/27/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//

#import "DetailCommentViewController.h"
#import "ReviewManager.h"
#import "Util.h"
@interface DetailCommentViewController ()

@end

@implementation DetailCommentViewController

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
    
   reviews= [[ReviewManager sharedManager]reviewsOfApp:self.appid];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [reviews count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ReviewCell *cell ;
    cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil){
        cell=[[NSBundle mainBundle]loadNibNamed:@"ReviewCell" owner:self options:nil][0];
    }
    Comment *comment=[reviews objectAtIndex:indexPath.row];
    cell.titleLabel.text=  comment.title;
    cell.ratingLabel.text=comment.rating.description;
    cell.commentTextView.text=comment.review;
    cell.timeLabel.text=[Util dateDetailToString:comment.date];
    cell.authorLabel.text=comment.user;
    cell.countryLabel.text=comment.country;
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 185;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
