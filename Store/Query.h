//
//  Query.h
//  Store
//
//  Created by XiZhong Zou on 2/9/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SaleCount.h"
@interface Query : NSObject
+(SaleCount *)appCount:(NSString *)appName country:(NSString *)country date:(id)date;
+(NSArray *)allAppNameInDate:(NSDate*)date;
+(NSArray *)countryWithAppName:(NSString *)appName date:(NSDate*)date;
+(NSArray *)arrayDictionaryToArray:(NSArray *)array WithKey:(NSString *)key;
@end
