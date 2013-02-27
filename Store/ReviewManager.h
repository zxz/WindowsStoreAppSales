//
//  ReviewManager.h
//  Store
//
//  Created by 鄒 西中 on 2/27/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReviewManager : NSObject
+ (ReviewManager *)sharedManager;
-(void)analyzeData:(NSString *)html;
-(NSArray *)reviewsOfApp:(NSString *)appid;
@end
