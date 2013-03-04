//
//  ReviewManager.m
//  Store
//
//  Created by 鄒 西中 on 2/27/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//

#import "ReviewManager.h"
#import "Comment.h"
#import "Util.h"
#import "NSString+url.h"
@implementation ReviewManager
+ (ReviewManager *)sharedManager
{
	static ReviewManager *sharedManager = nil;
	if (sharedManager == nil)
		sharedManager = [ReviewManager new];
	return sharedManager;
}

-(void)fetchReviews:(NSDictionary *)appInfo
{
    [self htmlPage:appInfo];
    
}

-(void)htmlPage:(NSDictionary *)appInfo{
    //NSURL *sandboxStoreURL = [[NSURL alloc] initWithString: @"https://appdev.microsoft.com/StorePortals/en-US/Analytics/GetReportData/67f69611-1823-4e48-9974-c836c5b7a424/cdbc8787-b613-4141-9d76-98fcd3b727ec/1"];
    NSURL *sandboxStoreURL = [[NSURL alloc] initWithString: @"https://appdev.microsoft.com/StorePortals/en-US/Analytics/ChangeReviewPage"];
    for(NSString *key in [countrys allKeys]){
    
        NSString *dat=[NSString stringWithFormat: @"currentPage=1&market=%@&appID=%@",key,appInfo[kAppId]];
        //    NSString *dat=@"[{\"Name\":\"MarketFilter\",\"SelectedMembers\":[\"US\"]}]";
        NSData *postData =[NSData dataWithBytes:[dat UTF8String] length:[dat length]];
        NSMutableURLRequest *connectionRequest = [NSMutableURLRequest requestWithURL:sandboxStoreURL];
        [connectionRequest setHTTPMethod:@"POST"];
        [connectionRequest setTimeoutInterval:330.0];
        [connectionRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
        
        [connectionRequest setHTTPBody:postData];
        
        //    NSOperationQueue *queue=[NSOperationQueue mainQueue];
        NSData *data=[NSURLConnection sendSynchronousRequest:connectionRequest returningResponse:nil error:nil];
        NSString *info=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        [self analyzeData:info appName:appInfo[kAppName]];
        
        currentCount++;
        double currentProgress=(1.0)*currentCount/allCount;
 
        
        if ([self.delegate respondsToSelector:@selector(reviewProgress:)]) {
            [self.delegate reviewProgress:currentProgress];
        }
    }
    
}


-(NSArray *)allApplicationInfo{
    
    NSMutableArray *results=[NSMutableArray arrayWithCapacity:0];
    NSURL *pageURL = [[NSURL alloc] initWithString: @"https://appdev.microsoft.com/StorePortals/en-US/Home/Index"];
    NSString *pageHtml=[[NSString alloc]initWithContentsOfURL:pageURL encoding:NSUTF8StringEncoding error:nil];
    NSArray *appsHtml=[pageHtml componentsSeparatedByString:@"appDetailsContainer"];
    for(NSString * html in appsHtml){
        if([html rangeOfString:@"Downloads:"].location==NSNotFound) continue;
        NSArray *appIds= [self regexFetch:@"<div class=\"AnalyticsTile\" id=\"AnalyticsTile_(.+)\">" wholeString:html];
        NSArray *appName=[self regexFetch:@"<h3 class=\"clip\"><span>(.+)</span" wholeString:html];
        [results addObject:@{kAppName:appName[0],kAppId:appIds[0]}];
        
    }
    return results;
}

-(void)allReviewsSync{
    countrys=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"country_names" ofType:@"plist"]];
  NSArray *apps_= [self allApplicationInfo];
    currentCount=0;
    allCount=apps_.count * [[countrys allKeys] count];
    for(id app in apps_){
        [self fetchReviews:app];
    }
    
}

-(void)analyzeData:(NSString *)html appName:(NSString *)appName{
    
    NSArray *titles=[self regexFetch:@"ReviewCommentTitle\">(.+)</div" wholeString:html];
    NSArray *ratings=[self regexFetch:@"alt=\"(.+)\"" wholeString:html];
    NSArray *dates=[self regexFetch:@"TimeClass\">(.+)</span" wholeString:html];
    NSArray *comments=[self regexFetch:@"ReviewComment\">(.+)</div" wholeString:html];
    NSArray *appId=[self regexFetch:@"ApplicationID\"  value=\"(.+)\"" wholeString:html];
    NSArray *users=[self regexFetch:@"class=\"ReviewerHandle\" >(.+)</span>" wholeString:html];
    NSArray *country=[self regexFetch:@"SelectedMarket\"  value=\"(.+)\"" wholeString:html];
    
    int count=[titles count];
    if (count==0) {
        return;
    }
    NSManagedObjectContext *localContext  = [NSManagedObjectContext MR_contextForCurrentThread];
    
    for(int i=0;i<count;i++){
        NSDate *date=[Util stringToDate:dates[i]];
        if(![self hasRecordWithDate:date]){
            Comment *newRecord= [Comment MR_createInContext:localContext];
            newRecord.date=date;
            newRecord.title=[titles[i] stringByDecodingHTMLEntities];
            newRecord.rating=[NSNumber numberWithFloat:  [ratings[i] floatValue]];
            newRecord.review =[comments[i] stringByDecodingHTMLEntities];
            newRecord.appId=appId[0];
            newRecord.user=[users[i] stringByDecodingHTMLEntities];
            newRecord.countryCode=country[0];
            if ([countrys objectForKey:country[0]]) {
                newRecord.country=[countrys objectForKey:country[0]];
            }else{
                newRecord.countryCode=[countrys objectForKey:country[0]];
            }
            newRecord.appName=[appName stringByDecodingHTMLEntities];
        }
    }
    
    [localContext MR_save];
    
    
}
-(BOOL)hasRecordWithDate:(NSDate *)date
{
    NSPredicate * predicate=[NSPredicate predicateWithFormat:@"date=%@",date];
    NSNumber *count=[Comment MR_numberOfEntitiesWithPredicate:predicate];
    if (count.intValue>0) {
        return YES;
    }else{
        return  NO;
    }
}

-(NSArray *)regexFetch:(NSString *)regexExpression wholeString:(NSString *)html{
    NSError* error = nil;
    
    NSMutableArray *result=[NSMutableArray arrayWithCapacity:0];
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:regexExpression options:0 error:&error];
    NSArray* matches = [regex matchesInString:html options:0 range:NSMakeRange(0, [html length])];
    for ( NSTextCheckingResult* match in matches )
    {
        //        NSString* matchText = [html substringWithRange:[match range]];
        //        NSLog(@"match: %@", matchText);
        NSRange group1 = [match rangeAtIndex:1];
        // NSRange group2 = [match rangeAtIndex:2];
//        NSLog(@"group1: %@", [html substringWithRange:group1]);
        [result addObject:[html substringWithRange:group1]];
        //NSLog(@"group2: %@", [searchedString substringWithRange:group2]);
    }
    return result;
}

-(NSArray *)reviewsOfApp:(NSString *)appid{
    NSPredicate *filter=[NSPredicate predicateWithFormat:@"appName=%@",appid];
    NSArray *array=[Comment MR_findAllSortedBy:@"date"  ascending:NO withPredicate:filter inContext:[NSManagedObjectContext MR_defaultContext]];
    
    return array;
}

@end
