//
//  Query.m
//  Store
//
//  Created by XiZhong Zou on 2/9/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//

#import "Query.h"
#import "Record.h"
@implementation Query
+(SaleCount *)appCount:(NSString *)appName country:(NSString *)country date:(NSDate *)date{
    NSPredicate *filter;
    NSNumber *count;
    NSPredicate *filter2;
    NSNumber *refundCount;
    
    if(appName==nil && country==nil&&date){
        filter=[NSPredicate predicateWithFormat:@"date=%@ and price >0",date];
        count=[Record MR_numberOfEntitiesWithPredicate:filter];
        filter2=[NSPredicate predicateWithFormat:@"date=%@ and price <0",date];
        refundCount=[Record MR_numberOfEntitiesWithPredicate:filter2];
    }
   else if (!country&&date) {// all country
        filter=[NSPredicate predicateWithFormat:@"date=%@ and appName=%@ and price >0",date,appName];
        count=[Record MR_numberOfEntitiesWithPredicate:filter];
        filter2=[NSPredicate predicateWithFormat:@"date=%@ and appName=%@ and price <0",date,appName];
        refundCount=[Record MR_numberOfEntitiesWithPredicate:filter2];
        
    }
   else if(!date&&!country&&!appName){//all date and country
       filter=[NSPredicate predicateWithFormat:@"price>0"];
       count=[Record MR_numberOfEntitiesWithPredicate:filter];
       filter2=[NSPredicate predicateWithFormat:@"price<0"];
       refundCount=[Record MR_numberOfEntitiesWithPredicate:filter2];
   }
   else if(!date&&!country&&appName){
       filter=[NSPredicate predicateWithFormat:@"price>0 and appName=%@",appName];
       count =[Record MR_numberOfEntitiesWithPredicate:filter];
       filter2=[NSPredicate predicateWithFormat:@"price<0 and appName=%@",appName];
       refundCount=[Record MR_numberOfEntitiesWithPredicate:filter2];
   }
   else if(!date&&country&&appName){
       filter=[NSPredicate predicateWithFormat:@"price>0 &&country=%@ and appName=%@",country,appName];
       count =[Record MR_numberOfEntitiesWithPredicate:filter];
       filter2=[NSPredicate predicateWithFormat:@"price<0 and country=%@ and appName=%@",country,appName];
       refundCount=[Record MR_numberOfEntitiesWithPredicate:filter2];
   }
   else{
        filter=[NSPredicate predicateWithFormat:@"date=%@ and appName=%@ and country=%@ and price >0",date,appName, country];
        count=[Record MR_numberOfEntitiesWithPredicate:filter];
        filter2=[NSPredicate predicateWithFormat:@"date=%@ and appName=%@ and country=%@ and price <0",date,appName, country];
        refundCount=[Record MR_numberOfEntitiesWithPredicate:filter2];
    }
    SaleCount *salecount=[[SaleCount alloc]init];
    salecount.saleCount=[count intValue];
    salecount.refundCount=[refundCount intValue];
    return salecount;
    
}


+(NSArray *)countryWithAppName:(NSString *)appName date:(NSDate*)date{
    NSPredicate *filter;
    if(date){
    filter=[NSPredicate predicateWithFormat:@"date=%@ and appName=%@",date,appName];
    }else{
        filter=[NSPredicate predicateWithFormat:@"appName=%@",appName];
    }
    NSFetchRequest *countryRequest=[Record MR_requestAllWithPredicate:filter];
    [countryRequest setResultType:NSDictionaryResultType];
    [countryRequest setReturnsDistinctResults:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"appName.numOfEntities" ascending:YES] ;
    [countryRequest setSortDescriptors:@[sortDescriptor2]];
    [countryRequest setPropertiesToFetch:@[kCountry]];
    NSArray *country=[Record MR_executeFetchRequest:countryRequest];
    return  [self arrayDictionaryToArray:country WithKey:kCountry];
}

+(NSArray *)allAppNameInDate:(NSDate*)date{
    //    NSPredicate *filter = [NSPredicate predicateWithFormat:@"date=%@",self.date];
    NSFetchRequest *dateRequest;
    if (date) {
       dateRequest = [Record MR_requestAllWhere:kDate isEqualTo:date];

    }else{
        dateRequest=[Record MR_requestAllInContext:[NSManagedObjectContext MR_defaultContext]];
    }
    [dateRequest setResultType:NSDictionaryResultType];
    [dateRequest setReturnsDistinctResults:YES];
    [dateRequest setPropertiesToFetch:@[kAppName]];
    NSArray *apps= [Record MR_executeFetchRequest:dateRequest];
    return  [self arrayDictionaryToArray:apps WithKey:kAppName];
}
+(NSArray *)arrayDictionaryToArray:(NSArray *)array WithKey:(NSString *)key
{
    NSMutableArray *appNames=[NSMutableArray arrayWithCapacity:0];
    
    for(id item in array){
        [appNames addObject:item[key]];
    }
    return appNames;
    
}

@end
