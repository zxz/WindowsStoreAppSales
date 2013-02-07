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
    
    moc = [[NSManagedObjectContext alloc]init] ;
	[moc setPersistentStoreCoordinator:self.psc];
	[moc setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];

   NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	NSFileManager *fm = [[NSFileManager alloc] init] ;
	NSArray *fileNames = [fm contentsOfDirectoryAtPath:docPath error:NULL];
//	NSString *filePath=[[NSBundle mainBundle]pathForResource:@"1" ofType:@"csv"];
	
	for (NSString *fileName in fileNames) {
        [self importFile:[ docPath stringByAppendingPathComponent:fileName]];
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

-(void)importFile:(NSString *)filePath{
    NSString *fileContent=[[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *rows=[fileContent componentsSeparatedByString:@"\n"];
    
    if ([rows count]<2) {
        return ;
    }
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterCurrencyStyle];

    for (int i=1; i<[rows count]-1;i++) {
      NSArray *details= [rows[i] componentsSeparatedByString:@","];
        Record *newRecord=[NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:moc];
        newRecord.date=[self dateFromReportDateString:details[0]];
        
        newRecord.appName=details[1];
        newRecord.transactionType=details[2];
        newRecord.offer=details[3];
        newRecord.country=details[4];
        newRecord.currency=details[5];
        NSNumber * myNumber = [f numberFromString:details[6]];
        newRecord.price=myNumber;
        newRecord.storeFee=[f numberFromString:details[7]];
        newRecord.proceedSale=[f numberFromString:details[8]];
        newRecord.proceedLocalSale=[NSNumber numberWithInt:0];//this is empty
        if ([details[10] length]==2) {
            newRecord.isSettled=[NSNumber numberWithBool:NO];
        }else{
            newRecord.isSettled=[NSNumber numberWithBool:YES];
        }
        newRecord.paymentDate=nil;//this is empty

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

@end
