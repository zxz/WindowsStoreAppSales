//
//  RecordManager.h
//  Store
//
//  Created by 鄒 西中 on 2/7/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordManager : NSObject
{
    NSManagedObjectContext *moc;
}
+(RecordManager *)sharedInstance;
-(void)importRecords;
@property (strong,nonatomic) NSPersistentStoreCoordinator *psc;
@end
