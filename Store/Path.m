//
//  Path.m
//  Store
//
//  Created by XiZhong Zou on 2/11/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//

#import "Path.h"

@implementation Path
+(NSString *) documentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"path=%@",[paths objectAtIndex:0]);
    return [paths objectAtIndex:0];
}

@end
