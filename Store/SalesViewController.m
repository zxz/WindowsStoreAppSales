//
//  SalesViewController.m
//  Store
//
//  Created by 鄒 西中 on 2/7/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//

#import "SalesViewController.h"
#import "RecordManager.h"
@interface SalesViewController ()

@end

@implementation SalesViewController
@synthesize fetchedResultsController;
@synthesize managedObjectContext;


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
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
//    [self reloadData];
    
//    [Record MR_truncateAll];
//    [self deleteAll];
    [self reloadData];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"country==%@ && appName==%@", @"US",@"Photo Locker"];
        
  //  int totalFat = [[Record MR_aggregateOperation:@"count:" onAttribute:@"country" withPredicate:predicate] intValue];
    NSNumber *count = [Record MR_numberOfEntities];
   
    NSNumber *count1 = [Record MR_numberOfEntitiesWithPredicate:predicate];

//NSNumber *count = [Record MR_countOfEntities];
    self.title= [NSString stringWithFormat:@"%@", count] ;
    
}
-(void)reloadData
{
//    NSError *error = nil;
//
//    if (![[self fetchedResultsController] performFetch:&error]) {
//		/*
//		 Replace this implementation with code to handle the error appropriately.
//		 
//		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
//		 */
//		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//		return;
//	}
//    //    NSError *error;
//    NSManagedObjectContext *addingManagedObjectContext = [self managedObjectContext];
//    if (![addingManagedObjectContext save:&error]) {
//        /*
//         Replace this implementation with code to handle the error appropriately.
//         
//         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//         */
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        return;
//    }
    
//    self.fetchedResultsController = [Record MR_fetchAllSortedBy:@"country"
//                      ascending:YES
//                  withPredicate:nil
//                        groupBy:@"appName"
//                       delegate:self
//                      inContext:[NSManagedObjectContext MR_contextForCurrentThread]];

    
    self.fetchedResultsController=[Record MR_fetchAllGroupedBy:@"appName" withPredicate:nil sortedBy:@"appName,country" ascending:NO delegate:self inContext:[NSManagedObjectContext MR_contextForCurrentThread]];

[self.tableView reloadData];

}
-(void)refresh:(id)sender{
    [[RecordManager sharedInstance]importRecords];
    [self reloadData];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)table titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
        return [NSString stringWithFormat:NSLocalizedString(@"%@  %d sale",nil), [sectionInfo name], [sectionInfo numberOfObjects]];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 33;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    NSLog(NSString *format, ...)
    return [[self.fetchedResultsController sections]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell ;
    cell=[tableView dequeueReusableHeaderFooterViewWithIdentifier:CellIdentifier];
    if (cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.numberOfLines=0;
    }
    Record *record = [self.fetchedResultsController objectAtIndexPath:indexPath];

    cell.textLabel.text=[NSString stringWithFormat:@"%@  %@ %@",record.appName,record.price,record.country];
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
//-(void)deleteAll{
//    NSError *error;
//    fetchedResultsController.delegate = nil;               // turn off delegate callbacks
//    for (Record *message in [fetchedResultsController fetchedObjects]) {
//        [managedObjectContext deleteObject:message];
//    }
//    if (![managedObjectContext save:&error]) {
//        // TODO: Handle the error appropriately.
//        NSLog(@"Delete message error %@, %@", error, [error userInfo]);
//    }
//    fetchedResultsController.delegate = self;              // reconnect after mass delete
//    if (![fetchedResultsController performFetch:&error]) { // resync controller
//        // TODO: Handle the error appropriately.
//        NSLog(@"fetchMessages error %@, %@", error, [error userInfo]);
//    }
//
//}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
#pragma mark -
#pragma mark Fetched results controller
//
//- (NSFetchedResultsController *)fetchedResultsController {
//    // Set up the fetched results controller if needed.
//    if (fetchedResultsController == nil) {
//        // Create the fetch request for the entity.
//        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//        // Edit the entity name as appropriate.
//        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:managedObjectContext];
//        [fetchRequest setEntity:entity];
//        
//        // Edit the sort key as appropriate.
//        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"appName" ascending:YES];
//        NSSortDescriptor *courntyDescriptor=[[NSSortDescriptor alloc]initWithKey:@"country.count" ascending:NO];
//        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor,courntyDescriptor, nil];
////        NSExpression * many = [NSExpression expressionForFunction:@"count:" arguments:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:@"country"]]];
////        
////        NSPredicate *pre=[[NSPredicate alloc]i]
//
//        [fetchRequest setSortDescriptors:sortDescriptors];
////        [fetchRequest setPropertiesToGroupBy:@[@"country"]];
//        [fetchRequest setResultType:NSManagedObjectResultType];
//
//        // Edit the section name key path and cache name if appropriate.
//        // nil for section name key path means "no sections".
//        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"appName" cacheName:@"Root"];
//        aFetchedResultsController.delegate = self;
//        self.fetchedResultsController = aFetchedResultsController;
//    }
//	return fetchedResultsController;
//}


/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	UITableView *tableView = self.tableView;
	
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
		//	[self configureCell:(BookCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
	}
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	[self.tableView endUpdates];
}

@end
