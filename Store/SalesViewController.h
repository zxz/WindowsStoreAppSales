//
//  SalesViewController.h
//  Store
//
//  Created by 鄒 西中 on 2/7/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Record.h"
#import "SaleCount.h"
#import "MBProgressHUD.h"
#import "RecordManager.h"
@interface SalesViewController : UITableViewController<NSFetchedResultsControllerDelegate,MBProgressHUDDelegate,RecordMangerDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
{
    MBProgressHUD *HUD;
    NSMutableDictionary *dateToNumberDict;
    UIView *headerView;
    NSCalendar *calendar;
    NSMutableArray *months;
    NSMutableDictionary *monthToDayDict;
}
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
-(void)reloadData;

@end
