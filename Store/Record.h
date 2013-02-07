//
//  Record.h
//  Store
//
//  Created by 鄒 西中 on 2/7/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Record : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * transactionType;
@property (nonatomic, retain) NSString * offer;
@property (nonatomic, retain) NSNumber * storeFee;
@property (nonatomic, retain) NSNumber * proceedSale;
@property (nonatomic, retain) NSString * appName;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * currency;
@property (nonatomic, retain) NSNumber * isSettled;
@property (nonatomic, retain) NSNumber * proceedLocalSale;
@property (nonatomic, retain) NSDate * paymentDate;
@end
