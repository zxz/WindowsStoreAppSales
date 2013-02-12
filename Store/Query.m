//
//  Query.m
//  Store
//
//  Created by XiZhong Zou on 2/9/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//

#import "Query.h"
#import "Record.h"
#import "CurrencyManager.h"
@implementation Query
+(SaleCount *)appCount:(NSString *)appName country:(NSString *)country date:(NSDate *)date{
    NSPredicate *filter;
    NSNumber *count;
    NSPredicate *filter2;
    NSNumber *refundCount;
    NSArray *array1;
    NSArray *array2;
    if(appName==nil && country==nil&&date){
        filter=[NSPredicate predicateWithFormat:@"date=%@ and price >0",date];
        filter2=[NSPredicate predicateWithFormat:@"date=%@ and price <0",date];
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
   else{
        filter=[NSPredicate predicateWithFormat:@"date=%@ and appName=%@ and country=%@ and price >0",date,appName, country];
        filter2=[NSPredicate predicateWithFormat:@"date=%@ and appName=%@ and country=%@ and price <0",date,appName, country];

    }
    array1=[Record MR_findAllWithPredicate:filter];
    array2=[Record MR_findAllWithPredicate:filter2];
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
    salecount.realSale=realSale-refundSale;
    salecount.saleCount=array1.count;
    salecount.refundCount=array2.count;
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
