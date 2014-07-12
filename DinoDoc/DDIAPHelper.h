//
//  DDIAPHelper.h
//  DinoDoc
//
//  Created by Swapnil Takalkar on 5/31/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import <StoreKit/StoreKit.h>
UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;
UIKIT_EXTERN NSString *const IAPHelperFailedPurchasedNotification;
#import <Foundation/Foundation.h>

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface DDIAPHelper : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;

- (void)buyProduct:(SKProduct *)product;
- (BOOL)productPurchased:(NSString *)productIdentifier;
- (void)restoreCompletedTransactions;

@end
