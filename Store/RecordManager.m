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
    
    //    moc = [[NSManagedObjectContext alloc]init] ;
    //	[moc setPersistentStoreCoordinator:self.psc];
    //	[moc setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    [Record MR_truncateAllInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_save];
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(docPath);
	NSFileManager *fm = [[NSFileManager alloc] init] ;
	NSArray *fileNames = [fm contentsOfDirectoryAtPath:docPath error:NULL];
    //	NSString *filePath=[[NSBundle mainBundle]pathForResource:@"1" ofType:@"csv"];
	double currentIndex=0;
	for (NSString *fileName in fileNames) {
        currentIndex++;
        
        if ([self.delegate respondsToSelector:@selector(recordProgress:)]) {
            [self.delegate recordProgress:currentIndex/fileNames.count ];
        }
        NSLog(fileName);
        [self importFile:[ docPath stringByAppendingPathComponent:fileName] shouldRemoveOld:NO];
    }
    NSError *saveError = nil;
    //    [moc save:&saveError];
    if (saveError) {
        NSLog(@"Could not save context: %@", saveError);
    }
    
}

-(void)importFile:(NSString *)filePath shouldRemoveOld:(BOOL) shouldRemove{
    if (!filePath) {
        return;
    }
    NSString *fileContent=[[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    if (!fileContent) {
        return;
    }
    fileContent=[fileContent stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSArray *rows=[fileContent componentsSeparatedByString:@"\n"];
    
    if ([rows count]<2) {
        return ;
    }
    NSManagedObjectContext *localContext  = [NSManagedObjectContext MR_contextForCurrentThread];
    
    for (int i=1; i<[rows count]-1;i++) {
        NSArray *details= [rows[i] componentsSeparatedByString:@","];
        NSDate *insertDate=[self dateFromReportDateString:details[0]];
        
        if (shouldRemove) {
            if(i==1){
                NSPredicate *predict=[NSPredicate predicateWithFormat:@"date=%@",insertDate];
                if ([Record MR_countOfEntitiesWithPredicate:predict]>0) {
                    [Record MR_deleteAllMatchingPredicate:predict];
                }
            }

        }
        else{
            
        if (![self hasRecordWithDate:insertDate]) {
            tempDate=insertDate;
        }
        else{
            if (![insertDate isEqualToDate: tempDate]) {
                continue;
            }
        }
            
        }
        Record *newRecord= [Record MR_createInContext:localContext];
        newRecord.date=insertDate;
        newRecord.appName=details[1];
        newRecord.transactionType=details[2];
        newRecord.offer=details[3];
        newRecord.country=details[4];
        newRecord.currency=details[5];
        newRecord.price=[NSNumber numberWithFloat:[details[6] floatValue]];;
        newRecord.storeFee=[NSNumber numberWithFloat:[details[7] floatValue]];
        newRecord.proceedSale=[NSNumber numberWithDouble:[details[8] floatValue]];
        newRecord.proceedLocalSale=[NSNumber numberWithInt:0];//this is empty
        
        if ([details[10] length]==2) {
            newRecord.isSettled=[NSNumber numberWithBool:NO];
        }else{
            newRecord.isSettled=[NSNumber numberWithBool:YES];
        }
        newRecord.paymentDate=nil;//this is empty
        
    }
    [localContext MR_save];
}

-(BOOL)hasRecordWithDate:(NSDate *)date
{
    NSPredicate * predicate=[NSPredicate predicateWithFormat:@"date=%@",date];
    NSNumber *count=[Record MR_numberOfEntitiesWithPredicate:predicate];
    if (count.intValue>0) {
        return YES;
    }else{
        return  NO;
    }
}

-(NSDate *)dateFromReportDateString:(NSString *)dateString
{
	dateString = [dateString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	BOOL containsSlash = [dateString rangeOfString:@"/"].location == NSNotFound;
    
    if (containsSlash) {
        return  [NSDate dateWithTimeIntervalSince1970:0];
    }
    NSArray *dates=[dateString componentsSeparatedByString:@"/"];
	int year, month, day;
    // new date format
    year = [dates[2] intValue];
    month = [dates[0] intValue];
    day = [dates[1] intValue];
	
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	[calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	NSDateComponents *components = [[NSDateComponents alloc] init];
	[components setYear:year];
	[components setMonth:month];
	[components setDay:day];
	NSDate *date = [calendar dateFromComponents:components];
	return date;
}
-(void)refreshData{
    [self.delegate reloadData];
}
@end
