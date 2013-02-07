//
//  SalesViewController.h
//  Store
//
//  Created by 鄒 西中 on 2/7/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Record.h"

@interface SalesViewController : UITableViewController<NSFetchedResultsControllerDelegate>
{
    
}
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;


@end
