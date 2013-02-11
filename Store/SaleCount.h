//
//  SaleCount.h
//  Store
//
//  Created by XiZhong Zou on 2/10/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaleCount : NSObject
@property (assign,nonatomic) int saleCount;
@property (assign,nonatomic) int refundCount;
-(int )realSaleCount;
@end
