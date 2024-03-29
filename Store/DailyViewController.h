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
#import "RecordManager.h"
@interface DailyViewController : SDNestedTableViewController<RecordMangerDelegate>{
    NSMutableDictionary *appNameToDistinctCountryDict;
    NSMutableDictionary *appNameAndCountryToCountDict;
    NSDictionary *countryName;
}
@property (strong,nonatomic)id date;//this may be nsarray or nsdate
@property (strong,nonatomic)NSArray *allApps;
@end
