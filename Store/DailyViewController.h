//
//  DailyViewController.h
//  Store
//
//  Created by XiZhong Zou on 2/9/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDNestedTableViewController.h"
#import "Record.h"
@interface DailyViewController : SDNestedTableViewController{
    NSMutableDictionary *appNameToDistinctCountryDict;
    NSMutableDictionary *appNameAndCountryToCountDict;
    NSDictionary *countryName;
}
@property (strong,nonatomic)NSDate *date;
@property (strong,nonatomic)NSArray *allApps;
@end
