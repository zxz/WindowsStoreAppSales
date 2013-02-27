//
//  SalesViewController.m
//  Store
//
//  Created by 鄒 西中 on 2/7/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//

#import "SalesViewController.h"

#import "DailyViewController.h"
#import "Query.h"
#import "Util.h"
#import "CurrencyViewController.h"
@interface SalesViewController ()

@end

@implementation SalesViewController
@synthesize fetchedResultsController;
@synthesize managedObjectContext;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.tabBarItem.image=[UIImage imageNamed:@"sale"];
        self.tabBarItem.title =@"Daily Sales";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];

    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(settingClick)];
    calendar =[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    dateToNumberDict=[NSMutableDictionary dictionaryWithCapacity:0];
    months=[NSMutableArray arrayWithCapacity:0];
    monthToDayDict=[[NSMutableDictionary alloc]initWithCapacity:0];
    [RecordManager sharedInstance].delegate =self;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    [refreshControl addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [self reloadData];

}

-(void)fetchData{
    [self reloadData];
    [self.refreshControl endRefreshing];

}
-(void)settingClick{
    CurrencyViewController *picker=[[CurrencyViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [self presentModalViewController:picker animated:YES];
}

-(void)reloadData
{
    NSFetchRequest *dateRequest = [Record MR_requestAllWithPredicate:nil inContext:[NSManagedObjectContext MR_defaultContext]];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];

    [dateRequest setSortDescriptors:@[sortDescriptor2]];
     [dateRequest setResultType:NSDictionaryResultType];
    [dateRequest setReturnsDistinctResults:YES];
    [dateRequest setPropertiesToFetch:@[@"date"]];//    ...
    
    NSArray *dates = [Record MR_executeFetchRequest:dateRequest inContext:[NSManagedObjectContext MR_defaultContext]];
    dates=[Query arrayDictionaryToArray:dates WithKey:@"date"];
    for(NSDate *date in dates){
        [self differentMonth:date];
    }
    [self reRangeAllDateArray];
//  allcount= [Query appCount:nil country:nil date:nil];
    [self.tableView reloadData];
    
}
-(void)reRangeAllDateArray{
    NSArray *keys=[monthToDayDict allKeys];
    for(id key in keys ){
        monthToDayDict[key]=[[monthToDayDict[key] sortedArrayUsingComparator:^NSComparisonResult(NSDate * obj1, NSDate * obj2) {
            return [obj1 compare:obj2]*-1;
        }
] mutableCopy];
    }
}
-(void)differentMonth:(NSDate *)date{
    NSDateComponents *firstcomponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSInteger month1 = [firstcomponents month];
    NSInteger year1 = [firstcomponents year];
    
    NSDateComponents *components=[[NSDateComponents alloc]init];
    [components setMonth:month1];
    [components setYear:year1];
    [components setDay:1];
  NSDate *mdate= [calendar dateFromComponents:components];
   if(![months containsObject:mdate])
   {
       [months addObject:mdate];
       monthToDayDict[mdate]=[NSMutableArray arrayWithCapacity:0];
   }
    if(![monthToDayDict[mdate] containsObject:date]){
    [monthToDayDict[mdate] addObject:date];
    }
}

-(void)refresh:(id)sender{
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
	hud.labelText = @"Loading";
	
	dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		// Do a taks in the background
		[self loadData];
		// Hide the HUD in the main tread
		dispatch_async(dispatch_get_main_queue(), ^{
			[MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
		});
	});

}

-(void)loadData{
        [[RecordManager sharedInstance]importRecords];
    [[RecordManager sharedInstance]refreshData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)table titleForHeaderInSection:(NSInteger)section {
//    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
//        return [NSString stringWithFormat:NSLocalizedString(@"%@  %d sale",nil), [sectionInfo name], [sectionInfo numberOfObjects]];
    
    NSDate *datefrom=months[section];
    NSDate *dateTo;
    if (section==0) {
        dateTo=[[NSDate alloc]initWithTimeInterval:3600*24*30 sinceDate:datefrom];
    }else{
        dateTo=months[section-1];
    }
    
   SaleCount *sale=[Query appCount:nil country:nil date:@[datefrom,dateTo]];
    return [NSString stringWithFormat: @"%@ %@",[Util dateToString: months[section]], sale.description];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    NSLog(NSString *format, ...)
   // return [[self.fetchedResultsController sections]count];
    return months.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
//    return [sectionInfo numberOfObjects];
    NSArray *dates=[monthToDayDict objectForKey:months[section]];
    return dates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell ;
    cell=[tableView dequeueReusableHeaderFooterViewWithIdentifier:CellIdentifier];
    if (cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.detailTextLabel.font=[UIFont fontWithName:@"Arial" size:13];
        cell.textLabel.numberOfLines=0;
    }
    NSArray *dates=[monthToDayDict objectForKey:months[indexPath.section]];
    NSDate *date=dates[indexPath.row];
//    Record *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if (!dateToNumberDict[date]) {
       dateToNumberDict[date]= [Query appCount:nil country:nil date:date];
    }
    
    cell.textLabel.text= [Util dateToString:date];
    SaleCount *sale=dateToNumberDict[date];
    cell.detailTextLabel.text=sale.description;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DailyViewController *detail=[[DailyViewController alloc]initWithStyle:UITableViewStyleGrouped];
    NSArray *dates=[monthToDayDict objectForKey:months[indexPath.section]];
    NSDate *date=dates[indexPath.row];

    detail.date=date;
    
    [self.navigationController pushViewController:detail animated:YES];
}

@end
