//
//  DailyViewController.m
//  Store
//
//  Created by XiZhong Zou on 2/9/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//

#import "DailyViewController.h"
#import "Query.h"
#import "Util.h"
@interface DailyViewController ()

@end

@implementation DailyViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.tabBarItem.image=[UIImage imageNamed:@"computer"];
        self.tabBarItem.title=@"Products";
    }
    return self;
}

-(void)reloadData{
    NSArray *apps=[Query allAppNameInDate:self.date];
    self.allApps =apps;
    appNameToDistinctCountryDict=[NSMutableDictionary dictionaryWithCapacity:0];
    appNameAndCountryToCountDict=[NSMutableDictionary dictionaryWithCapacity:0];
    countryName=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"country_names" ofType:@"plist"]];
    for(NSString *app in apps){
        NSArray *countrys=[Query countryWithAppName:app date:self.date];
        appNameAndCountryToCountDict[app] =[Query appCount:app country:nil date:self.date];
        for(NSString *country in countrys){
            // dictionary to store sales county by appNameCountryCode
            appNameAndCountryToCountDict[[NSString stringWithFormat:@"%@%@",app,country]]=[Query appCount:app country:country date:self.date];
        }
        //arrange country by count
        countrys =[countrys sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
            SaleCount *count1= appNameAndCountryToCountDict[[NSString stringWithFormat:@"%@%@",app,obj1]];
            SaleCount *count2= appNameAndCountryToCountDict[[NSString stringWithFormat:@"%@%@",app,obj2]];
            
            if ( [count1 realSaleCount] < [count2 realSaleCount] ) {
                return (NSComparisonResult)NSOrderedDescending;
            } else if ( [count1 realSaleCount]> [count2 realSaleCount] ) {
                return (NSComparisonResult)NSOrderedAscending;
            } else {
                return (NSComparisonResult)NSOrderedSame;
            }
            
        }];
        appNameToDistinctCountryDict[app]=countrys;
        
    }
    self.title=[Util dateToString:self.date];
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reloadData];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return self.allApps.count;
//}
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    SaleCount *count=appNameAndCountryToCountDict[self.allApps[section]];
//    return [NSString stringWithFormat:@"%@ %@",  self.allApps[section],count.description];
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [appNameToDistinctCountryDict[self.allApps[section]] count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell;// = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    if (cell==nil) {
//        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
//    }
//    NSString *country=[appNameToDistinctCountryDict[self.allApps[indexPath.section]]objectAtIndex:indexPath.row];
//    cell.textLabel.text=countryName[country];
//    SaleCount *saleCount=appNameAndCountryToCountDict[[NSString stringWithFormat:@"%@%@",self.allApps[indexPath.section],country]];
//    cell.detailTextLabel.text=saleCount.description;
//    return cell;
//}
//
//#pragma mark - Table view delegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    SaleCount *count=[Query appCount:nil country:nil date:self.date];
    return count.description;
}
#pragma mark - Nested Tables methods

- (NSInteger)mainTable:(UITableView *)mainTable numberOfItemsInSection:(NSInteger)section
{
    return self.allApps.count;

}

- (NSInteger)mainTable:(UITableView *)mainTable numberOfSubItemsforItem:(SDGroupCell *)item atIndexPath:(NSIndexPath *)indexPath
{
    return [appNameToDistinctCountryDict[self.allApps[indexPath.row]] count];

}

- (SDGroupCell *)mainTable:(UITableView *)mainTable setItem:(SDGroupCell *)item forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    item.itemText.text = [NSString stringWithFormat:@"My Main Item %u", indexPath.row +1];
    SaleCount *count=appNameAndCountryToCountDict[self.allApps[indexPath.row]];
     item.itemText.text =[NSString stringWithFormat:@"%@ %@",  self.allApps[indexPath.row],count.description];

    return item;
}

- (SDSubCell *)item:(SDGroupCell *)item setSubItem:(SDSubCell *)subItem forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *country=[appNameToDistinctCountryDict[self.allApps[item.cellIndexPath.row]]objectAtIndex:indexPath.row];
    if (countryName[country]) {
        subItem.itemText.text =countryName[country];
    }else{
        subItem.itemText.text=country;
    }

        SaleCount *saleCount=appNameAndCountryToCountDict[[NSString stringWithFormat:@"%@%@",self.allApps[item.cellIndexPath.row],country]];
       subItem.detailText.text=saleCount.description;

//    subItem.itemText.text = [NSString stringWithFormat:@"My Sub Item %u", indexPath.row +1];
    return subItem;
}

- (void) mainTable:(UITableView *)mainTable itemDidChange:(SDGroupCell *)item
{
    SelectableCellState state = item.selectableCellState;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:item];
    switch (state) {
        case Checked:
            NSLog(@"Changed Item at indexPath:%@ to state \"Checked\"", indexPath);
            break;
        case Unchecked:
            NSLog(@"Changed Item at indexPath:%@ to state \"Unchecked\"", indexPath);
            break;
        case Halfchecked:
            NSLog(@"Changed Item at indexPath:%@ to state \"Halfchecked\"", indexPath);
            break;
        default:
            break;
    }
}

- (void) item:(SDGroupCell *)item subItemDidChange:(SDSelectableCell *)subItem
{
    SelectableCellState state = subItem.selectableCellState;
    NSIndexPath *indexPath = [item.subTable indexPathForCell:subItem];
    switch (state) {
        case Checked:
            NSLog(@"Changed Sub Item at indexPath:%@ to state \"Checked\"", indexPath);
            break;
        case Unchecked:
            NSLog(@"Changed Sub Item at indexPath:%@ to state \"Unchecked\"", indexPath);
            break;
        default:
            break;
    }
}

- (void)expandingItem:(SDGroupCell *)item withIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Expanded Item at indexPath: %@", indexPath);
}

- (void)collapsingItem:(SDGroupCell *)item withIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Collapsed Item at indexPath: %@", indexPath);
}

@end
