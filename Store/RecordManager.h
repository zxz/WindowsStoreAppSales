//
//  RecordManager.h
//  Store
//
//  Created by 鄒 西中 on 2/7/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//
@protocol RecordMangerDelegate <NSObject>
@optional
-(void)reloadData;
-(void)recordProgress:(double) progress;
@end
#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface RecordManager : NSObject
{
    NSDate *tempDate;
}
@property (retain,nonatomic) id<RecordMangerDelegate>delegate;
+(RecordManager *)sharedInstance;
-(void)importRecords;
-(void)importFile:(NSString *)filePath shouldRemoveOld:(BOOL) shouldRemove;
-(void)refreshData;

@end
