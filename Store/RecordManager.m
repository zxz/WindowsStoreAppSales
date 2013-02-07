//
//  RecordManager.m
//  Store
//
//  Created by 鄒 西中 on 2/7/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//

#import "RecordManager.h"
#import "Record.h"
@implementation RecordManager
+(RecordManager *)sharedInstance{
    static RecordManager* instance=nil;
    if(!instance){
        instance=[[RecordManager alloc]init];
    }
    return instance;
}
-(void)importRecords{
    
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc]init] ;
	[moc setPersistentStoreCoordinator:self.psc];
	[moc setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];

   NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	NSFileManager *fm = [[NSFileManager alloc] init] ;
	NSArray *fileNames = [fm contentsOfDirectoryAtPath:docPath error:NULL];
	
	
	for (NSString *fileName in fileNames) {
        
        Record *newRecord=[NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:moc];
        newRecord.appName=@"zxz";
//            newRecord.isbn=[bookInfo objectForKey:kIsbn];
//            newRecord.price=[NSNumber numberWithInt:[[bookInfo objectForKey:kPrice]intValue]];
//            newRecord.introduction=[bookInfo objectForKey:kIntroduction];
//            newRecord.quantity=[NSNumber numberWithInt:[[bookInfo objectForKey:kQuantity]intValue]];
//            newRecord.condition=[bookInfo objectForKey:kCondition];
//            newRecord.ship =[bookInfo objectForKey:kShip];
//            newRecord.image=[bookInfo objectForKey:kImage];
//            newRecord.sku=[bookInfo objectForKey:kSku];

    }
    NSError *saveError = nil;
    [moc save:&saveError];
    if (saveError) {
        NSLog(@"Could not save context: %@", saveError);
    }

}
@end
