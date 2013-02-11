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

@end
