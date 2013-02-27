//
//  SaleCount.m
//  Store
//
//  Created by XiZhong Zou on 2/10/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//

#import "SaleCount.h"
#import "CurrencyManager.h"
@implementation SaleCount
-(int )realSaleCount{
    return self.saleCount-self.refundCount;
}
-(NSString *)description{
    if (self.refundCount >0) {
       return  [NSString stringWithFormat:@"%d-%d=%d %@%0.f",self.saleCount,self.refundCount,[self realSaleCount],[CurrencyManager sharedManager].baseCurrency,self.realSale];
    }

    return [NSString stringWithFormat:@"%d %@%0.f", self.saleCount,[CurrencyManager sharedManager].baseCurrency,self.realSale];
}
@end
