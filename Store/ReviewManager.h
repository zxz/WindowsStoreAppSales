//
//  ReviewManager.h
//  Store
//
//  Created by 鄒 西中 on 2/27/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//

@protocol ReviewManagerDelegate <NSObject>
@optional
-(void) reviewProgress:(double)progress;
@end

#import <Foundation/Foundation.h>

@interface ReviewManager : NSObject
{
    NSDictionary *countrys;
   int currentCount;
    int allCount;
}
@property (strong,nonatomic) id<ReviewManagerDelegate> delegate;
+ (ReviewManager *)sharedManager;
-(void)analyzeData:(NSString *)html appName:(NSString *)appName;
-(NSArray *)allApplicationInfo;
-(NSArray *)reviewsOfApp:(NSString *)appid;
-(void)fetchReviews:(NSDictionary *)appInfo;
-(void)allReviewsSync;
@end
