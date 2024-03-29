//
//  Util.m
//  Store
//
//  Created by XiZhong Zou on 2/11/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//

#import "Util.h"

@implementation Util
+(NSString *)dateToString:(NSDate*)date{
    static NSDateFormatter *formatter=nil;
    if(formatter==nil){
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        
    }
    
    //Optionally for time zone converstions
    //    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}
+(NSString *)dateDetailToString:(NSDate*)date{
    static NSDateFormatter *formatter=nil;
    if(formatter==nil){
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm a"];
        
    }
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+(NSDate *)stringToDate:(NSString*)string{
    static NSDateFormatter *formatter=nil;
    if(formatter==nil){
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy HH:mm a"];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    }
    
    //Optionally for time zone converstions
    //    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    NSDate *formatterDate = [formatter dateFromString:string];
    return formatterDate;
}

@end
