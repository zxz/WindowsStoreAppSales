//
//  NSString+url.h
//  MPX
//
//  Created by Xi Zhong Zou on 6/13/12.
//  Copyright (c) 2012 インタナール. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (url)
+(NSString *) urlencode: (NSString *) url;
+(NSString *) urldecode: (NSString *) url;
- (NSString *)stringByDecodingURLFormat;
- (NSString *)stringByEscapingForURLArgument;
- (NSString *)stringByUnescapingFromURLArgument;
@end
