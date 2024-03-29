//
//  Query.m
//  Store
//
//  Created by XiZhong Zou on 2/9/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//
#import "Comment.h"
#import "Query.h"
#import "Record.h"
#import "CurrencyManager.h"
@implementation Query
+(SaleCount *)appCount:(NSString *)appName country:(NSString *)country date:(id )date{
    NSPredicate *filter;
    NSPredicate *filter2;
    NSArray *array1;
    NSArray *array2;
    if(appName==nil && country==nil&&[date isKindOfClass:[NSArray class]]){
        filter=[NSPredicate predicateWithFormat:@"date>%@ and date<%@ and price >0",date[0],date[1]];
        filter2=[NSPredicate predicateWithFormat:@"date>%@ and date<%@ and price <0",date[0],date[1]];
    }
    else if(appName==nil && country==nil&&date){
        filter=[NSPredicate predicateWithFormat:@"date=%@ and price >0",date];
        filter2=[NSPredicate predicateWithFormat:@"date=%@ and price <0",date];
    }
    else if(!country&&[date isKindOfClass:[NSArray class]]){
        filter=[NSPredicate predicateWithFormat:@"date>%@ and date<%@ and appName=%@ and price >0",date[0],date[1],appName];
        filter2=[NSPredicate predicateWithFormat:@"date>%@ and date<%@ and appName=%@ and price <0",date[0],date[1],appName];
    }
    else if (!country&&date) {// all country
        filter=[NSPredicate predicateWithFormat:@"date=%@ and appName=%@ and price >0",date,appName];
        filter2=[NSPredicate predicateWithFormat:@"date=%@ and appName=%@ and price <0",date,appName];
    }
    else if(!date&&!country&&!appName){//all date and country
        filter=[NSPredicate predicateWithFormat:@"price>0"];
        filter2=[NSPredicate predicateWithFormat:@"price<0"];
    }
    else if(!date&&!country&&appName){
        filter=[NSPredicate predicateWithFormat:@"price>0 and appName=%@",appName];
        filter2=[NSPredicate predicateWithFormat:@"price<0 and appName=%@",appName];
    }
    else if(!date&&country&&appName){
        filter=[NSPredicate predicateWithFormat:@"price>0 &&country=%@ and appName=%@",country,appName];
        filter2=[NSPredicate predicateWithFormat:@"price<0 and country=%@ and appName=%@",country,appName];
        
    }
    else if([date isKindOfClass:[NSArray class]])
    {
        filter=[NSPredicate predicateWithFormat:@"date>%@ and date<%@ and appName=%@ and country=%@ and price >0",date[0],date[1],appName, country];
        filter2=[NSPredicate predicateWithFormat:@"date>%@ and date<%@ and appName=%@ and country=%@ and price <0",date[0],date[1],appName, country];
    }
    
    else{
        filter=[NSPredicate predicateWithFormat:@"date=%@ and appName=%@ and country=%@ and price >0",date,appName, country];
        filter2=[NSPredicate predicateWithFormat:@"date=%@ and appName=%@ and country=%@ and price <0",date,appName, country];
        
    }
    
    array1=[Record MR_findAllWithPredicate:filter inContext:[NSManagedObjectContext MR_defaultContext]];
    array2=[Record MR_findAllWithPredicate:filter2 inContext:[NSManagedObjectContext MR_defaultContext]];
    float realSale=0;
    float refundSale=0;
    for(Record *record in array1){
        float money= [[CurrencyManager sharedManager]convertValue:record.proceedSale.floatValue fromCurrency:record.currency];
        realSale=realSale+money;
    }
    
    for(Record *record in array2){
        float money= [[CurrencyManager sharedManager]convertValue:record.proceedSale.floatValue fromCurrency:record.currency];
        refundSale=refundSale+money;
    }
    
    SaleCount *salecount=[[SaleCount alloc]init];
    salecount.allSale=realSale;
    salecount.refundSale=refundSale;
    salecount.realSale=realSale+refundSale;
    salecount.saleCount=array1.count;
    salecount.refundCount=array2.count;
    return salecount;
    
}


+(NSArray *)countryWithAppName:(NSString *)appName date:(id)date{
    NSPredicate *filter;
    if(date){
        if ([date isKindOfClass:[NSArray class]]) {
            filter=[NSPredicate predicateWithFormat:@"date>%@ and date<%@ and appName=%@",date[0],date[1],appName];
            
        }else{
            filter=[NSPredicate predicateWithFormat:@"date=%@ and appName=%@",date,appName];
        }
    }else{
        filter=[NSPredicate predicateWithFormat:@"appName=%@",appName];
    }
    NSFetchRequest *countryRequest=[Record MR_requestAllWithPredicate:filter inContext:[NSManagedObjectContext MR_defaultContext]];
    [countryRequest setResultType:NSDictionaryResultType];
    [countryRequest setReturnsDistinctResults:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"appName.numOfEntities" ascending:YES] ;
    [countryRequest setSortDescriptors:@[sortDescriptor2]];
    [countryRequest setPropertiesToFetch:@[kCountry]];
    NSArray *country=[Record MR_executeFetchRequest:countryRequest inContext:[NSManagedObjectContext MR_defaultContext]];
    return  [self arrayDictionaryToArray:country WithKey:kCountry];
}

+(NSArray *)allAppNameInDate:(id)date{
    //    NSPredicate *filter = [NSPredicate predicateWithFormat:@"date=%@",self.date];
    NSFetchRequest *dateRequest;
    if (date) {
        if ([date isKindOfClass:[NSArray class]]) {
            dateRequest = [Record MR_requestAllWhere:kDate isEqualTo:(NSDate*)[date firstObject] ];

        }else{
        dateRequest = [Record MR_requestAllWhere:kDate isEqualTo:date];
        }
        
    }else{
        dateRequest=[Record MR_requestAllInContext:[NSManagedObjectContext MR_defaultContext]];
    }
    [dateRequest setResultType:NSDictionaryResultType];
    [dateRequest setReturnsDistinctResults:YES];
    [dateRequest setPropertiesToFetch:@[kAppName]];
    NSArray *apps= [Record MR_executeFetchRequest:dateRequest inContext:[NSManagedObjectContext MR_defaultContext]];
    return  [self arrayDictionaryToArray:apps WithKey:kAppName];
}

+(NSArray *)allAppNameInReview{
    NSFetchRequest *request;
    request=[Comment MR_requestAllInContext:[NSManagedObjectContext MR_defaultContext]];
    [request setResultType:NSDictionaryResultType];
    [request setReturnsDistinctResults:YES];
    [request setPropertiesToFetch:@[kAppName]];
    NSArray *apps=[Comment MR_executeFetchRequest:request inContext:[NSManagedObjectContext MR_defaultContext]];
    return [self arrayDictionaryToArray:apps WithKey:kAppName];
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
