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
    NSString *result =[self htmlPage:appInfo];

}

-(NSString *)htmlPage:(NSDictionary *)appInfo{
    //NSURL *sandboxStoreURL = [[NSURL alloc] initWithString: @"https://appdev.microsoft.com/StorePortals/en-US/Analytics/GetReportData/67f69611-1823-4e48-9974-c836c5b7a424/cdbc8787-b613-4141-9d76-98fcd3b727ec/1"];
    NSURL *sandboxStoreURL = [[NSURL alloc] initWithString: @"https://appdev.microsoft.com/StorePortals/en-US/Analytics/ChangeReviewPage"];
    NSString *dat=[NSString stringWithFormat: @"currentPage=1&market=US&appID=%@",appInfo[kAppId]];
    //    NSString *dat=@"[{\"Name\":\"MarketFilter\",\"SelectedMembers\":[\"US\"]}]";
    NSData *postData =[NSData dataWithBytes:[dat UTF8String] length:[dat length]];
    NSMutableURLRequest *connectionRequest = [NSMutableURLRequest requestWithURL:sandboxStoreURL];
    [connectionRequest setHTTPMethod:@"POST"];
    [connectionRequest setTimeoutInterval:330.0];
    [connectionRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    
    [connectionRequest setHTTPBody:postData];
    //    [connectionRequest setHTTPShouldHandleCookies:YES];
    //    ///  NSArray *cookies=  [[NSHTTPCookieStorage sharedHTTPCookieStorage]cookiesForURL:[NSURL URLWithString:[self.urlField stringValue]]];
    //    NSArray *cookies=  [[NSHTTPCookieStorage sharedHTTPCookieStorage]cookies];
    //    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    //    //DLog(@"httpheader1:%@",[dict descriptionInStringsFileFormat]);
    //    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObjectsAndKeys:
    //                               sandboxStoreURL.host,@"Host",
    //                               @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X ) AppleWebKit/534.53.10 (KHTML, like Gecko) Version/5.1 Safari/534.53.10",@"User-Agent",
    //                               @"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8*",@"Accept",
    //                               @"ja,en-us;q=0.7,en;q=0.3",@"Accept-Language",
    //                               @"gzip, deflate",@"Accept-Encoding",
    //                               // self.urlField.stringValue,@"Referer",
    //                               @"keep-alive",@"Connection",
    //                               //@"video/x-flv",@"Content-Type",
    //                               nil];
    //
    //    [dict addEntriesFromDictionary:headers];
    //    // we are just recycling the original request
    //
    //    [connectionRequest setAllHTTPHeaderFields:dict];
    
    NSOperationQueue *queue=[NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:connectionRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (data) {
            NSString *result = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
           // NSLog(@"iapresult=%@",result);
           // return result;
        }else{
         //   return @"";
        }
    }];
    return @"";
}

-(NSArray *)allApplicationInfo{
    NSURL *pageURL = [[NSURL alloc] initWithString: @"https://appdev.microsoft.com/StorePortals/en-US/Home/Index"];
    NSString *pageHtml=[[NSString alloc]initWithContentsOfURL:pageURL encoding:NSUTF8StringEncoding error:nil];
  NSArray *appIds= [self regexFetch:@"<div class=\"AnalyticsTile\" id=\"AnalyticsTile_(.+)\">" wholeString:pageHtml];
//    <div class="appDetailFar">   <h3 class="clip"><span>
    
}

-(void)analyzeData:(NSString *)html{
    
    NSArray *titles=[self regexFetch:@"ReviewCommentTitle\">(.+)</div" wholeString:html];
    NSArray *ratings=[self regexFetch:@"alt=\"(.+)\"" wholeString:html];
    NSArray *dates=[self regexFetch:@"TimeClass\">(.+)</span" wholeString:html];
    NSArray *comments=[self regexFetch:@"ReviewComment\">(.+)</div" wholeString:html];
    NSArray *appId=[self regexFetch:@"ApplicationID\"  value=\"(.+)\"" wholeString:html];
    int count=[titles count];
    NSManagedObjectContext *localContext  = [NSManagedObjectContext MR_defaultContext];

    for(int i=0;i<count;i++){
        NSDate *date=[Util stringToDate:dates[i]];
        if(![self hasRecordWithDate:date]){
        Comment *newRecord= [Comment MR_createInContext:localContext];
        newRecord.date=date;
        newRecord.title=titles[i];
        newRecord.rating=[NSNumber numberWithFloat:  [ratings[i] floatValue]];
        newRecord.review =comments[i];
        newRecord.appId=appId[0];
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
        NSLog(@"group1: %@", [html substringWithRange:group1]);
        [result addObject:[html substringWithRange:group1]];
        //NSLog(@"group2: %@", [searchedString substringWithRange:group2]);
    }
    return result;
}

-(NSArray *)reviewsOfApp:(NSString *)appid{
  NSPredicate *filter=[NSPredicate predicateWithFormat:@"appId=%@",appid];
    NSArray *array=[Comment MR_findAllSortedBy:@"date"  ascending:NO withPredicate:filter inContext:[NSManagedObjectContext MR_defaultContext]];

    return array;
}

@end
